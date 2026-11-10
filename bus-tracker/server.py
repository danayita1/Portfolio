import hmac
import json
import math
import os
import sqlite3

from flask import Flask, jsonify, request, send_from_directory

app = Flask(__name__)

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
DB_PATH = os.path.join(BASE_DIR, "buses.db")

# Buses that haven't reported in this many minutes are hidden from the map
STALE_MINUTES = 5

# Speed is measured from a bus's positions over this many minutes
SPEED_WINDOW_MINUTES = 2
# Position history older than this is deleted
HISTORY_MINUTES = 10
# Measured speeds outside this range are ignored (stopped, or a GPS glitch)
MIN_SPEED_KMH = 3
MAX_SPEED_KMH = 70

# Routes. Each has a name, a color, and stops in order.
# These coordinates are approximate placeholders. Replace with real stops.
ROUTES = {
    "route_1": {
        "name": "Meskel Square - Bole Airport (sample)",
        "color": "#2980b9",
        "stops": [
            {"name": "Meskel Square", "lat": 9.0107, "lng": 38.7612},
            {"name": "Stop 2 (placeholder)", "lat": 9.0050, "lng": 38.7700},
            {"name": "Stop 3 (placeholder)", "lat": 8.9990, "lng": 38.7790},
            {"name": "Stop 4 (placeholder)", "lat": 8.9930, "lng": 38.7880},
            {"name": "Bole Airport", "lat": 8.9779, "lng": 38.7993},
        ],
    }
}


# Driver access codes live in drivers.json, which is NOT uploaded to GitHub.
# It is read on every request, so editing the file takes effect immediately.
def load_drivers():
    try:
        with open(os.path.join(BASE_DIR, "drivers.json")) as f:
            return json.load(f)
    except (OSError, ValueError):
        return {}


def get_db():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn


# Create the tables the first time the server runs
def init_db():
    conn = get_db()
    conn.execute(
        """
        CREATE TABLE IF NOT EXISTS buses (
            bus_id     TEXT PRIMARY KEY,
            route_id   TEXT NOT NULL,
            lat        REAL NOT NULL,
            lng        REAL NOT NULL,
            updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
        )
        """
    )
    # Recent positions, used to measure how fast each bus is really moving
    conn.execute(
        """
        CREATE TABLE IF NOT EXISTS positions (
            id         INTEGER PRIMARY KEY AUTOINCREMENT,
            bus_id     TEXT NOT NULL,
            lat        REAL NOT NULL,
            lng        REAL NOT NULL,
            created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
        )
        """
    )
    conn.execute(
        "CREATE INDEX IF NOT EXISTS idx_positions_bus ON positions (bus_id, id)"
    )
    conn.commit()
    conn.close()


init_db()


# Distance in meters between two latitude/longitude points
def haversine_m(lat1, lng1, lat2, lng2):
    r = 6371000
    p1 = math.radians(lat1)
    p2 = math.radians(lat2)
    dp = p2 - p1
    dl = math.radians(lng2 - lng1)
    h = math.sin(dp / 2) ** 2 + math.cos(p1) * \
        math.cos(p2) * math.sin(dl / 2) ** 2
    return 2 * r * math.asin(math.sqrt(h))


# How fast a bus has really been moving, in km/h, or None if we can't tell
def recent_speed_kmh(conn, bus_id):
    rows = conn.execute(
        "SELECT lat, lng, CAST(strftime('%s', created_at) AS INTEGER) AS t "
        "FROM positions WHERE bus_id = ? AND created_at >= datetime('now', ?) "
        "ORDER BY id",
        (bus_id, f"-{SPEED_WINDOW_MINUTES} minutes"),
    ).fetchall()
    if len(rows) < 2:
        return None

    first, last = rows[0], rows[-1]
    seconds = last["t"] - first["t"]
    if seconds < 30:
        return None

    meters = haversine_m(first["lat"], first["lng"], last["lat"], last["lng"])
    kmh = meters / seconds * 3.6
    if kmh < MIN_SPEED_KMH or kmh > MAX_SPEED_KMH:
        return None
    return round(kmh, 1)


@app.after_request
def allow_browser_access(response):
    response.headers["Access-Control-Allow-Origin"] = "*"
    response.headers["Access-Control-Allow-Headers"] = "Content-Type"
    response.headers["Access-Control-Allow-Methods"] = "GET, POST, OPTIONS"
    return response


@app.route("/routes")
def routes():
    return jsonify(ROUTES)


@app.route("/location", methods=["GET", "POST", "OPTIONS"])
def location():
    if request.method == "OPTIONS":
        return "", 204

    # A driver's phone sends a location. Check the access code first.
    if request.method == "POST":
        data = request.get_json(silent=True) or {}
        bus_id = str(data.get("bus_id", "")).strip()
        code = str(data.get("code", ""))
        route_id = data.get("route_id")

        if not bus_id:
            return jsonify({"error": "bus_id is required"}), 400

        expected = load_drivers().get(bus_id)
        if expected is None or not hmac.compare_digest(
            str(expected).encode(), code.encode()
        ):
            return jsonify({"error": "wrong bus ID or access code"}), 403

        if route_id not in ROUTES:
            return jsonify({"error": "unknown route_id"}), 400

        try:
            lat = float(data["lat"])
            lng = float(data["lng"])
        except (KeyError, TypeError, ValueError):
            return jsonify({"error": "lat and lng must be numbers"}), 400

        conn = get_db()
        conn.execute(
            """
            INSERT INTO buses (bus_id, route_id, lat, lng, updated_at)
            VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP)
            ON CONFLICT(bus_id) DO UPDATE SET
                route_id = excluded.route_id,
                lat = excluded.lat,
                lng = excluded.lng,
                updated_at = CURRENT_TIMESTAMP
            """,
            (bus_id, route_id, lat, lng),
        )
        # Keep a short history of positions, and delete old ones
        conn.execute(
            "INSERT INTO positions (bus_id, lat, lng) VALUES (?, ?, ?)",
            (bus_id, lat, lng),
        )
        conn.execute(
            "DELETE FROM positions WHERE created_at < datetime('now', ?)",
            (f"-{HISTORY_MINUTES} minutes",),
        )
        conn.commit()
        conn.close()
        return jsonify({"status": "saved"})

    # The rider map asks for all buses that reported recently (no code needed)
    conn = get_db()
    rows = conn.execute(
        "SELECT bus_id, route_id, lat, lng FROM buses "
        "WHERE updated_at >= datetime('now', ?)",
        (f"-{STALE_MINUTES} minutes",),
    ).fetchall()

    buses = {}
    for row in rows:
        buses[row["bus_id"]] = {
            "lat": row["lat"],
            "lng": row["lng"],
            "route_id": row["route_id"],
            "speed_kmh": recent_speed_kmh(conn, row["bus_id"]),
        }
    conn.close()
    return jsonify(buses)


@app.route("/")
def rider_page():
    return send_from_directory(BASE_DIR, "index.html")


@app.route("/driver")
def driver_page():
    return send_from_directory(BASE_DIR, "driver.html")


if __name__ == "__main__":
    app.run(debug=True, port=5001)

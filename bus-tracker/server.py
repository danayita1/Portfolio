from flask import Flask, jsonify, request, send_from_directory

app = Flask(__name__)

# The latest bus location. It starts at the beginning of our pretend route.
bus_location = {"lat": 9.0107, "lng": 38.7612}


# Lets a web page opened from your computer talk to this server
@app.after_request
def allow_browser_access(response):
    response.headers["Access-Control-Allow-Origin"] = "*"
    response.headers["Access-Control-Allow-Headers"] = "Content-Type"
    response.headers["Access-Control-Allow-Methods"] = "GET, POST, OPTIONS"
    return response


@app.route("/location", methods=["GET", "POST", "OPTIONS"])
def location():
    global bus_location

    # The browser asks this first before sending data; just say "OK"
    if request.method == "OPTIONS":
        return "", 204

    # The driver's phone sends a new location
    if request.method == "POST":
        data = request.get_json()
        bus_location = {"lat": data["lat"], "lng": data["lng"]}
        return jsonify({"status": "saved"})

    # The rider's map asks for the latest location
    return jsonify(bus_location)

# The rider map page


@app.route("/")
def rider_page():
    return send_from_directory(".", "index.html")


# The driver page
@app.route("/driver")
def driver_page():
    return send_from_directory(".", "driver.html")


if __name__ == "__main__":
    app.run(debug=True, port=5000)

# Bus Tracker


A live bus tracking web app, built to solve a real problem in Addis Ababa: many buses have no GPS trackers, so riders wait at stops without knowing when the bus will arrive.

**Live demo:** https://danayitdev.pythonanywhere.com/

## How it works

- **Driver page** (`/driver`): the driver taps one button and the phone shares its GPS location.
- **Server** (`server.py`): a small Flask app that stores the bus's latest location.
- **Rider map** (`/`): a Leaflet map that asks the server for the location every 2 seconds and moves the bus on the map.

## Run it locally

1. Install Python 3 and Flask: `pip install flask`
2. Start the server: `python server.py`
3. Open `http://127.0.0.1:5000/` for the rider map.
4. Open `http://127.0.0.1:5000/driver` and click "Start sharing location".

## Tech used

Python, Flask, JavaScript, Leaflet, OpenStreetMap, HTML, CSS

## Roadmap

- [ ] Support multiple buses
- [ ] Routes and stops for a real Addis Ababa route
- [ ] Estimated arrival time at a stop
- [ ] Database storage
- [x] 
- [ ] Driver login

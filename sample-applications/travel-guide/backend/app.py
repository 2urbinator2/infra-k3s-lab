from flask import Flask, jsonify
from flask_cors import CORS
import random

app = Flask(__name__)
CORS(app)

quotes = [
    "Brandenburg Gate", 
    "Berlin Wall Memorial", 
    "Reichstag Building", 
    "Museum Island", 
    "Alexanderplatz", 
    "Checkpoint Charlie", 
    "Berlin Cathedral", 
    "East Side Gallery", 
    "Potsdamer Platz", 
    "Charlottenburg Palace",
]

@app.route("/quote")
def get_quote():
    return jsonify({"quote": random.choice(quotes)})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5003)
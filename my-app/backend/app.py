from flask import Flask, jsonify
from flask_cors import CORS
import random

app = Flask(__name__)

quotes = [
    "Kubernetes rocks!",
    "Container all the things!",
    "Keep calm and kubectl apply -f",
    "Pods > VMs"
]

@app.route("/quote")
def get_quote():
    return jsonify({"quote": random.choice(quotes)})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
"""
Simple Flask app for CI/CD demo.
Students can extend this with new endpoints, db calls, etc.
"""
import os
from flask import Flask, jsonify

app = Flask(__name__)

APP_VERSION = os.getenv("APP_VERSION", "1.0.0")
APP_ENV = os.getenv("APP_ENV", "development")


@app.route("/")
def home():
    return jsonify({
        "message": "Hello from the CI/CD demo!",
        "version": APP_VERSION,
        "environment": APP_ENV,
    })


@app.route("/health")
def health():
    # Used by Docker HEALTHCHECK and Kubernetes liveness probes.
    return jsonify({"status": "ok"}), 200


@app.route("/api/add/<int:a>/<int:b>")
def add(a, b):
    return jsonify({"a": a, "b": b, "sum": a + b})


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

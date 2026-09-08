import os
import requests

from flask import Flask, render_template

app = Flask(__name__)

BACKEND_URL = os.getenv(
    "BACKEND_URL",
    "http://localhost:8080"
)

@app.route("/")
def home():
    return render_template(
        "index.html"
    )

@app.route("/health")
def health():
    return {
        "status": "healthy"
    }

@app.route("/ready")
def ready():
    return {
        "status": "ready"
    }

@app.route("/backend-info")
def backend_info():
    try:
        response = requests.get(
            f"{BACKEND_URL}/api/info",
            timeout=5
        )

        response.raise_for_status()
        return response.json()

    except requests.RequestException as error:
        return {
            "error": str(error)
        }, 502

if __name__ == "__main__":
    app.run(
        host="0.0.0.0",
        port=8081
    )
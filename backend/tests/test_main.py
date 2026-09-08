from fastapi.testclient import TestClient

from app.main import app


client = TestClient(app)


def test_root():

    response = client.get("/")

    assert response.status_code == 200

    assert response.json() == {
        "message": "Multi-Cloud Backend API"
    }


def test_health():

    response = client.get("/health")

    assert response.status_code == 200

    assert response.json() == {
        "status": "healthy"
    }


def test_ready():

    response = client.get("/ready")

    assert response.status_code == 200

    assert response.json() == {
        "status": "ready"
    }


def test_info():

    response = client.get("/api/info")

    assert response.status_code == 200

    data = response.json()

    assert "application" in data

    assert "cloud" in data

    assert "platform" in data
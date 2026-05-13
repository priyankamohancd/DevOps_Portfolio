"""
Tests for the Flask app. These run inside the CI pipeline.
Demonstrates the 'test' stage of CI/CD.
"""
import pytest
from app import app


@pytest.fixture
def client():
    app.config["TESTING"] = True
    with app.test_client() as client:
        yield client


def test_home_returns_200(client):
    response = client.get("/")
    assert response.status_code == 200
    assert b"Hello" in response.data


def test_health_endpoint(client):
    response = client.get("/health")
    assert response.status_code == 200
    assert response.get_json() == {"status": "ok"}


def test_add_endpoint(client):
    response = client.get("/api/add/2/3")
    data = response.get_json()
    assert data["sum"] == 5


def test_add_large_numbers(client):
    response = client.get("/api/add/1000/2000")
    data = response.get_json()
    assert data["sum"] == 3000

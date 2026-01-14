import os
import sys
import json

# Ensure the main package path is importable by tests
sys.path.append(os.path.join(os.path.dirname(__file__), '..', 'main'))

from app import app as flask_app


def test_health():
    client = flask_app.test_client()
    rv = client.get('/health')
    assert rv.status_code == 200
    data = rv.get_json()
    assert data.get('status') == 'ok'

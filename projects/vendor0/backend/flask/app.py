import os
import uuid
from flask import Flask, request, jsonify
from flask_cors import CORS
from dotenv import load_dotenv

# Redacted, minimal Flask app used for portfolio presentation.
# This intentionally contains stubbed logic and in-memory storage to
# demonstrate the shape of the real service without including secrets
# or direct production Firestore access.

load_dotenv()

def create_app():
    app = Flask(__name__)
    origins = os.getenv("CORS_ORIGINS", "http://localhost:*,http://127.0.0.1:*,https://example.com")
    CORS(app, resources={r"/*": {"origins": [o.strip() for o in origins.split(",")] }}, supports_credentials=True)

    # In-memory stubs for portfolio
    slug_store = {}  # slug -> owner_id
    bookings = []

    @app.get('/healthz')
    def healthz():
        return jsonify({"status": "ok"})

    @app.post('/reserve-slug')
    def reserve_slug():
        # Expected JSON: { "slug": "desired-slug", "owner_id": "vendor123" }
        payload = request.get_json(silent=True) or {}
        slug = str(payload.get('slug', '')).strip().lower()
        owner_id = str(payload.get('owner_id', '')).strip() or None
        if not slug:
            return jsonify({"error": "missing slug"}), 400

        existing = slug_store.get(slug)
        if existing and existing != owner_id:
            return jsonify({"status": "taken"}), 409

        # Reserve for owner (idempotent)
        slug_store[slug] = owner_id or f'owner-{uuid.uuid4().hex[:8]}'
        return jsonify({"status": "reserved", "slug": slug}), 201

    @app.post('/public/bookings')
    def public_bookings():
        # Accepts booking payloads from public customers; server-side would
        # normally validate and write to Firestore using admin credentials.
        payload = request.get_json(silent=True) or {}
        owner = payload.get('owner_uid') or payload.get('owner')
        customer = payload.get('customer')
        date = payload.get('date')
        if not owner or not customer or not date:
            return jsonify({"error": "owner, customer and date required"}), 400

        # create a stub booking id
        bid = uuid.uuid4().hex
        bookings.append({'id': bid, 'owner': owner, 'customer': customer, 'date': date})
        return jsonify({"status": "created", "id": bid}), 201

    # Additional admin/protected endpoints would validate JWTs and talk to
    # Firestore/GCP in the real project. They are intentionally omitted here.

    return app


if __name__ == '__main__':
    port = int(os.getenv('PORT', '5000'))
    app = create_app()
    # Local dev only: debug True
    app.run(host='0.0.0.0', port=port, debug=True)

import logging
import os

from dotenv import load_dotenv
from flask import Flask, jsonify, request
from flask_cors import CORS

from services.auth_service import require_auth
from services.booking_service import BookingService
from services.slug_service import SlugService
from utils.error_logger import log_error
from utils.rate_limiter import rate_limit

load_dotenv()

logging.basicConfig(level=logging.INFO, format="%(levelname)s %(name)s %(message)s")

# Application-scoped service instances (in-memory repositories for portfolio demo).
# Production: inject Firestore-backed repositories via create_app() factory args.
_slug_service = SlugService()
_booking_service = BookingService()


def create_app() -> Flask:
    app = Flask(__name__)
    origins = [
        o.strip()
        for o in os.getenv(
            "CORS_ORIGINS", "http://localhost:*,http://127.0.0.1:*,https://example.com"
        ).split(",")
    ]
    CORS(app, resources={r"/*": {"origins": origins}}, supports_credentials=True)

    @app.get("/healthz")
    def healthz():
        return jsonify({"status": "ok"})

    @app.post("/reserve-slug")
    @rate_limit
    @require_auth
    def reserve_slug():
        """Reserve a unique public URL slug for the authenticated vendor.

        Requires:  Authorization: Bearer <firebase-id-token>
        Body:      { "slug": "my-vendor", "owner_id": "<uid>" }
        Returns:   201 reserved | 200 already_owned | 409 taken | 400 invalid
        """
        body = request.get_json(silent=True) or {}
        slug = str(body.get("slug", "")).strip().lower()
        owner_id = str(body.get("owner_id", "")).strip()

        if not slug or not owner_id:
            return jsonify({"error": "slug and owner_id are required"}), 400

        result = _slug_service.reserve(slug, owner_id)
        status = result["status"]

        if status == "invalid":
            return jsonify(result), 400
        if status == "taken":
            return jsonify(result), 409
        if status == "already_owned":
            return jsonify(result), 200
        return jsonify(result), 201

    @app.post("/public/bookings")
    @rate_limit
    def public_booking():
        """Accept a customer booking submitted from a vendor's public form.

        Intentionally unauthenticated — the booking form is public.
        owner_uid is validated server-side against the slug ownership record
        in production to prevent spoofing.

        Body:    { "owner_uid": "...", "customer": "...", "date": "..." }
        Returns: 201 created | 400 validation error | 500 internal error
        """
        body = request.get_json(silent=True) or {}
        try:
            booking = _booking_service.create_booking(body)
            return jsonify({"status": "created", "id": booking["id"]}), 201
        except ValueError as exc:
            return jsonify({"error": str(exc)}), 400
        except Exception as exc:
            log_error(exc, context="public_booking")
            return jsonify({"error": "internal_server_error"}), 500

    return app


if __name__ == "__main__":
    port = int(os.getenv("PORT", "5000"))
    create_app().run(host="0.0.0.0", port=port, debug=True)


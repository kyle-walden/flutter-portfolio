import functools
import logging

from flask import g, jsonify, request

logger = logging.getLogger(__name__)

try:
    import firebase_admin
    from firebase_admin import auth as firebase_auth

    _firebase_available = True
except ImportError:
    _firebase_available = False
    logger.warning("firebase-admin not installed; token verification is stubbed")


def verify_id_token(id_token: str) -> dict:
    """Verify a Firebase ID token. Returns decoded claims dict.

    In production the real firebase-admin SDK validates the token against
    Google's public keys. This stub accepts any non-empty token so the
    service can be demonstrated without a live Firebase project.
    """
    if not id_token:
        raise ValueError("missing_token")

    if not _firebase_available:
        # Stub: accept any non-empty token for portfolio demo.
        return {"uid": f"stub-uid-{id_token[:8]}", "email": "stub@example.com"}

    try:
        return firebase_auth.verify_id_token(id_token)
    except Exception as exc:
        logger.warning("Token verification failed: %s", exc)
        raise ValueError("invalid_or_expired_token") from exc


def require_auth(f):
    """Decorator: extract Bearer token, verify it, attach claims to flask.g."""

    @functools.wraps(f)
    def decorated(*args, **kwargs):
        auth_header = request.headers.get("Authorization", "")
        if not auth_header.startswith("Bearer "):
            return jsonify({"error": "missing_token"}), 401
        token = auth_header[len("Bearer "):]
        try:
            g.claims = verify_id_token(token)
        except ValueError as exc:
            return jsonify({"error": str(exc)}), 401
        return f(*args, **kwargs)

    return decorated

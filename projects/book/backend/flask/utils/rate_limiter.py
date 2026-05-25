import functools
import time
from collections import defaultdict

from flask import jsonify, request

# Sliding-window in-memory rate limiter.
# Production recommendation: replace _request_log with Redis for multi-instance deployments.
_WINDOW_SECONDS = 60
_MAX_REQUESTS = 30
_request_log: dict[str, list[float]] = defaultdict(list)


def rate_limit(f):
    """Per-IP sliding-window rate limiter (30 req / 60 s).

    Decorates Flask route handlers. Returns 429 when the limit is exceeded.
    """

    @functools.wraps(f)
    def decorated(*args, **kwargs):
        ip = request.remote_addr or "unknown"
        now = time.time()
        window_start = now - _WINDOW_SECONDS

        # Evict expired timestamps
        _request_log[ip] = [t for t in _request_log[ip] if t > window_start]

        if len(_request_log[ip]) >= _MAX_REQUESTS:
            return jsonify({"error": "rate_limit_exceeded"}), 429

        _request_log[ip].append(now)
        return f(*args, **kwargs)

    return decorated

import logging
import traceback

from flask import request

logger = logging.getLogger("vendor0")


def log_error(exc: Exception, context: str = "") -> None:
    """Log a structured error entry with request context.

    Fields: error type, context label, HTTP method, path, client IP, traceback.
    """
    logger.error(
        "error=%s context=%s method=%s path=%s ip=%s\n%s",
        type(exc).__name__,
        context or "unspecified",
        getattr(request, "method", "N/A"),
        getattr(request, "path", "N/A"),
        getattr(request, "remote_addr", "N/A"),
        traceback.format_exc(),
    )

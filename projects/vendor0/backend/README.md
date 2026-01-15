# Backend

## Purpose

Provide thin, server-side capabilities that complement the Flutter client: authoritative slug reservation and validation, server-side booking creation (to avoid client-write rules), and operational endpoints (health, metrics). The backend is intentionally small—Firestore remains the primary data store and the backend acts as a secure, auditable layer for operations that require server authority.

## Tech Stack

- Runtime: Python 3.11 (Flask) for the lightweight API stub in this repo
- Web server: Gunicorn (production container)
- Hosting / deployment: Google Cloud Run (recommended) / Cloud Build for CI
- Data store: Google Firestore (primary), Firebase Auth (ID tokens)
- Local dev: python-dotenv for environment variables

## Architecture Overview

- Client (Flutter Web)
  - Authenticates with Firebase Auth and holds ID tokens for vendor users.
- Thin API (Flask on Cloud Run)
  - Validates incoming ID tokens (for protected endpoints) using Firebase Admin SDK.
  - Performs server-authoritative operations (reserve slug, create server-side booking) and writes to Firestore using admin credentials.
  - Exposes a public booking endpoint that accepts unauthenticated customer submissions and performs server-side normalization and rate limiting.
- Firestore
  - Primary source of truth for vendor documents, availability, bookings and slug reservations.

## Flask app structure (this repo)

- `backend/flask/app.py` — single-file, redacted Flask app used for portfolio demonstrations. Contains route handlers, in-memory stubs and comments indicating production intent.
- `backend/flask/requirements.txt` — pinned Python dependencies (Flask, Flask-Cors, python-dotenv).
- `backend/flask/Dockerfile` — production-ready image pattern (pip install, gunicorn, non-root user, and `$PORT` binding).
- `backend/flask/.env.example` — example environment variables used for local development (CORS origins, PORT).
- `backend/flask/README.md` — runnable notes for local dev.

In production the Flask app is containerized and deployed to Cloud Run. The container uses environment variables (no credentials checked into the repo) and relies on a Cloud service account with Firestore access.

## Key Endpoints / Triggers

- `GET /healthz` — simple readiness/health probe.
- `POST /reserve-slug` — reserve a unique public slug for a vendor.
  - Recommended payload: `{ "slug": "desired", "owner_id": "vendor-id" }`.
  - Responses: `201 created` (reserved), `200` (already owned by same owner), `409` (taken by another owner), `400` (invalid payload).
- `POST /public/bookings` — public booking submission for a vendor (accepts `owner_uid` or slug resolution).
  - Server-side normalization, basic rate limiting, and writes to Firestore (production).

## Security Considerations

- Authentication & Authorization:
  - Protect vendor-only endpoints by verifying Firebase ID tokens server-side using the Firebase Admin SDK.
- Data validation & rate limiting:
  - Validate input shapes server-side and implement rate limiting for public endpoints (demo uses an in-memory limiter; use Redis or Cloud Memorystore for production scale).

## Notes

- This backend folder contains a redacted, in-memory stub intended for portfolio presentation. The real service used in production runs on Cloud Run behind a managed identity 

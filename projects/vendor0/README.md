
# vendor0

**Production web app** — booking management platform for service vendors.

---

## Highlight: Slug-Based Public Booking Form

Each vendor reserves a unique URL slug (`/public/<slug>`). The challenge: enforce ownership server-side so slugs can't be spoofed, while keeping the public booking form fully unauthenticated for customers.

```
Vendor reserves slug          Customer submits booking
  Flutter client                 /public/<slug> form
       │                               │
       │  POST /reserve-slug           │  POST /public/bookings
       │  Bearer <firebase-token>      │  (no auth required)
       ▼                               ▼
   ┌─────────────────────────────────────────┐
   │              Flask API (Cloud Run)       │
   │                                          │
   │  @require_auth   @rate_limit             │
   │       │                │                 │
   │   AuthService      RateLimiter           │
   │       │                                  │
   │   SlugService ──► SlugRepository         │
   │   BookingService ► BookingRepository     │
   └─────────────────────────────────────────┘
              │
              ▼
         Firestore  (production swap for in-memory stubs)
```

**Key code:** [app.py](backend/flask/app.py) · [slug_service.py](backend/flask/services/slug_service.py) · [auth_service.py](backend/flask/services/auth_service.py) · [slug_repository.py](backend/flask/repositories/slug_repository.py)

---

## Tech Stack

Flutter Web · Flask (Cloud Run) · Firestore · Firebase Auth · GitHub Actions

## Architecture

Flask backend follows **Services Repository** pattern — route handlers delegate entirely to services; services orchestrate business logic; repositories own persistence.

See [`backend/flask/`](backend/flask/) for the full layer breakdown.

## Status

Production · Flutter Web · Solo developer



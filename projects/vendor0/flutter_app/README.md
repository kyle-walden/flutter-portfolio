# Flutter App

## Purpose

This repository contains the Flutter Web client for a vendor-facing booking management portal and a public-facing booking form. It is the UI layer only — authentication, long-term storage and server-side validation are handled by backend services (Firestore + a thin Flask API).

## App Architecture

- Feature-first layout under `lib/features/` (each feature contains `models/`, `repo/`, `state/`, `view/`).
- Clear layering:
	- `lib/app/` — app bootstrap, routing, theme, top-level provider wiring.
	- `lib/core/` — small service abstractions (HTTP, Firestore) and UI utilities.
	- `lib/features/` — feature modules (vendor_info, booking_management, booking_form).
	- `lib/shared_widgets/` — lightweight shared UI primitives.
- Data responsibilities:
	- Repos encapsulate external I/O (Firestore queries, HTTP to Flask).
	- Providers (ChangeNotifier) manage in-memory state and expose operations to views.
	- Views are thin and declarative — they call providers, not services directly.

This structure mirrors a production-ready separation of concerns while remaining compact for portfolio review.

## State Management

- `provider` (ChangeNotifier) is used as the primary state mechanism.
- Each feature exposes a provider under `state/` (for example `VendorProvider`, `BookingProvider`, `BookingFormProvider`).
- Rationale: providers keep the surface area small, integrate with Flutter widgets easily, and make CI-friendly unit testing straightforward. For heavier, cross-cutting concerns a redux/Bloc style approach could be introduced, but provider is a pragmatic choice for this portfolio-sized codebase.

## Data Flow

1. UI triggers an operation on a Provider (e.g., reserve slug, submit booking).
2. Provider delegates to a Repo which performs the external call:
	 - `FirestoreService` (reads/writes vendor documents and resolves slug -> vendor)
	 - `HttpService` (posts JSON to the Flask API for slug reservation and public bookings)
3. Repo returns domain data to Provider which updates state and notifies views.

Example: public booking form flow
- Client opens `/public/<slug>` → `BookingFormScreen`.
- `VendorProvider.loadVendorBySlug(slug)` resolves slug → vendor id via `FirestoreService` (stubbed here).
- `BookingProvider.loadAvailability(vendorId)` loads availability rules from Firestore (demo rules in this skeleton).
- Customer submits form → `BookingFormProvider` posts payload to Flask `/public/bookings` including `owner_uid` (resolved vendor id).

## Folder Structure

- `lib/main.dart` — app entrypoint (web). Bootstraps `lib/app/`.
- `lib/app/` — MaterialApp, routing, top-level providers and theming.
- `lib/core/`
	- `services/` — `http_service.dart`, `firestore_service.dart` (thin abstractions; replace stubs with real implementations).
	- `utils/` — app theme and small helpers.
- `lib/features/` — feature-first modules:
	- `vendor_info/` — vendor profile, slug reservation flows (models, repo, provider, views).
	- `booking_management/` — vendor availability and booking management (models, repo, provider).
	- `booking_form/` — public booking form (repo, provider, view).
- `lib/shared_widgets/` — small, reusable widgets used across features.

## Key Design Decisions

- Feature-first organization: keeps feature code colocated (models, repo, state, view) for easier review and refactor.
- Provider (ChangeNotifier) for state: minimal boilerplate with good test ergonomics for this app size.
- Thin HTTP/Firestore abstractions: repos centralize I/O so the providers and views remain testable and framework-agnostic.
- Server-side ownership and validation: slug reservation is mediated via an authenticated owner id and the Flask service — ownership logic belongs on the server, not the client.

## Testing

- Unit tests: providers and repos should be unit tested with mocked `FirestoreService`/`HttpService`.
- Widget tests: key screens (VendorDashboard, BookingForm) can be widget-tested with provider overrides to assert UI state flows.
- Smoke/integration: run the demo Flask backend under `backend/flask` and exercise `/healthz`, `/reserve-slug`, and `/public/bookings` during CI smoke steps.

## Notes

- This folder is an abstracted, redacted representation intended for portfolio consumption. Several production integrations are intentionally stubbed:
	- Firebase Auth is not wired — use `loadVendorByAuthId(userId)` to integrate after adding auth.
	- `FirestoreService` contains demo stubs; replace with real Firestore client code and index queries for slug resolution in production.
	- The backend folder contains a redacted Flask stub; the real service runs on Cloud Run and performs server-side validation and Firestore writes.


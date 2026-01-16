# Architecture Patterns
This document summarizes the recurring architecture patterns used across the `projects/` apps (for example `projects/pitboard` and `projects/vendor0`).

Goal: provide a concise reference of shape, responsibilities, and data flows so reviewers and contributors can quickly understand how features, state, services, and the backend are organized.

Refer to concrete examples in:
- `projects/pitboard/flutter_app/README.md`
- `projects/vendor0/flutter_app/README.md`

## Quick Index
- [Core principles](#core-principles)
- [Folder mapping (typical)](#folder-mapping-typical)
- [State management](#state-management)
- [Data flow (UI → backend)](#data-flow-ui--backend)
- [Offline-first and sync patterns (project-specific)](#offline-first-and-sync-patterns-project-specific)
- [Repositories and services](#repositories-and-services)
- [Backend boundaries](#backend-boundaries)
- [S]

## Core principles

- Feature-first organization: keep models, state, views, and tests colocated under `lib/features/<feature>/` for discoverability and small change surfaces.
- Explicit layering: UI → Providers (state) → Repositories → Core Services → External systems (Firestore, HTTP, Storage).
- Single source of truth: repositories and the sync adapter centralize data ownership and caching.
- Keep platform code minimal: prefer Dart/services unless a native API requires a platform channel.
- Low-ops backend interactions: favour serverless/backends with clear boundaries (see `projects/*/backend` or `firebase/functions`).

## Folder mapping (typical)

- `lib/app/` — app bootstrap, routing, global provider wiring
- `lib/core/` — infra services (HTTP, Firebase wrappers, local persistence), utils and shared helpers
- `lib/features/<feature>/` — feature modules containing `view/`, `widgets/`, `state/` (providers/controllers), `repo/` and `models/`
- `lib/shared_widgets/` — reusable UI primitives
- `firebase/functions/` or `backend/` — server-side logic (Cloud Functions or Flask) handling server-authoritative rules and background work

## State management

- Primary mechanism: `provider` (ChangeNotifier / ValueNotifier)
	- Per-feature providers live under `lib/features/<feature>/state/` and own observable state for that feature.
	- Global providers (auth, session, app-wide settings) are wired in `lib/app/app.dart`.
	- Services are injected into providers (constructor or provider scope) to keep providers thin and testable.

- Trade-offs and rationale:
	- Provider keeps boilerplate low and integrates cleanly with widget rebuilds.
	- Providers act as controllers, delegating I/O and heavy logic to repositories/services so unit tests remain fast and deterministic.
	- The codebase is organized to allow migrating the provider layer to another state solution (e.g., Riverpod or Bloc) with minimal repository/service changes.

## Data flow (UI → backend)

1. UI emits intents to a feature provider (user actions, lifecycle events).
2. Provider calls into a repository for data operations.
3. Repository orchestrates I/O via `core/services` (e.g., `FirebaseService`, `HttpService`, `HiveService`).
4. Core services perform network/storage operations and return results to the repository.
5. Repository returns domain objects or Futures to the provider which updates observable state.

Notes:
- Prefer local cache reads when available; repositories hide caching and sync logic from providers.
- Use callable functions / authenticated HTTP endpoints for server-authoritative operations.

## Offline-first and sync patterns (project-specific)

- Local cache: use a lightweight local DB (e.g., Hive) as the client's primary cache and source-of-truth for runtime UX (see `projects/pitboard` example).
- Write-behind queue: writes are queued locally and flushed to the backend by a sync adapter that handles retries, batching, and conflict metadata.
- Read strategy: read from cache first; fall back to remote fetch and then populate cache.
- Conflicts: resolve at sync boundary with server-authoritative rules; surface conflict metadata to the UI as needed.

## Repositories and services

- Repositories
	- Encapsulate data ownership and mapping between DTOs and domain models.
	- Centralize queries, pagination, and projection logic.

- Core services
	- Thin adapters for external systems (Firestore, HTTP APIs, local persistence, analytics).
	- Keep side-effects and platform integration code here. Providers should not call network APIs directly.

## Backend boundaries

- Server responsibilities
	- Validation, ownership, billing/webhook handling, heavy algorithms, and anything requiring strong consistency or secrecy should live on the backend (see `projects/*/backend` or `firebase/functions`).
- Client responsibilities
	- UI, local caching, optimistic updates, and enqueueing offline writes.

## Security and auth patterns

- Token-based auth: client authenticates via Firebase Auth (ID tokens) and sends tokens to protected endpoints.
- Prefer callable functions for authenticated client → server calls when using Firebase Functions.
- Enforce role checks server-side using custom claims or server ACLs; do not rely on client-side flags for authorization.
- Use Firestore security rules for direct client access where feasible, and restrict sensitive operations to functions.

## Testing guidance

- Unit tests
	- Services, repositories, and providers should be unit-tested with dependency mocks (mock `FirebaseService`, `HttpService`, `HiveService`).

- Widget tests
	- Test critical screens with provider overrides to inject fake services or repositories.

- Integration/E2E
	- Use emulator suites or a controlled backend (staging) for end-to-end tests. The `firebase/emulator` directory in project backends and `functions/tests` provide examples in this repo.

## CI / CD

- CI runs linting, unit tests, and widget tests. For projects with backend functions, CI runs build/test and optional deploy steps to staging via GitHub Actions.
- Keep deploy steps minimal and environment-driven: use runtime config or secret manager; do not store secrets in the repo.

## Patterns & anti-patterns (quick)

- Patterns to follow
	- Thin controllers (providers) that delegate to services/repositories.
	- Collocate feature code for easier changes (`lib/features/<feature>/...`).
	- Centralize sync, caching and conflict resolution in repositories/sync adapters.

- Anti-patterns to avoid
	- Calling external APIs directly from UI widgets.
	- Spreading Firestore query logic across UI or multiple providers.
	- Committing secrets or environment-specific configs.

## Where to look for examples

- Client examples: `projects/pitboard/flutter_app/README.md` and `projects/vendor0/flutter_app/README.md`.
- Backend functions: `projects/pitboard/backend/firebase/functions/src` contains `index.ts` and `services/sessionAggregator.ts` as an example of keeping heavier logic server-side.

---

For feature-level details, corresponding `lib/features/<feature>/README.md` are created (if present) inside each project.


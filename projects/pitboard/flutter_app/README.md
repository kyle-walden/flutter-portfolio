# Flutter App

## Purpose

- The mobile client layer for the Pitboard product: a single Flutter codebase that implements the UI, client-side state, local persistence, and platform integrations required for the shipped iOS and Android apps.

## App Architecture

- Feature-first, layered architecture aligned with the repo layout:
	- Entry: `lib/main.dart` and `lib/app/app.dart` bootstrap the app and wire global providers and routing.
	- Features: each feature lives under `lib/features/<feature>/` and typically contains `view/`, `widgets/`, `state/`, and `tests/`.
	- Core services: shared platform and infra services live under `lib/core/services/` (examples: `firebase_service.dart`, `hive_service.dart`, `location_service.dart`).
	- Utilities and shared components: `lib/core/utils/` and `lib/shared_widgets/` contain helpers and reusable UI pieces.
	- Platform integrations: minimal native code surfaced via platform channels; keep most logic in Dart unless platform APIs require native implementations.

## State Management

- Package: `provider` (see `pubspec.yaml`) is the primary state-management dependency.
- Pattern and placement:
	- State is scoped per-feature under `lib/features/<feature>/state/` using `ChangeNotifier` and `ValueNotifier` for observable state.
	- Global, app-scoped providers (auth, session, feature toggles) are wired in `lib/app/app.dart` and exposed via the provider tree.
	- Services (network, persistence, platform bridges) live in `lib/core/services/` and are injected into providers via constructor injection or the provider scope.
- Rationale:
	- Low ceremony and clear ownership: per-feature ChangeNotifiers keep UI rebuild surface small and predictable.
	- Testability: providers are thin controllers delegating to testable services/repositories.
	- Migration path preserved: code organization allows replacing provider with Riverpod/Bloc with limited surface changes.

## Data Flow

- Typical flow:
  1. UI emits intents (user actions) to a feature provider/controller in `lib/features/<feature>/state`.
  2. Provider delegates to a repository layer; repositories live either per-feature (e.g., `lib/features/auth/repo/`) or under `lib/repositories/` depending on scope.
  3. Repositories coordinate with core services under `lib/core/services/` (examples: `hive_service.dart` for local persistence, `firebase_service.dart` for network sync) to satisfy reads/writes.
  4. Repositories return data or futures to providers which update observable state for the UI.
  **Note**: Calling core services directly from providers is acceptable for small, ephemeral, UI-only actions (prefs, simple analytics, navigation) but avoid it for data ownership and syncable state.

- Offline-first specifics in this codebase:
	- Local cache is the primary source of truth for the client runtime; caching is implemented with `hive` and exposed via `lib/core/services/hive_service.dart`.
	- Authentication triggers remote persistence with Firestore (`cloud_firestore`) for server-side storage. The client implements full CRUD against Firestore when authenticated and falls back to local cache when offline.
	- Read strategy: prefer local cache; when missing, fetch from remote (`firebase_service.dart`), then cache locally.
	- Write strategy: writes are queued locally (write-behind). A sync queue service retries failed operations with backoff and flushes successful operations to Firestore when connectivity/auth is available.
	- Conflict resolution: handled at the sync boundary with server-authoritative rules; the sync adapter exposes sync status and conflict metadata so providers can present consistent UI state and recovery options.

- Rationale:
	- Cache-first improves perceived performance and provides a usable UX on flaky or absent connections.
	- Centralizing data access in repositories (instead of scattering service calls across providers) creates a single seam for caching, mapping, retry logic and test doubles.
	- Queueing writes locally (write-behind) ensures durability and lets the sync adapter handle retries, batching, and failure handling without blocking UI flows.
	- Server-authoritative conflict resolution keeps client logic simpler and places correctness guarantees on the backend; exposing conflict metadata allows the UI to surface meaningful recovery options.
	- Auth-gated remote sync prevents accidental remote writes before a user is authenticated and scopes remote ownership to the authenticated principal.


## Folder Structure

- `lib/` — application entry and source (top-level)
  - `main.dart` — app entry and environment bootstrap
  - `app/` — `app.dart` and top-level provider/routing wiring
  - `core/` — shared infra and utilities
    - `core/services/` — auth, persistence, platform and external service adapters (e.g., `firebase_service.dart`, `hive_service.dart`)
    - `core/utils/` — small helpers and formatters
  - `features/` — feature modules (each feature commonly contains `view/`, `widgets/`, `state/`, `repo/`, and `tests/`)
    - `features/auth/` — authentication repo and state
    - `features/home/`, `features/history/`, `features/pre_session/` — feature implementations
  - `shared_widgets/` — reusable UI components (e.g., `buttons.dart`, `cards.dart`, `loaders.dart`)
  - `pubspec.yaml`, `test/`, and other project-level files sit alongside `lib/` (not listed here)

## Testing

- Current snapshot:
	- Top-level `test/widget_test.dart` exists (basic widget smoke test).
	- Feature-level `tests/` folders are present under `lib/features/*/tests/` but are empty in this redacted extract.

- Intended test surface (production repo):
	- Unit tests for `core/services/*`, repositories, and providers that cover business logic, sync/merge behavior, and queue handling.
	- Widget tests for critical screens and common shared widgets in `shared_widgets/`.
	- Integration/E2E: full-device flows and release smoke tests are executed in separate infrastructure (not included in this public snapshot).

- CI:
	- CI runs the available unit and widget tests; public extract maintains modest coverage targets. Full test suites and integration runners exist in the private repo.

## Notes

- This folder is a redacted client-layer snapshot. Production secrets, some implementation files, and environment-specific wiring are intentionally omitted.
- Architectural intent and folder references are accurate; some implementation details are removed for security and confidentiality.


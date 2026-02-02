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

```text
┌─────────────────────────────────────────────────────────────────┐
│                        USER INTERACTION                         │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│  LAYER 1: VIEW (lib/features/<feature>/view/)                   │
│  ├─ history_page.dart                                           │
│  └─ Purpose: Render UI, capture user events (tap, swipe, etc.)  │
└─────────────────────────────────────────────────────────────────┘
                              ↓ calls methods on
┌─────────────────────────────────────────────────────────────────┐
│  LAYER 2: STATE (lib/features/<feature>/state/)                 │
│  ├─ history_provider.dart (ChangeNotifier)                      │
│  └─ Purpose: Hold observable state, coordinate business logic   │
│     • Listens to user events from view                          │
│     • Delegates data operations to repository                   │
│     • Notifies UI when state changes                            │
└─────────────────────────────────────────────────────────────────┘
                              ↓ calls
┌─────────────────────────────────────────────────────────────────┐
│  LAYER 3: REPOSITORY (lib/features/<feature>/repo/)             │
│  ├─ history_repository.dart                                     │
│  └─ Purpose: Data orchestration and business rules              │
│     • Abstract data sources (local cache vs remote API)         │
│     • Implements caching strategy (cache-first, remote-first)   │
│     • Handles offline queue and sync logic                      │
│     • Maps between DTOs and domain models                       │
│     • Centralizes all data access for this feature              │
└─────────────────────────────────────────────────────────────────┘
                              ↓ uses
┌─────────────────────────────────────────────────────────────────┐
│  LAYER 4: CORE SERVICES (lib/core/services/)                    │
│  ├─ firebase_service.dart (Firestore wrapper)                   │
│  ├─ hive_service.dart (Local DB wrapper)                        │
│  ├─ http_service.dart (HTTP client wrapper)                     │
│  └─ Purpose: Thin adapters to external systems                  │
│     • Platform/SDK integration (Firebase, Hive, Dio)            │
│     • No business logic—just I/O operations                     │
│     • Injected into repositories for testability                │
└─────────────────────────────────────────────────────────────────┘
                              ↓ calls
┌─────────────────────────────────────────────────────────────────┐
│  EXTERNAL SYSTEMS                                               │
│  ├─ Firestore (users/{uid}/history collection)                  │
│  ├─ Firebase Functions (callable endpoints)                     │
│  ├─ REST APIs (backend/flask endpoints)                         │
│  └─ Local storage (Hive boxes)                                  │
└─────────────────────────────────────────────────────────────────┘
```


## Folder Responsibilities (Feature-Level)

### **`/view`** — Presentation Layer (UI)
- **What**: Screens, pages, and UI layouts
- **Responsibility**: 
  - Render widgets based on state
  - Capture user gestures and input
  - Call methods on providers/controllers
- **Example**: `history_page.dart` displays a list of items from `HistoryProvider`
- **Rules**: 
  - NO business logic here
  - NO direct API calls
  - Only reads state and triggers actions

### **`/state`** — Controller/State Management Layer
- **What**: Providers, BLoCs, Cubits, or Controllers
- **Responsibility**:
  - Hold observable state (loading flags, data lists, error messages)
  - Coordinate feature workflows (e.g., load → fetch → refresh)
  - Delegate I/O to repositories
  - Notify listeners when state changes
- **Example**: `history_provider.dart` exposes `items`, `isLoading`, and methods like `createItem()`, `deleteItem()`
- **Rules**:
  - Thin—don't put heavy logic here
  - Inject repositories (constructor or provider)
  - No direct Firebase/HTTP calls

### **`/repo`** — Data Orchestration Layer
- **What**: Repository classes that own data access for this feature
- **Responsibility**:
  - Abstract where data comes from (cache vs network)
  - Implement caching strategies:
    - **Cache-first**: Read local, fallback to remote
    - **Remote-first**: Fetch from API, update cache
    - **Write-behind**: Queue writes locally, sync to backend
  - Handle offline/online sync and conflict resolution
  - Map DTOs (data transfer objects) to domain models
  - Centralize queries, pagination, filtering
- **Example**: `history_repository.dart`:
  - Uses `HiveService` for local cache
  - Uses `FirebaseService` for remote sync
  - Maintains an offline queue (`history_queue` box)
  - Exposes `getAllLocal()`, `create()`, `update()`, `delete()`, `flushQueueIfAuthenticated()`
- **Rules**:
  - Single source of truth for feature data
  - Services injected (not instantiated internally)
  - No UI code

### **`/data`** (Optional—sometimes merged with `/repo`)
- **What**: Data sources and adapters
- **Responsibility**:
  - Remote data sources (API clients, Firestore queries)
  - Local data sources (Hive, SQLite, SharedPreferences)
  - DTOs (raw JSON → Dart objects)
- **When to use**:
  - If you want strict separation: `/data` for sources, `/repo` for orchestration
  - In smaller features, collapse into `/repo`

### **`/models`** — Domain Models
- **What**: Data classes representing feature entities
- **Responsibility**:
  - Define the shape of domain objects (e.g., `HistoryItem`)
  - Serialization/deserialization (fromJson, toJson)
  - Business validation (if lightweight)
- **Example**: `HistoryItem` class with `id`, `title`, `subtitle`
- **Rules**:
  - Immutable where possible
  - No I/O logic
  - Can live at feature level or in `lib/core/models/` if shared across features

### **`/widgets`** — Feature-Specific Widgets
- **What**: Reusable UI components scoped to this feature
- **Responsibility**:
  - Widgets that are reused within multiple screens of the same feature
  - Not shared across features (those go in `lib/shared_widgets/`)
- **Example**: A custom `SessionCard` widget used only in the session feature

### Example: Creating a New History Item

**User Journey**: User taps "Add Item" → enters title/subtitle → taps "Save"

**Step-by-step flow:**

1. **VIEW** (`history_page.dart`):
   ```dart
   onPressed: () {
     provider.createItem(id, title, subtitle);
   }
   ```

2. **STATE** (`history_provider.dart`):
   ```dart
   Future<void> createItem(String id, String title, String subtitle) async {
     final m = {'id': id, 'title': title, 'subtitle': subtitle};
     await _repo!.create(m);  // ← delegates to repo
   }
   ```

3. **REPO** (`history_repository.dart`):
   ```dart
   Future<void> create(Map item) async {
     // 1. Write to local cache immediately (optimistic update)
     await _box!.put(item['id'].toString(), item);
     
     // 2. Queue remote operation for later sync
     await _enqueueOp({
       'op': 'create', 
       'id': item['id'].toString(), 
       'payload': item, 
       'retries': 0
     });
     
     // 3. Try to flush queue to backend if user is authenticated
     await flushQueueIfAuthenticated();
   }
   ```

4. **CORE SERVICE** (`firebase_service.dart` + `hive_service.dart`):
   ```dart
   // HiveService writes to local Hive box
   await _box!.put(key, value);
   
   // FirebaseService writes to Firestore (if online)
   await FirebaseService.db
     .collection('users')
     .doc(uid)
     .collection('history')
     .doc(id)
     .set(data);
   ```

5. **EXTERNAL SYSTEM**:
   - Local: Hive database file
   - Remote: Firestore `users/{uid}/history/{id}` document

6. **NOTIFICATION BACK TO UI**:
   - Hive box emits a `BoxEvent`
   - Repo listens via `watchLocal()` stream
   - Provider calls `_readFromRepo()` and `notifyListeners()`
   - View rebuilds with new data

### Key Architecture Principles

**1. Separation of Concerns**
- **View** = what user sees
- **State** = what changes
- **Repo** = where data lives
- **Services** = how we talk to external systems

**2. Dependency Inversion**
- Providers depend on repository **interfaces**, not concrete implementations
- Repositories depend on service **interfaces**, not Firebase/Hive directly
- Easy to mock for testing

**3. Offline-First Strategy**
- Write to local cache immediately (instant UI feedback)
- Queue remote operations
- Sync when online
- Repository hides complexity from provider

**4. Single Source of Truth**
- Repository owns the data for a feature
- Providers read from repo, never directly from services
- No scattered Firestore queries across UI files

### Summary Table

| Layer | Location | Responsibility | Talks To | Example |
|-------|----------|---------------|----------|---------|
| **View** | `/view` | Render UI, capture events | State (Provider) | `history_page.dart` |
| **State** | `/state` | Observable state, coordinate logic | Repo | `history_provider.dart` |
| **Repo** | `/repo` | Data access, caching, sync | Core Services | `history_repository.dart` |
| **Models** | `/models` | Domain entities | - | `HistoryItem` class |
| **Services** | `lib/core/services/` | External system adapters | Firebase, HTTP, Hive | `firebase_service.dart` |
| **Backend** | `backend/` or `firebase/functions/` | Server-side logic | Database, APIs | `sessionAggregator.ts` |

### When to Use Each Folder

- **`/view`**: Always—every feature has screens
- **`/state`**: Always—every feature needs state management
- **`/repo`**: If the feature reads/writes data (most do)
- **`/models`**: If the feature has domain objects (usually yes)
- **`/data`**: Optional—use if you want strict data source separation
- **`/widgets`**: Optional—use if you have feature-specific reusable widgets

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


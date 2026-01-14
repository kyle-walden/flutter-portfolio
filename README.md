## Flutter Portfolio — Project Folder Template

This README is the canonical template when viewing each project inside this portfolio showcase repository. It is designed to demonstrate:

- ✅ Full-stack ownership (backend folder) 
- ✅ Clean, scalable front-end architecture (flutter_app_(front_end) folder) 
- ✅ CI/CD experience (ci folder with GitHub Actions + Xcode Cloud notes) 
- ✅ Cross-platform support (platform tags on folders/files) 

## Stack demonstration

The following tools and technologies are demonstrated in this portfolio:

- Flutter (Dart)
- Firebase Auth 
- Firebase Analytics (Google Analytics)
- Firebase Firestore (NoSQL database)
- Local Cache (shared preferences, Hive)
- Platform services (GPS, accelometers, gyroscopes)
- Mapping (Mapbox)
- Firebase Functions (serverless backend)
- Flask Server (Python)
- Xcode Cloud (CI)

Sensitive details removed — the original projects referenced are outside this repo.

## Project template notation legend

- [REQ] required for the showcase (must be present and populated).
- [OPT] optional but recommended (helpful to include where available).
- [SAMPLE] include a small placeholder or example file to show structure.
- [ABST] abstracted — remove sensitive data, replace with mocks/fakes.
- (platform: ios, android, web, macos, windows, linux) — indicates platforms supported.
- {purpose}: a short human-readable purpose for the file/folder.

## Top-level project template

Each project folder should follow this pattern. Replace `project/` with your project name (e.g., `pitboard/`, `vendor0-slim/`).

project/
│
├─ README.md [REQ] {high-level description, platforms, demo URL, how to run}
│
├── flutter_app_(front_end)/ [REQ] (platform: ios, android, web, macos, windows, linux)
│   ├── pubspec.yaml [REQ] {dependencies, sdk constraints, minimal explanation}
│   ├── lib/ [REQ] {Dart source organized by feature/domain}
│   │   ├── main.dart [REQ] {app entry, small bootstrap only}
│   │   ├── app/ [REQ] {App-level wiring: router, themes, global providers}
│   │   │   └── app.dart [SAMPLE] {MaterialApp/CupertinoApp wrapper}
│   │   ├── features/ [REQ] {each feature is self-contained}
│   │   │   ├── feature_x/
│   │   │   │   ├── models/ [REQ] {domain models}
│   │   │   │   ├── view/ [REQ] {widgets/screens}
│   │   │   │   ├── data/ [OPT] {DTOs, API mappers}
│   │   │   │   ├── repo/ [OPT] {repository interface + implementation (talks to core/services/http)}
│   │   │   │   ├── widgets/ [OPT] {feature-scoped reusable widgets}
│   │   │   │   ├── tests/ [OPT] {unit tests for models/repo/state and widget tests for views}
│   │   │   │   └── state/ [REQ] {state management: bloc|provider|controller}
│   │   ├── core/ [REQ] {shared infrastructure: http, storage, error handling}
│   │   │   ├── services/ [REQ] {HTTP client wrappers, local storage, analytics (only abstracted placeholders), error handling utilities}
│   │   │   ├── utils/ [OPT]
│   │   │   └── di/ [OPT] {dependency injection wiring}
│   │   └── shared_widgets/ [OPT] {reusable UI components - buttons, loaders, error cards used across features}
│   ├── test/ [REQ] {unit/widget tests; at least one smoke test}
│   └── CI/ [OPT] {local scripts or hints for CI if needed}
│
├── backend/ [REQ] {demonstrates full-stack ownership}
│   ├── README.md [REQ] {how to run locally, endpoints, env vars (abstracted)}
│   ├── main/ [REQ] {source: example server or functions}
│   │   ├── app.py | index.js | main.go [SAMPLE]
│   ├── tests/ [REQ] {unit/integration tests that can run headlessly}
│   └── infra/ [OPT] {deploy scripts, Dockerfile (abstracted)}
│
├── ci/ [REQ] {CI/CD manifests showing automation}
│   ├── github-actions.yml [REQ] {build, test, publish where appropriate}
│   ├── xcode-cloud.md [OPT] {notes + sample config to demonstrate Xcode Cloud knowledge}
│   └── release/ [OPT] {scripts used by CI to create artifacts}
│
└── screenshots/ [OPT] {PNG/JPG placeholders used in README or portfolio site}
        └── placeholder.png [SAMPLE]

## File-level guidance and small contracts

- `flutter_app_(front_end)/lib/main.dart` — minimal bootstrap only. Input: app config/env; Output: MaterialApp mounted; Error modes: crash on missing essential DI; Success: app runs and shows home route.
- `features/<x>/...` — each folder contains models, views, and state. Keep dependencies inward-facing so features can be moved or extracted.
- `backend/main/*` — provide a small, runnable example (e.g., Flask app with 1-2 endpoints) and tests that run with a single command.
- `ci/github-actions.yml` — must show build and test steps for both backend and front-end, plus an example deploy (mock or step placeholder if secrets removed).

## Edge cases & how to handle them

- Large/slow dependencies: use small test doubles or offline fixtures in tests.
- Secrets: never check secrets into this repo; add clear README placeholders and `.env.example` where appropriate.
- Platform-specific code: include platform tags and a short note about how to test locally (e.g., `flutter run -d chrome` for web).


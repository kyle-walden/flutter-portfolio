## Flutter Portfolio — Project Folder Template

This README is the canonical template when viewing each project inside this portfolio showcase repository. It is designed to demonstrate:

- Full-stack ownership (backend folder) 
- Clean, scalable front-end architecture (flutter_app_(front_end) folder) 
- CI: Code Integration & Testing (Builds & Tests).
- CD (Delivery): Code Delivery (Ready to Deploy).
- Cross-platform support (platform tags on folders/files) 

## Stack demonstration

The following tools and technologies are demonstrated in this portfolio:

- Cross-platform framework: Flutter (Dart)
- User security: Firebase Auth 
- App analytics: Firebase Analytics (Google Analytics)
- Remote data storage: Firebase Firestore (NoSQL database)
- Local data storage: Local Cache (shared preferences, Hive)
- Platform services: GPS, accelometers, gyroscopes
- Mapping: Mapbox
- Serverless end-point: Firebase Functions
- Server end-point: Flask Server (Python)
- CI/CD: Xcode Cloud, GitHub Actions

## Project template notation legend

- [REQ] required for the showcase (must be present and populated).
- [OPT] optional but recommended (helpful to include where available).
- [SAMPLE] include a small placeholder or example file to show structure.
- [ABST] abstracted — remove sensitive data, replace with mocks/fakes.
- (platform: ios, android, web, macos, windows, linux) — indicates platforms supported.
- {purpose}: a short human-readable purpose for the file/folder.

## Top-level project template

Sensitive details removed — the original projects referenced are outside this repo.

project/
│
├─ README.md [REQ] {high-level description, platforms, demo URL, how to run}
│
├── flutter_app/ [REQ] (platform: ios, android, web, macos, windows, linux)
│   ├── pubspec.yaml [REQ] {dependencies, sdk constraints, minimal explanation}
│   ├── lib/ [REQ] {Dart source organized by feature/domain}
│   │   ├── main.dart [REQ] {app entry, small bootstrap only}
│   │   ├── app/ [REQ] {App-level wiring: router, themes, global providers}
│   │   │   └── app.dart [SAMPLE] {MaterialApp/CupertinoApp wrapper}
│   │   ├── features/ [REQ] {each feature is self-contained}
│   │   │   └──  feature_x/
│   │   │      ├── models/ [OPT] {domain models}
│   │   │      ├── view/ [REQ] {widgets/screens}
│   │   │      ├── data/ [OPT] {DTOs, API mappers}
│   │   │      ├── repo/ [OPT] {repository interface + implementation (talks to core/services/http)}
│   │   │      ├── widgets/ [OPT] {feature-scoped reusable widgets}
│   │   │      ├── tests/ [REQ] {unit tests for models/repo/state and widget tests for views}
│   │   │      └── state/ [REQ] {state management: bloc|provider|controller}
│   │   ├── core/ [REQ] {shared infrastructure: http, storage, error handling}
│   │   │   ├── services/ [REQ] {HTTP client wrappers, local storage, analytics (only abstracted placeholders), error handling utilities}
│   │   │   ├── utils/ [OPT] {general-purpose utilities}
│   │   │   └── di/ [OPT] {dependency injection wiring}
│   │   └── shared_widgets/ [OPT] {reusable UI components - buttons, loaders, error cards used across features}
│   └── test/ [REQ] {unit/widget tests; at least one smoke test}
│
├── backend/ [REQ] {demonstrates backend awareness and integration ownership}
│   ├─ README.md
│   ├─ .env.example
│   └── firebase/
│       ├── functions/ [REQ] {source: serverless functions}
│       │   ├──  src/
│       │   └──  tests/
│       └──  firebase.json {Firebase project configuration}
│ 
├── ci/ [REQ] {CI/CD showcase — the docs + sample workflows}
│   ├── README.md [REQ] {what each workflow does + how to run locally}
│   ├── github-actions/ (show sample YAMLs)
│   │   ├── ci.yml [REQ] {PR CI: analyze, unit tests, build debug artifact}
│   │   └── release.yml [REQ] {CD: produce release artifacts}
│   └── xcode-cloud/ {CD: pre- and post-build scripts samples}
│       ├── ci_pre_xcodebuild [REQ] {xcode cloud pre-build script sample}
│       └── ci_post_xcodebuild [REQ] {xcode cloud post-build script sample}
│   
└── screenshots/ [OPT] {PNG/JPG placeholders used in README or portfolio site}
        └── placeholder.png [SAMPLE]

## File-level guidance and small contracts

- `flutter_app/lib/main.dart` — minimal bootstrap only. Input: app config/env; Output: MaterialApp mounted; Error modes: crash on missing essential DI; Success: app runs and shows home route.
- `features/<x>/...` — each folder contains models, views, and state. Keep dependencies inward-facing so features can be moved or extracted.
- `backend/main/*` — provide a small, runnable example (e.g., Flask app with 1-2 endpoints) and tests that run with a single command.
- `ci/github-actions.yml` — must show build and test steps for both backend and front-end, plus an example deploy (mock or step placeholder if secrets removed).

## Edge cases & how to handle them

- Large/slow dependencies: use small test doubles or offline fixtures in tests.
- Secrets: never check secrets into this repo; add clear README placeholders and `.env.example` where appropriate.
- Platform-specific code: include platform tags and a short note about how to test locally (e.g., `flutter run -d chrome` for web).


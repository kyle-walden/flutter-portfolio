## Flutter Portfolio — Project Folder Template

I referred to the repository instructions at `.github/instructions/gpt_instructions.instructions.md` and followed the Flutter app architecture guidance (flutter.dev/app-architecture and linked concept/guide/case-study pages) to produce this reference structure. This README is the canonical template you should follow when creating each project inside this showcase repository. It is designed to demonstrate:

- Full-stack ownership (backend folder) ✅
- Clean, scalable front-end architecture (flutter_app_(front_end) folder) ✅
- CI/CD experience (ci folder with GitHub Actions + Xcode Cloud notes) ✅
- Cross-platform support (platform tags on folders/files) ✅

Use this template when you add a new project (an abstracted/refactored version of the real project that lives outside this repo). Keep sensitive details removed — the original projects are referenced outside this repo as described in the instructions.

### Quick overview — what I changed / added

- Expanded the folder tree with explicit file/dir notation and purpose.
- Added a notation legend so contributors know what each tag means.
- Mapped top-level folders to the showcase goals.
- Added a short checklist and next steps for bootstrapping a new project.

## Notation legend

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

## Minimal example entries (what to include right away)

- README.md: short description (1–2 paragraphs), supported platforms, run instructions for front-end and back-end, CI notes.
- flutter_app_(front_end)/pubspec.yaml: sdk constraints, a few core dependencies (flutter, cupertino_icons, provider or riverpod), and a note "See architecture notes in shared/".
- backend/README.md: start command, ports, example curl for a health endpoint.
- ci/github-actions.yml: skeleton with steps: checkout, setup Flutter, run flutter test, run backend tests, optional artifact upload.

## Checklist when adding a new project

1. Create `project/` folder from this template. [ ]
2. Populate `README.md` with run steps and platforms. [ ]
3. Add `flutter_app_(front_end)` with `main.dart`, minimal feature folder, and at least one test. [ ]
4. Add `backend` with a runnable script and health endpoint plus tests. [ ]
5. Add CI `github-actions.yml` that runs tests for both parts. [ ]
6. Commit and open a PR that references the original project (outside this repo) for reviewers.

## Mapping to showcase goals

- Full-stack ownership: `backend/` contains source + tests showing server-side reasoning. ✅
- Clean, scalable app architecture: `flutter_app_(front_end)/lib/` follows feature + core + app wiring. ✅
- CI/CD: `ci/github-actions.yml` plus `xcode-cloud.md` demonstrates knowledge of automation and iOS release flow. ✅
- Cross-platform: add platform tags and include `platform:` notes in README and CI where applicable. ✅

## Next steps (recommended)

1. Use this README as a template and create a project skeleton for one of your projects (e.g., `pitboard/`), populating only non-sensitive placeholder code.
2. Add a small smoke test for front-end and backend and run the CI skeleton locally or via GitHub to verify pipelines. (CI secrets can be omitted and replaced with job `if: false` steps to show intent.)
3. Iterate: flesh out one feature end-to-end (small) to serve as the exemplar for reviewers.

---
Completion summary: I expanded the README into a detailed project folder template and notation legend so you have a single reference when building each project folder in `flutter-portfolio`. This file replaces the previous brief checklist and now maps clearly to the showcase goals in the repo instructions.

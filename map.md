Flutter Portfolio Structure 
# Flutter Portfolio — Repository Map

This document describes the high-level structure of the Flutter portfolio repository and the contents of the major folders. It is intended as a quick reference for contributors and reviewers.

## Root README.md (summary)

The root `README.md` provides an overview of the portfolio and highlights:

- Production-focused Flutter projects demonstrating:
  - Clean architecture
  - Firebase integration
  - Backend APIs (Flask)
  - CI/CD pipelines
  - Performance-aware UI

### Projects

1. **Pitboard** — Motocross telemetry and lap analysis app.

	Tech:
	- Flutter (iOS & Android)
	- Firebase Auth / Firestore
	- Mapbox
	- GitHub Actions CI
	- Xcode Cloud

	Key engineering focus:
	- Sensor data processing
	- Real-time UI updates
	- Offline-first persistence

2. **BrakePoint** — Motocross braking analytics and training insights.

	Tech:
	- Flutter
	- Flask API
	- Firebase
	- CI with automated builds

	Key engineering focus:
	- Signal processing
	- Analytics pipelines
	- Scalable backend design

What this repo demonstrates:

- Real production patterns
- End-to-end ownership
- Engineering trade-offs

## Porfolio repository structure (overview)

```
flutter-portfolio/
├─ README.md
├─ projects/
│   ├─ pitboard/
│   │   └─ ...
│   │
│   └─ vendor0/
│       └─ ...
│
├─ shared/
│   ├─ flutter_patterns/
│   ├─ firebase_examples/
│   ├─ ci_templates/
│   └─ architecture_notes.md
└─ ...
```

## Project layout (typical)

Each project follows a consistent layout:

```
{project_name} /
├─ README.md
├─ flutter_app/
│   ├─ lib/
│   │   ├─ core/
│   │   ├─ features/
│   │   ├─ services/
│   │   ├─ di/
│   │   └─ main.dart
│   ├─ test/
│   └─ pubspec.yaml
├─ backend/
│   ├─ app/
│   ├─ tests/
│   ├─ requirements.txt
│   └─ README.md
├─ ci/
│   ├─ github-actions.yml
│   └─ xcode-cloud.md
└─ screenshots/
```

### Example: Pitboard README (high level)

Overview

Motocross lap timing and telemetry analysis app focused on training feedback.

Architecture

- Feature-first Flutter structure
- Domain-driven separation
- Firebase authentication and sync
- Local persistence via Hive

Key technical challenges

- GPS noise filtering
- Corner detection without speed data
- Continuous heatmap rendering

Notable decisions

- Firebase over custom auth
- No manual corner overrides
- Mapbox over Google Maps

CI / Delivery

- GitHub Actions
- Xcode Cloud

## Shared folder

```
shared/
├─ flutter_patterns/
│   ├─ state_management.md
│   ├─ error_handling.md
│   └─ performance_notes.md
├─ ci_templates/
│   ├─ flutter_ci.yml
│   └─ ios_release.yml
└─ architecture_notes.md
```

This map is a living document — update it when you add new projects, shared patterns, or CI templates.

├─ ci_templates/ 
│   ├─ flutter_ci.yml 
│   └─ ios_release.yml 
└─ architecture_notes.md 
 
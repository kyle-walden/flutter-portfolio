# Pitboard

## Overview
Motocross lap timing and telemetry analysis app focused on training feedback.

## Architecture
- Feature-first Flutter structure
- Domain-driven separation (data / domain / UI)
- Firebase used for auth and sync
- Local persistence via Hive

## Key Technical Challenges
- GPS noise filtering
- Corner detection without speed data
- Continuous heatmap rendering

## Notable Decisions
- Why Firebase over custom auth
- Why no manual corner overrides
- Why Mapbox instead of Google Maps

## CI / Delivery
- GitHub Actions for lint + test
- Xcode Cloud for App Store builds

## Screenshots
- Homescreen
- History
- Session detail

## Project Folder Structure 
- ☑️ added
- ✅ done

pitboard /
│
├─ README.md ☑️
│
├─── flutter_app_(front_end)/
│       │
│       ├─── lib/
│       │       │
│       │       ├─── screens/ ☑️
│       │       │       ├─── home.dart
│       │       │       ├─── history.dart
│       │       │       └─── session_detail.dart
│       │       │
│       │       ├─── models/ ☑️
│       │       │       └─── telemetry_sample.dart
│       │       │
│       │       ├─── services/ ☑️
│       │       │       ├─── session_manager.dart
│       │       │       ├─── firebase_services.dart
│       │       │       ├─── platform_services.dart
│       │       │       └─── local_storage.dart
│       │       │
│       │       ├─── widgets/ ☑️
│       │       │       ├─── login.dart
│       │       │       ├─── card.dart
│       │       │       └─── carousel.dart
│       │       │
│       │       └─── main.dart ☑️
│       │
│       ├─── test/ ☑️
│       │      ├─── test_login.dart
│       │      └─── test_session_manager.dart
│       │
│       └─── pubspec.yaml ☑️
│
├─── backend/
│       │
│       ├─── main/ ☑️
│       ├─── tests/ ☑️
│       └─── README.md ☑️
│
├─── ci/
│       │
│       ├─── github-actions.yml ☑️
│       └─── xcode-cloud.md ☑️
│
└─── screenshots/
        │
        ├─── homescreen.png
        ├─── history.png
        └─── session_detail.png
# Pitboard Flutter App

## Overview
Pitboard is a shipped mobile application for iOS and Android that records motocross sessions using GPS and on-device telemetry, aggregates performance metrics, and provides post-session analysis to help riders evaluate and improve riding performance.

This repository is an abstracted/redacted extraction of the original project intended for portfolio and technical review.

## Live Status
- Platforms: iOS (App Store), Android (Google Play)
- Status: Production (shipped)
- Role: Primary developer / architect for the mobile client and app-level integrations
- Code visibility notes: This repo is intentionally redacted. Sensitive backend implementations, service keys, and some feature-specific source files are removed or replaced with placeholders.

## Quick Index
- [Overview](#overview)
- [Live Status](#live-status)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Architecture Overview](#architecture-overview)
- [Technical Challenges](#technical-challenges)
- [Tradeoffs / Decisions](#tradeoffs--decisions)
- [Repository Structure](#repository-structure)
- [Notes](#notes)

## Features
- High-frequency session GPS position capture with lap detection
- On-device telemetry sampling (accelometers, gyroscopes) during sessions
- Post-session analysis and visualisations (sections, metrics, statistics, heatmap map visuals)
- Offline-first session capture with local persistence and background sync
- Batched/staged uploads for large session payloads to cloud storage
- User authentication, profiles, and per-user data scoping
- Google analytics integrations

## Tech Stack
- Mobile client
	- Flutter (Dart) single codebase
	- State: `provider` for scoped feature state and global providers
	- UI & visualizations: custom widgets and theming
	- Maps & location: `mapbox_maps_flutter`, `geolocator`
	- Local persistence & cache: `hive`, `hive_flutter`
	- Media & sharing: `image_picker`, `image`, `share_plus`, `cached_network_image`
	- Platform utilities: `wakelock_plus`, `path_provider`, `device_info_plus`, `package_info_plus`

- Backend & cloud
	- Firebase: `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage`, `cloud_functions` (server-side triggers and APIs)
	- Analytics `firebase_analytics `integrations (analytics present)

- Data & sync
	- Cache-first client with `hive` as local store; server-of-record in Firestore
	- Write-behind / queued uploads for large session data and retry/backoff handling
	- Cloud Functions used for lightweight server processing 

- DevOps / CI
	- CI templates and deliver helpers present in the repo (GitHub Actions / Xcode Cloud artefacts)
	- Emulator-friendly local development for functions and Firestore

- Testing & tooling
	- `flutter_test` and `fake_cloud_firestore` for unit and integration tests
	- Functions project uses TypeScript for backend unit tests

## Architecture Overview
- Refer to portfolio-level shared architecture documentation for Flutter projects - all standard patterns and practices apply.

## Technical Challenges
- iOS native dependency compatibility  
  - Constraint: Certain transitive native dependencies failed to compile under Clang during iOS builds.  
  - Resolution: Pinned compatible versions, and adjusted Xcode build settings to restore deterministic builds across CI and local environments.
- Offline-first data sync with Firestore  
  - Constraint: Riders frequently operate with intermittent connectivity, requiring local session capture without data loss.  
  - Resolution: Implemented a write-behind local cache with explicit conflict resolution rules between local state and remote Firestore documents.
- Data storage and architecture scalability  
  - Constraint: High-frequency GPS and telemetry sampling generated large session payloads, requiring reliable remote upload without blocking the UI or degrading in-session performance.  
  - Resolution: Designed a scalable data model and staged upload pipeline that batches and streams session data efficiently, keeping capture responsive while ensuring complete and consistent remote persistence.

## Tradeoffs / Decisions / Edge Cases

-

## Repository Structure

Refer to each README.md in the folders for more details and further structure.

- `README.md` — this file
- `backend/` — server-side APIs and background jobs (redacted)
- `ci/` — CI templates, release, delivery, and signing helpers
- `flutter_app/` — Flutter mobile app source, assets and platform configuration
- `screenshots/` — App screenshots and visual QA artifacts

## Analytics

Example of product-user fit analytics framework documentation. 

## Notes
- Security / abstraction disclaimer:
	- This repository is intentionally redacted for public distribution.
	- Secrets, credential files, production configuration, and some implementation details are omitted.


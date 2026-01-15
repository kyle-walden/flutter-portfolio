# Kyle Walden – Flutter Portfolio

This monorepo portfolio represents production-level work by a junior–mid Flutter developer with end-to-end feature ownership experience.

Intended roles: Flutter Developer / Mobile Engineer (Cross-platform)

## Purpose

The purpose of this portfolio is to demonstrate:

- Full-stack ownership and integration awareness
- Clean, scalable front-end architecture
- CI (Code Integration: Builds & Tests) / CD (Code Delivery: Ready to Deploy).
- Cross-platform development with Flutter (Dart)

## How to Review

- Start with `projects/pitboard/README.md` for a full mobile example: [Pitboard](projects/pitboard/README.md)
- Review `/shared/architecture_patterns.md` for cross-project standards: [Architecture Patterns](shared/architecture_patterns.md)
- CI/CD examples live under `/ci/`: [CI example](projects/pitboard/ci)

## Scope & Ownership

All projects in this repository were designed, implemented, and maintained by me as a solo developer.


## Quick Index
- [Tech Stack](#tech-stack)
- [Projects](#projects)
- [Portfolio Structure](#portfolio-level-structure)
- [Project Folder Structure](#project-folder-level-structure)
- [Architecture Overview](#architecture-overview)

## Tech Stack

The following tools and technologies are demonstrated in this portfolio's projects:

- Cross-platform framework: Flutter (Dart)
- User security: Firebase Auth 
- App analytics: Firebase Analytics (Google Analytics)
- Remote data storage: Firebase Firestore (NoSQL database)
- Local data storage: Local caching (shared preferences, Hive)
- Platform services: GPS, accelerometers, gyroscopes
- Mapping: Mapbox
- Serverless endpoint: Firebase Functions
- Server endpoint: Flask Server (Python)
- CI/CD: Xcode Cloud, GitHub Actions

Each project is an abstract, redacted/stubbed version of a real-world app, designed to showcase architecture patterns, methodologies, and full-stack awareness.

## Projects

### [Pitboard](projects/pitboard)

Status: Production (shipped)

Description
---------------
Pitboard is a shipped mobile application for iOS (Android in progress) that records motocross rides/sessions using GPS and on-device telemetry, aggregates performance metrics, and provides post-session analysis to help riders evaluate and improve riding performance.

Features
---------------
- High-frequency (1-10hz) session GPS position capture with lap detection
- On-device telemetry sampling (10hz) (accelerometers, gyroscopes) during sessions
- Post-ride analysis and visualisations (sections, metrics, statistics, ride heatmap visualisations)
- Offline-first session capture with local persistence and background sync
- Batched/staged uploads for large session payloads to cloud storage
- User authentication, profiles, and per-user data scoping
- Google analytics integrations

### [vendor0](projects/vendor0)

Status: Production (shipped)

Description
---------------
vendor0 is a service vendor booking management web-app that helps service vendors manage bookings, manage offered services, business information, and availability. It also attracts more customer bookings by automatically generating a public customer booking form through reserving a unique URL slug.

Features
---------------
- Service vendor business profile management (name, contact, services)
- Unique public slug reservation and ownership for vendor pages
- Vendor booking & availability management (CRUD for availability rules)
- Public customer booking form accessed via vendor URL slug
- Server-mediated booking creation to protect Firestore rules

## Portfolio Structure

The repository is organized as follows:

- `projects/` — all individual project folders live here.
- `shared/` — project shared resources, documentation, and architecture patterns.
- `readme.md` — this file.

## Project Folder Structure

All projects follow this shared folder structure: [Project Folder Structure](shared/project_folder_structure.md)

## Architecture Overview

All projects follow these shared app architecture standard patterns and practices: [App Architecture Overview](shared/architecture_patterns.md)


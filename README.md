# Kyle Walden — Portfolio

Flutter Developer / Mobile Engineer / Frontend Developer  / Cross-platform Developer. Junior–mid level. All projects solo-built and shipped to production.

**Purpose**: The purpose of this portfolio is to demonstrate [the below key competencies](#competencies) through projects in this monorepo. 

> Quickly review this portfolio by skimming the references under each [competency](#competencies) below, or deep dive into the [project folders](projects) for full context.

## Tech Stack at a Glance

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white) ![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black) ![Flask](https://img.shields.io/badge/Flask-000000?style=for-the-badge&logo=flask&logoColor=white)

---

## Projects

### [Pitboard](projects/pitboard) — iOS & Android
This project folder contains a Flutter client app with firebase backend integration.
- Status: Production (shipped) – iOS and Android
- Tech Stack: Flutter · Firebase · Hive · Mapbox

![pitboard](projects/pitboard/assets/screenshots/pb-ss.png)

#### Description
A motorsport (motocross) performance mobile app.
- High-frequency (1-10hz) GPS and on-device sensor capture (accelerometers, gyroscopes) for user performance analysis and visualisation
- Technical challenge: Offline-first sync – session data storage for users in remote locations with poor connectivity, with background cloud-sync for data backup and cross-device access.

### [vendor0](projects/vendor0) — Web
This project folder contains only the Flask API backend of a web app.
- Status: Production (shipped) – web app, Firebase Hosting
- Tech Stack: Flutter Web · Flask (Cloud Run) · Firestore · Firebase Auth

![vendor0](projects/vendor0/assets/screenshots/all.png)

#### Description
A service vendor booking management web-app.
- Platform for SME businesses to manage bookings, offered services, business information, and availability.
- Technical challenges: Display a vendor's public customer service booking form with dynamic data – accessed via a service vendor's unqiue URL slug; business data security and access control – ensuring only authorized users can access and modify their business data.

---

## Competencies

**1. Architectural Integrity** — decoupled, testable, team-ready code

| Pattern | Where |
|---|---|
| MVVM — offline-first sync feature example | [Pitboard → history feature](projects/pitboard/README.md) |
| Services Repository — slug ownership + auth example | [vendor0 → Flask backend](projects/vendor0/README.md) |

**2. Product-Led Engineering** — analytics-driven iteration, not assumption-driven

| Example | Where |
|---|---|
| Firebase Analytics integration | [analytics_service.dart](projects/pitboard/flutter_app/lib/core/services/analytics_service.dart) |

**3. Audited AI-Pilot Workflow** — AI-assisted development for speed, audit for quality

| Example | Where |
|---|---|
| Unit tests — auth viewmodel + offline-sync repo | [test/](projects/pitboard/flutter_app/test/) |
| Testing in CI/CD — iOS build + test pipeline | [ios_ci.yml](projects/pitboard/ci/github-actions/ios_ci.yml) |
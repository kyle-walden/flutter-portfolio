# Kyle Walden – Portfolio

This monorepo represents production-level portfolio work by a junior–mid application developer.

**Purpose**: The purpose of this portfolio is to **demonstrate the following key competencies** through projects in this monorepo:
- **1. Architectural Integrity**: I write code that is decoupled, testable, and ready for team collaboration, following best practices and design patterns such as MVVM, Services Repository pattern, and SOLID principles.
- **2. Product-Led Dev/Product Engineering**: Focus on building features based on actual user metrics.
- **3. AI-Pilot Workflow**: I use AI as a force multiplier for speed while performing rigorous manual audits to ensure security and code quality.

**Intended roles**: Flutter Developer / Mobile Engineer (Cross-platform).

**Scope and ownership**: All projects in this repository were designed, implemented, and maintained by me as a solo developer.

## How to review this portfolio
TODO

## Tech Stack at a Glance

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white) ![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white) ![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black) ![Flask](https://img.shields.io/badge/Flask-000000?style=for-the-badge&logo=flask&logoColor=white)

## Projects
### [Pitboard](projects/pitboard)

Status: Production (shipped) – iOS and Android
Stage: Product-user fit (actively acquiring users and iterating based on feedback)

Tech Stack: Flutter, Firebase

#### Description
A motorsport (motocross) performance mobile app.
- High-frequency (1-10hz) GPS and on-device sensor capture (accelerometers, gyroscopes) for user performance analysis and visualisation
- Technical challenge: Offline-first sync – session data storage for users in remote locations with poor connectivity, with background cloud-sync for data backup and cross-device access.

### [vendor0](projects/vendor0)

Status: Production (shipped) – web app
Stage: Product-user fit (actively acquiring users and iterating based on feedback)

Tech Stack: Flutter, Firebase, Flask (Python)

#### Description
A service vendor booking management web-app.
- Platform for SME businesses to manage bookings, offered services, business information, and availability.
- Technical challenges: Display a vendor's public customer service booking form with dynamic data – accessed via a service vendor's unqiue URL slug; business data security and access control – ensuring only authorized users can access and modify their business data.

## Project Folder Structure
All projects follow this shared folder structure: [Project Folder Structure](shared/project_folder_structure.md)


## Architecture Overview
All projects follow these shared app architecture standard patterns and practices: [App Architecture Overview](shared/architecture_patterns.md)
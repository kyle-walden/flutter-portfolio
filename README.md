# Kyle Walden – Portfolio

This monorepo represents production-level Flutter (Dart) portfolio work by a junior–mid developer.

Full portfolio link: [https://github.com/kyle-walden/flutter-portfolio](https://github.com/kyle-walden/flutter-portfolio)

**Purpose**: The purpose of this portfolio is to try demonstrate and aim for the below outlined key competencies (and their respective goals) through projects in this monorepo. 

**Intended roles**: Flutter Developer / Mobile Engineer (Cross-platform).

**Scope and ownership**: All projects in this repository were designed, implemented, and maintained by me as a solo developer.

## How to review this portfolio
1. Read through this README.md to understand the competencies being demonstrated through projects in this monorepo.
2. Refer to the references of each competency for specific documentation and implementation of the competencies.
3. Explore further in individual project folders under `projects/`.

## Quick Index
- [Competencies Demonstrated](#competencies-demonstrated)
- [Projects](#projects)
- [Tech Stack](#tech-stack)
- [Portfolio Structure](#portfolio-structure)
- [Project Folder Structure](#project-folder-structure)
- [Architecture Overview](#architecture-overview)


## Competencies Demonstrated
I have explicitly identified five key competencies that I aim to demonstrate through projects in this monorepo. Each competency includes specific goals and references to documentation and implementations in project folders. 

Competency Index:
1. [Intentional Architecture](#1-intentional-architecture)
2. [Rationales, Tradeoffs, and Edge Cases](#2-rationales-tradeoffs-and-edge-cases)
3. [End-to-End / Backend Awareness](#3-end-to-end--backend-awareness)
4. [AI Auditing and QA, Quality Engineering, Testing](#4-ai-auditing-and-qa-quality-engineering-testing)
5. [Impact Analytics (Data-Driven Development) & Product Engineering](#5-impact-analytics-data-driven-development--product-engineering)

### 1. Intentional Architecture
Focus on architectual patterns and adopt a systematical approach to scaffolding apps.

Goals: 
- Focus on clean and scalable designs rather than solely focusing on making the app work. 
- This involves selecting folder structures, state management patterns, and data flows that prevent technical debt before it starts. 
- I use Flutter (Dart) across all projects in this monorepo as the frontend framework, which offers a single, responsive architecture and scalable system across multiple platforms - rather than maintaining multiple codebases for different platforms.

**Reference**: [Architecture Patterns](shared/architecture_patterns.md) used across projects, and [Folder Structure](shared/project_folder_structure.md) for typical project folder mappings.

### 2. Rationales, Tradeoffs, and Edge Cases
Provide clear reasoning for selecting specific technologies and architecture patterns.

Goals:
- Evaluate an architectual decision or select a technical stack based on business (budget, time, user needs) constraints, technical constraints, and edge cases rather than hype. 
- For example, 'why choose Mapbox over Google Maps API?' or 'why use Provider over Riverpod for state management?'. I try document these rationales, trade-offs, and edge cases in project-level READMEs to demonstrate thoughtful decision-making.

**Reference**: "Rationales / Trade-offs" section in project level README: [Pitboard](projects/pitboard/README.md#Rationales), [vendor0](projects/vendor0/README.md#Rationales)

### 3. End-to-End / Backend Awareness
Demonstrate the full lifecycle of data without claiming "Full Stack" mastery.

Goals: 
- A holistic understanding of how code interacts with backend ecosystems through simple backend functions and APIs. 
- I focus on demonstrating awareness of server-side / serverless logic, data flows, and integrations to build front-end systems that align with backend capabilities.

**Reference**: 'backend' folder in project files showing server-side / serverless logic and integrations: [Pitboard Backend](projects/pitboard/backend), [vendor0 Backend](projects/vendor0/backend)

### 4. AI Auditing and QA, Quality Engineering, Testing
Shift from "Code Writer" to "Code Reviewer", "Bug Hunter", and "Prompt Engineer".

Goals:
- Recognise AI tools increases coding and development speed as well as bug velocity. 
- There is therefore a stronger need for defensive CI/CD pipelines, automated testing, and strict linting—to catch logic errors and hallucinations that AI introduces. 
- Future: Recognise using AI tools for code generation but emphasize importance of prompt strategy to always stay true to the set architecture and rationales/tradeoffs/edge cases (TODO: /shared AI prompt strategy).

**Reference**: 
- A [testing strategy](/shared/testing_strategies.md) shared across projects
- `/ci` project folders to demonstrate continuous testing and building

### 5. Impact Analytics (Data-Driven Development) & Product Engineering
Product-user fit and feature implementation is driven by measurable impact, not just "building features".

Goals: 
- Integrate feedback loops (analytics, logging, user metrics) to validate product-user fit and features actually solve the problem. 
- Shift narrative from "I built a feature" to "I improved a metric". This competency involves documenting analytics frameworks at product-user fit level and feature optimisation level.

**Reference**: 
- TODO - analytics framework documentation: [Pitboard product-user fit analytics framework](projects/pitboard/README.md#analytics), [vendor0 product-user fit analytics framework](projects/vendor0/README.md#analytics); 
- Firebase analytics integration in projects: [Pitboard Analytics](projects/pitboard/flutter_app/lib/core/services/analytics_service.dart), [vendor0 Analytics](projects/vendor0/flutter_app/lib/core/services/analytics_service.dart)


## Projects
### [Pitboard](projects/pitboard)

Status: Production (shipped)
Stage: Product-user fit (actively acquiring users and iterating based on feedback)

Tech Stack: [Pitboard stack](projects/pitboard/README.md#Tech-Stack)

#### Description
Pitboard is a mobile application for iOS (Android in progress) that records motocross rides/sessions using GPS and on-device telemetry, aggregates laps and performance metrics, and provides post-session analysis to help riders evaluate and improve riding performance.

#### High-level Features
- Session recording: high-frequency (1-10hz) GPS and on-device telemetry capture (accelerometers, gyroscopes) for lap and section detection
- Post-ride analysis: backend session data aggregation and UI visualisations (sections, metrics, statistics, ride heatmap visualisations)
- Offline-first session data storage with local persistence and background cloud-sync 
- Batched/staged uploads for large session payloads (+2MB) to cloud storage
- User authentication, profiles, and per-user data scoping
- Analytics integrations for product-user fit

### [vendor0](projects/vendor0)

Status: Production (shipped)
Stage: Product-user fit (actively acquiring users and iterating based on feedback)

Stack: [vendor0 stack](projects/vendor0/README.md#Tech-Stack)

#### Description
vendor0 is a service vendor booking management web-app that helps service vendors manage bookings, offered services, business information, and availability. It also attracts customer bookings by automatically generating a public customer booking form through reserving a unique URL slug.

#### High-level Features
- Service vendor business profile management (name, contact, services)
- Unique public URL slug reservation
- Public customer service booking form accessed via service vendor's unqiue URL slug
- Vendor service, booking and availability management 
- Flask server-mediated booking creation and slug-reservation to protect IP and prevent abuse

### [mobmeb](../mobmeb)

Status: Development

Tech Stack: Flutter (Web & Mobile), Firebase (Cloud Functions, Firestore, Storage, Analytics), Apple PassKit, Google Wallet, Payments APIs TBD

#### Description
mobmeb is a lightweight membership management platform designed for independent SME gyms, clubs, and studios (10-500 members). It provides simple membership management via web with digital wallet pass integration for seamless access / checkin control using dual check-in methods (NFC tap + QR scan).

#### High-level Features
- Member management with full CRUD operations, search, filtering, and export capabilities
- Digital wallet passes (Apple Wallet & Google Pay) with QR/NFC check-in tokens
- Offline-first check-in system with dual validation methods (QR scan and NFC tap)
- Payment tracking with automated membership extension logic
- Multi-user access with role-based permissions (owner, manager, staff)
- Real-time dashboard and reporting with role-based metrics
- Venue profile and settings management (operating hours, logo upload)
- Offline-first architecture with local Hive cache and background cloud sync
- Material 3 design system with responsive web and mobile interfaces


## Tech Stack
Project specific - rationale provided. Refer to project READMEs for details or project overviews below for high-level stacks.


## Portfolio Structure
The repository is organized as follows:

- `projects/` — all individual project folders live here.
- `shared/` — project shared resources, documentation, and architecture patterns.
- `readme.md` — this file.


## Project Folder Structure
All projects follow this shared folder structure: [Project Folder Structure](shared/project_folder_structure.md)


## Architecture Overview
All projects follow these shared app architecture standard patterns and practices: [App Architecture Overview](shared/architecture_patterns.md)
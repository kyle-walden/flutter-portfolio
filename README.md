# Kyle Walden – Portfolio

This monorepo represents production-level portfolio work by a junior–mid Flutter developer.

**Purpose**: The purpose of this portfolio is to try demonstrate key competencies through projects in this monorepo. 

- Intended roles: Flutter Developer / Mobile Engineer (Cross-platform).
- Scope and ownership: All projects in this repository were designed, implemented, and maintained by me as a solo developer.

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
### 1. Intentional Architecture
Concept: Moving beyond "making it work" to "designing it to last" across any platform.

Goal: A focus on clean, scalable system design rather than just syntax. This involves selecting folder structures, state management patterns, and data flows that prevent technical debt before it starts. I leverage Flutter’s unified codebase as a strategic asset—concentrating architectural effort on a single, robust system rather than diluting resources across fragmented native repositories. I use AI tools/agents to generate code, allowing me to focus on robust architectural design patterns that ensure maintainability and scalability.

**Reference**: [Architecture Patterns](shared/architecture_patterns.md) used across projects, and [Folder Structure](shared/project_folder_structure.md) for typical project folder mappings.

### 2. Rationales, tradeoffs and edge cases for selecting a tech stack and making architecture decisions
Concept: A "decision log" mindset, proving key technical decisions and tradeoffs by documenting the "why" not just the "how".

Goal: The ability to evaluate an architectual decision or technical stack solution based on business (budget, time, user needs) and technical constraints rather than hype. It involves identifying edge cases early and accepting specific downsides (trade-offs) to achieve a greater goal. For example, 'why choose Firebase over flask?' or 'why use Provider over Riverpod?'. I document these rationales, trade-offs, and edge cases in project READMEs to demonstrate thoughtful decision-making.

**Reference**: "Trade-offs" section in projects' README: [Pitboard](projects/pitboard/README.md#Tradeoffs / Decisions / Edge Cases), [vendor0](projects/vendor0/README.md#Tradeoffs / Decisions / Edge Cases)

### 3. End-to-End / Backend Awareness
Concept: Demonstrate the full lifecycle of data without over-claiming "Full Stack" mastery.

Goal: A holistic understanding of how code interacts with backend ecosystems through functions and APIs. I realise this competency is not comprehensive - data is not just consumed by human UIs anymore, there is now scope for AI Agents and LLMs to consume and act on data. However, I focus on demonstrating awareness of server-side logic, data flows, and integrations to build robust front-end systems that align with backend capabilities.

**Reference**: 'backend' folder in project files showing server-side logic and integrations: [Pitboard Backend](projects/pitboard/backend), [vendor0 Backend](projects/vendor0/backend)

### 4. AI Auditing & Quality Engineering
Concept: Shifting from "Code Writer" to "Code Reviewer", "Bug Hunter", and "Prompt Engineer".

Goal: Recognizing that while AI increases coding speed, it also increases bug velocity. This competency focuses on implementing defensive infrastructure—CI/CD pipelines, automated testing, and strict linting—to catch logic errors and hallucinations that AI introduces. Also, admit using AI tools for code generation but emphasize importance of prompt strategy to always stay true to the set architecture and rationales/tradeoffs/edge cases.

**Reference**: A "Testing Strategy" section in project READMEs, CI project folders to demonstrate continuos testing and building, feature-level, app-level and backend-level unit testing, "Prompt strategy" notes in project READMEs.

### 5. Impact Analytics (Data-Driven Development) & Product Engineering
Concept: Product-user fit and feature implementation is driven by measurable impact, not just "building features".

Goal: Integrating feedback loops (analytics, logging, user metrics) to validate product-user fit and features actually solve the problem. It shifts the narrative from "I built a feature" to "I improved a metric". This competency involves documenting analytics frameworks at product-user fit level and feature optimisation level.

**Reference**: Product-user fit analytics framework documentation: [Pitboard product-user fit analytics framework](projects/pitboard/README.md#analytics), [vendor0 product-user fit analytics framework](projects/vendor0/README.md#analytics); Firebase analytics integration in projects: [Pitboard Analytics](projects/pitboard/flutter_app/lib/core/services/analytics_service.dart), [vendor0 Analytics](projects/vendor0/flutter_app/lib/core/services/analytics_service.dart)


## Projects
### [Pitboard](projects/pitboard)

Status: Production (shipped)

High-level stack: Flutter (Dart), Firebase (Firestore, Auth, Cloud Functions), Mapbox, Geolocator, platform telemetry channels (accelerometer, gyroscope)

#### Description
Pitboard is a shipped mobile application for iOS (Android in progress) that records motocross rides/sessions using GPS and on-device telemetry, aggregates laps and performance metrics, and provides post-session analysis to help riders evaluate and improve riding performance.

#### High-level Features
- Session recording: high-frequency (1-10hz) GPS and on-device telemetry capture (accelerometers, gyroscopes) for lap and section detection
- Post-ride analysis: backend session data aggregation UI visualisations (sections, metrics, statistics, ride heatmap visualisations)
- Offline-first session data storage with local persistence and background cloud-sync 
- Batched/staged uploads for large session payloads (+2MB) to cloud storage
- User authentication, profiles, and per-user data scoping
- Google analytics integrations

### [vendor0](projects/vendor0)

Status: Production (shipped)

High-level stack: Flutter (Dart), Flask (Python), Firebase (Firestore, Auth, Hosting)

#### Description
vendor0 is a service vendor booking management web-app that helps service vendors manage bookings, manage offered services, business information, and availability. It also attracts customer bookings by automatically generating a public customer booking form through reserving a unique URL slug.

#### High-level Features
- Service vendor business profile management (name, contact, services)
- Unique public URL slug reservation
- Public customer service booking form accessed via service vendor's unqiue URL slug
- Vendor service, booking and availability management 
- Flask server-mediated booking creation and slug-reservation to protect IP and prevent abuse


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
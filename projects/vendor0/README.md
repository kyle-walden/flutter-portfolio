
# vendor0

## Overview

vendor0 is a service vendor booking management platform that helps service vendors manage bookings and business information, and attracts more customer bookings by auto-generating a public customer booking form through reserving a unique slug url.

## Live Status

- Platforms: Flutter Web (primary)
- Status: Production (shipped)
- Role: Primary developer / architect for the web client and app-level integrations
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

- Vendor business profile management (name, contact, services)
- Unique public slug reservation and ownership for vendor pages
- Vendor booking & availability management (CRUD for availability rules)
- Public customer booking form accessed via vendor slug
- Server-mediated booking creation to protect Firestore rules
- CI: build, test and archive artifacts; CD: deploy web build to Firebase Hosting

## Tech Stack

- Client: Flutter (Web-focused delivery; provider for state)
- Backend: Python (Flask) thin API for slug reservation and server-side booking
- Database: Google Firestore (primary data store)
- Auth: Firebase Auth (ID tokens for vendor auth)
- Hosting & Runtime: Firebase Hosting (web), Cloud Run (server containers)
- CI/CD: GitHub Actions, Firebase Hosting deploys

## Architecture Overview

- Refer to portfolio-level shared architecture documentation for Flutter projects - all standard patterns and practices apply.

## Technical Challenges

- Slug reservation atomicity and concurrency
	- Problem: multiple vendors may attempt to reserve the same slug concurrently, causing race conditions and ownership disputes.
	- Approach: enforce uniqueness server-side using transactions or conditional writes, return idempotent responses, and add rate-limiting and audit logging to surface contention.

- Secure server-mediated booking flow
	- Problem: public booking endpoints must accept unauthenticated requests (customers) while enforcing vendor ownership and preventing spoofing.
	- Approach: validate payloads server-side, require server-to-server verification for owner-scoped operations, use idempotency keys for retries, and log audit trails for booking creation.

## Rationales
Tradeoffs / Decisions / Edge Cases

- Provider for state management
	- Why: `provider` (ChangeNotifier) keeps the web client simple and fast to iterate — minimal boilerplate and straightforward provider overrides for testing and DI.
	- Trade-offs: less structured than alternatives (Riverpod/Bloc) for very large apps; acceptable here because feature logic is kept in repositories and services.

- Flask (Cloud Run) vs serverless Functions
	- Why: a thin Flask API deployed on Cloud Run provides predictable runtime behavior, easier local debugging, and explicit control over HTTP semantics for slug reservation and booking workflows.
	- Trade-offs: higher ops responsibility than pure serverless Functions and additional container CI/CD complexity; Cloud Run was chosen to balance control and manageability for third-party integrations.
	- Edge cases / mitigation: keep request validation and ownership logic server-side; use container image pinning and health checks to reduce drift.

- Firestore as primary datastore
	- Why: Firestore's real-time capabilities and existing Firebase Auth integration reduced integration work and aligned with other portfolio projects.
	- Trade-offs: query patterns and indexing require design attention; avoid expensive queries on large collections by modeling data for access patterns.
	- Edge cases / mitigation: design slug -> vendor lookups with indexed collections and consider a caching layer for hot slug resolution.

- Server-mediated slug reservation & booking
	- Why: ownership and reservation of public slugs is enforced server-side to prevent spoofing, abuse, and to centralize business rules.
	- Trade-offs: requires additional backend endpoints and auth checks but simplifies client logic and Firestore rules.
	- Edge cases / mitigation: validate idempotency and concurrency on reservation endpoints; implement rate-limiting and audit logs for ownership operations.

## Repository Structure

Refer to each README.md in the folders for more details and further structure.

- `backend/` — Flask demo service, Dockerfile and deployment notes (server-side slug reservation and public booking endpoints)
- `ci/` — CI/CD templates and GitHub Actions workflows (build/test, deploy)
- `flutter_app/` — Flutter Web client (feature-first architecture: `lib/app`, `lib/core`, `lib/features`, `lib/shared_widgets`)
- `screenshots/` — curated UI screenshots for portfolio presentation

## Analytics

TODO: Example of product-user fit analytics framework documentation. 

## Notes

- Security / abstraction disclaimer:
	- This repository is intentionally redacted for public distribution.
	- Secrets, credential files, production configuration, and some implementation details are omitted.



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

- Refer to portfolio-level shared architecture documentation for Flutter projects - all standard patterns and practices apply.image builds to Cloud Run.

## Technical Challenges

-

## Rationales
Tradeoffs / Decisions / Edge Cases

-

## Repository Structure

Refer to each README.md in the folders for more details and further structure.

- `backend/` — Flask demo service, Dockerfile and deployment notes (server-side slug reservation and public booking endpoints)
- `ci/` — CI/CD templates and GitHub Actions workflows (build/test, deploy)
- `flutter_app/` — Flutter Web client (feature-first architecture: `lib/app`, `lib/core`, `lib/features`, `lib/shared_widgets`)
- `screenshots/` — curated UI screenshots for portfolio presentation

## Analytics

Example of product-user fit analytics framework documentation. 

## Notes

- Security / abstraction disclaimer:
	- This repository is intentionally redacted for public distribution.
	- Secrets, credential files, production configuration, and some implementation details are omitted.


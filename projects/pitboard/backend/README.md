# Backend

## Purpose

- Provide server-side business logic, integrations, and background processing for the Pitboard Flutter client.
- Protect IP - internal algorithms and session aggregation logic.

## Tech Stack

- Runtime: Node.js 18 (Firebase Functions) with TypeScript
- Serverless: Firebase Cloud Functions 
- Observability: Cloud Logging, Error Reporting

## Architecture Overview

- Requests and background events are handled by Firebase Functions located under `firebase/functions`.
- The `functions/src/index.ts` file is the bootstrap that exports HTTP/Callable handlers and triggers; it delegates to service modules.
- Domain logic is implemented in `functions/src/services` — currently the primary service is `sessionAggregator.ts`, which encapsulates the session-aggregation algorithm used by the app.

## Firebase Functions Structure

- firebase/
  - functions/
    - src/
      - index.ts — function exports and trigger registration (bootstrap)
      - services/
        - sessionAggregator.ts — core session aggregation algorithm and helpers
    - package.json, tsconfig.json, README.md
    - tests/ — unit tests for function services

- Responsibilities / patterns
  - Keep `index.ts` minimal; route to services for domain logic.
  - Centralize heavier algorithmic code (session aggregation) in `services/` to protect IP and simplify client code.
  - Validate inputs at the entry points and keep repo access scoped to small helper functions.

## Key Endpoints / Triggers

- Callable functions 
  - Callable: aggregateSessions

- Background triggers
  - Stubbed: Can trigger functions based on auth events, storage events, Firestore document changes, and scheduled tasks.

## Security Considerations

- Secrets and config
  - Store secrets in Firebase runtime config or secret manager; do not commit to repo.

- Operational safety
  - Rate-limit or throttle abusive endpoints where feasible.
  - Structured logging and error reporting; avoid leaking PII in logs.

## Notes

- This README documents the backend workspace and responsibilities; concrete configuration (project IDs, keys) is intentionally redacted.
- Implementation choices favor low-ops serverless patterns: small stateless functions, Firestore as the primary data store, and background triggers for heavier work.

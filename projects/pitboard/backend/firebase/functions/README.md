Pitboard Functions (example)
============================

This folder contains a minimal TypeScript Firebase Functions example designed for portfolio display and local testing with the Firebase emulator. It includes:

- A health HTTP endpoint (`status`)
- An authenticated-ish session create endpoint (`createSession`) (demo only — auth is simplified)
- A Firestore `onCreate` trigger for the `history` collection that writes an audit record
- Unit tests for the HTTP status endpoint

Follow the top-level `projects/pitboard/backend/README.md` for quickstart and emulator instructions.

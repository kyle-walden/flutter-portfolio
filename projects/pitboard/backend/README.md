Backend for pitboard (functions)
================================

This folder contains a minimal, redacted Firebase Functions scaffold suitable for local testing and portfolio display. The implementation is intentionally small.

For Pitboard, the backend primarily consists of serverless functions for data (session level) aggregation, notifications, and lightweight business logic. The full production backend is not included in this redacted snapshot.

What's included
- `firebase/` — Firebase project config and local emulator setup
  - `functions/` — TypeScript functions project (source, tests, and scripts)
  - `firebase.json` — emulator & functions configuration
  - `.firebaserc` — project aliases 

Available npm scripts (inside `functions/`)
- `npm run build` — compile TypeScript
- `npm run lint` — run ESLint
- `npm run test` — run Jest unit tests
- `npm run emulate` — start firebase emulators (alias for `firebase emulators:start`)

Security note
- No production credentials or service account keys are checked in. Use `.env.example` as a template for local env vars. Configure real secrets via CI/CD (GitHub Secrets, Xcode Cloud envs) or Google Secret Manager for production deployments.

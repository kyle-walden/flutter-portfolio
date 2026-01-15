
# CI / CD

## Purpose

Ensure consistent quality gates and reliable delivery of the Pitboard Flutter app and its backend components by running builds, tests, and automated release pipelines. Provide reproducible artifacts for QA and controlled production releases.

## Pipelines
- GitHub Actions:
	- PR / push CI — static analysis, unit & widget tests, build artifacts for web and Android.
	- Release workflows — build Android App Bundle, produce iOS artifacts (when run in CI) and publish artifacts to internal distribution channels.
- Xcode Cloud:
	- iOS archives, integration tests, TestFlight distribution and optional App Store submission automation.

## What Runs Automatically
- Static analysis and linting (`flutter analyze`, analyzer rules).
- Unit and widget tests (`flutter test`).
- Build artifacts: Android AAB, iOS archive (via Xcode Cloud), and web builds for hosting.
- Optional smoke/integration tests against staging backends.

## Branch Strategy
- `main` — production-ready; merges here do not trigger release pipelines and distribution.

## Delivery Flow
1. Open Xcode Cloud
2. Manually trigger a build, pulls from `main` branch - runs pre-build script, `xcodebuild`, post-build script (ci/xcode-cloud/)
3. Produces an iOS archive and uploads to TestFlight for internal distribution
3. Deploy from App Store Connect to production when ready.

## Notes
- Store service accounts and tokens must be kept in secrets (GitHub Secrets / App Store Connect keys / Google Play credentials). Never commit keys.
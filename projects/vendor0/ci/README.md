
# CI / CD

## Purpose

Ensure code quality and delivery reliability by running builds, tests and automated deployments for the Flutter client and its backend components. Provide reproducible artifacts for review and enable fast rollback.

## Pipelines
- GitHub Actions:
	- `ci.yml` — analyze, unit tests, widget tests, build web (`flutter build web`) and upload artifacts.
	- `cd-firebase-hosting.yml` — build web and deploy `build/web` to Firebase Hosting (trigger: push to `main`).

## What Runs Automatically
- Static analysis (`flutter analyze`) and lint checks.
- Unit and widget tests (`flutter test`).
- Release builds (`flutter build web`) and artifact upload for QA.
- On `main` merges: automated deployment to Firebase Hosting (web) and triggers for backend CI/CD (Cloud Build → Cloud Run) where configured.

## Branch Strategy
- `main` — production-ready; merges here trigger CD to Firebase Hosting.

## Release Flow
1. Developer opens PR from `feature/*` → automated CI (analyze, tests, build artifact).
2. Code review + approvals; merge to `develop` for staging validation (if used).
3. Merge to `main` triggers CD:
	 - Build web artifact and deploy to Firebase Hosting.
	 - Backend image build/push and Cloud Run deploy (via Cloud Build or dedicated workflow).
4. Monitor logs and metrics; rollback by redeploying previous artifact or reverting the merge.

## Notes
- Secrets and service accounts are stored in GitHub Secrets (e.g., `FIREBASE_SERVICE_ACCOUNT`) and are never committed.
- This setup minimizes ops by using managed services (GitHub Actions + Firebase Hosting + Cloud Run).


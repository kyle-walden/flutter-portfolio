# Pitboard (abstracted)

This folder is an abstracted, non-sensitive refractor of the original `Pitboard` project. It demonstrates the end-to-end structure used in the actual app.

- Front-end: `flutter_app` (Flutter app architecture, feature-driven)
- Backend: `backend` (small example server and tests)
- CI: `ci` (GitHub Actions skeleton)

Purpose: provide a lightweight, reviewable snapshot of the project that shows architecture, testing, and CI/CD without including private data.

Supported platforms: iOS, Android

Quick start (local):

1. Front-end (Flutter):

```bash
# from repository root
cd flutter-portfolio/pitboard/flutter_app
flutter pub get
flutter run -d chrome   # or -d <device>
```

2. Backend (Python/Flask):

```bash
cd flutter-portfolio/pitboard/backend
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python main/app.py
# health: curl http://localhost:8000/health
```

Notes:
- This is intentionally minimal and abstracted; sensitive or proprietary logic from the original `../Pitboard` project has been removed.
- CI is a skeleton showing tests for front-end and backend. Secrets (API keys, etc.) are intentionally omitted.

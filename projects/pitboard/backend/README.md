# Backend (abstracted)

This folder contains a tiny Flask-based example server used to demonstrate backend ownership and tests. It is intentionally small and contains only example endpoints.

Run locally:

```bash
cd flutter-portfolio/pitboard/backend
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python main/app.py
```

Health endpoint: `GET /health` returns `{ "status": "ok" }`.

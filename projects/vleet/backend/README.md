# Fleet — Backend

FastAPI (Python 3.11+) + SQLAlchemy (async) + Alembic + PydanticAI

## Bootstrap (run this once)

```bash
cd projects/fleet/backend
python3.11 -m venv .venv
source .venv/bin/activate

pip install fastapi "uvicorn[standard]" sqlalchemy asyncpg alembic
pip install pydantic-settings python-dotenv
pip install pydantic-ai
pip install google-generativeai          # Gemini 1.5 Flash
pip install pymupdf pdf2image            # PDF handling for Feature A
pip install redis                        # Caching + job status
pip install pytest pytest-asyncio httpx  # Testing
```

## Planned Structure

```
backend/
├── main.py                             # FastAPI app factory
├── alembic/                            # DB migrations (≈ Firebase schema evolution)
├── sql/
│   └── init.sql                        # Enables pgvector extension on first run
├── app/
│   ├── core/
│   │   ├── config.py                   # Settings via pydantic-settings  (≈ core/config/)
│   │   ├── database.py                 # Async SQLAlchemy engine + session
│   │   └── cache.py                    # Redis client
│   ├── models/                         # SQLAlchemy ORM models  (≈ core/models/)
│   │   ├── vehicle.py
│   │   ├── driver.py
│   │   ├── fuel_transaction.py
│   │   └── driver_note.py              # Stores pgvector embeddings
│   ├── schemas/                        # Pydantic request/response schemas
│   │   ├── vehicle.py
│   │   ├── driver.py
│   │   └── fuel_transaction.py
│   ├── repositories/                   # Data access layer  (≈ features/*/repo/)
│   │   ├── vehicle_repository.py
│   │   ├── driver_repository.py
│   │   └── fuel_repository.py
│   ├── services/                       # Business logic  (≈ core/services/)
│   │   ├── ingest_service.py           # Feature A: PDF → structured transactions
│   │   └── analyst_service.py         # Feature B: NL → SQL → insight
│   └── routers/                        # FastAPI routers (one per resource)
│       ├── vehicles.py
│       ├── drivers.py
│       ├── fuel.py
│       ├── ingest.py
│       └── analyst.py
└── tests/
    ├── test_vehicles.py
    ├── test_ingest.py
    └── test_analyst_evals.py           # 20 golden queries eval suite
```

## Running

```bash
# Ensure Docker services are up first
docker-compose up -d

# Start dev server
source .venv/bin/activate
uvicorn main:app --reload --port 8000
```

API docs available at `http://localhost:8000/docs`

## Environment Variables

Copy `.env.example` to `.env` and fill in values:

```
DATABASE_URL=postgresql+asyncpg://fleet:fleet_dev_password@localhost:5432/fleet_db
REDIS_URL=redis://localhost:6379
GEMINI_API_KEY=your_key_here
```

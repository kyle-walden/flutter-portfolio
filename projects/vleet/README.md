# Fleet — Vehicle Logistics Management Platform

A full-stack (React / Next.js, FastAPI) fleet management web app with three core domains:

1. **Vehicles** — register, track status, and monitor odometer readings
2. **Drivers** — manage driver profiles and vehicle assignments
3. **Fuel Analytics** — analyse consumption per driver and vehicle from uploaded fuel card statements

> [How to run locally](#how-to-run-locally)

## What Makes It an AI Engineering Project

| Feature | Description |
|---|---|
| Zero-Entry Ingestor | Upload a PDF/CSV fuel card statement; an LLM extracts structured transactions |
| Natural Language Analyst | Ask questions in plain English; a Text-to-SQL agent queries the database |
| Semantic Driver Notes | pgvector stores unstructured notes so the analyst can blend SQL and semantic search |

## Stack

| Layer | Technology |
|---|---|
| Frontend | Next.js 15 (App Router) + Tailwind CSS + Tremor |
| Backend | FastAPI (Python 3.11+) |
| Database | PostgreSQL 16 + pgvector |
| Cache | Redis |
| AI Orchestration | PydanticAI |
| LLM | Gemini 1.5 Flash |

## Monorepo Structure

```
fleet/
├── frontend/     # Next.js App Router project
├── backend/      # FastAPI project
└── docker-compose.yml   # PostgreSQL + pgvector + Redis
```

## How to Run Locally

### Prerequisites

- **Python 3.11+** — for the FastAPI backend
- **Node.js 18+** — for the Next.js frontend
- **Docker & Docker Compose** — for PostgreSQL (with pgvector) and Redis
- **Gemini API Key** — from [Google AI Studio](https://aistudio.google.com/apikey)

### 1. Start Docker Services (PostgreSQL + Redis)

```bash
# From the project root
docker-compose up -d

# Verify services are healthy
docker-compose ps
```

This starts:
- **PostgreSQL 16** with pgvector extension on port 5432
- **Redis** on port 6379

### 2. Set Up the Backend

```bash
cd backend

# Create and activate virtual environment (one time)
python3.11 -m venv .venv
source .venv/bin/activate

# Install dependencies
pip install -r requirements.txt  # or follow bootstrap instructions in backend/README.md

# Configure environment variables
# Copy .env if needed and ensure DATABASE_URL and REDIS_URL are set
# Add your GEMINI_API_KEY from Google AI Studio
```

Run the backend dev server:

```bash
source .venv/bin/activate
uvicorn main:app --reload --port 8000
```

API docs available at `http://localhost:8000/docs`

### 3. Set Up the Frontend

```bash
cd frontend

# Install dependencies (one time)
npm install

# Configure environment (optional)
# Create .env.local if needed for API base URL
```

Run the frontend dev server:

```bash
npm run dev
```

Frontend available at `http://localhost:3000`

### 4. Verify Everything Works

1. **Backend Health Check**
   ```bash
   curl http://localhost:8000/health
   ```
   Should return: `{"status":"ok"}`

2. **Frontend**
   Navigate to `http://localhost:3000` and confirm the dashboard loads.

3. **API Documentation**
   Visit `http://localhost:8000/docs` to interact with the API directly.

### Stopping Services

```bash
# Stop Docker containers
docker-compose down

# Keep data volumes for next run
# Remove data volumes (if you want a fresh database)
docker-compose down -v
```

### Troubleshooting

**PostgreSQL Connection Errors**
- Ensure Docker is running: `docker ps`
- Check if port 5432 is not in use: `lsof -i :5432`
- Verify .env has correct `DATABASE_URL`

**Backend won't start**
- Ensure virtual environment is activated: `source .venv/bin/activate`
- Check Python version: `python --version` (should be 3.11+)
- Reinstall dependencies: `pip install -r requirements.txt`

**Redis Connection Issues**
- Ensure Redis is running in Docker: `docker-compose ps`
- Check port 6379: `lsof -i :6379`

**Frontend won't compile**
- Clear Next.js cache: `rm -rf .next`
- Reinstall dependencies: `npm install`
- Ensure Node version: `node --version` (should be 18+)


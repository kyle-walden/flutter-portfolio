import uuid
from fastapi import APIRouter, UploadFile, File, BackgroundTasks
from app.services.ingest_service import process_document
from app.core.cache import redis_client

router = APIRouter(prefix="/ingest", tags=["ingest"])

@router.post("/upload", status_code=202)
async def upload_document(
    background_tasks: BackgroundTasks,
    file: UploadFile = File(...),
):
    """
    Immediately returns a job_id. Processing happens asynchronously.
    The UI polls GET /ingest/status/{job_id} to check progress.

    This pattern prevents the user seeing a 30-second spinner.
    """
    job_id = str(uuid.uuid4())
    contents = await file.read()

    # Store initial status in Redis
    await redis_client.set(f"job:{job_id}", "processing", ex=3600)

    # Schedule background processing — does not block the response
    background_tasks.add_task(process_document, job_id, contents, file.filename)

    return {"job_id": job_id, "status": "processing"}


@router.get("/status/{job_id}")
async def get_job_status(job_id: str):
    status = await redis_client.get(f"job:{job_id}")
    if not status:
        return {"status": "not_found"}
    result = await redis_client.get(f"job:{job_id}:result")
    return {"status": status, "result": result}


@router.post("/approve/{job_id}")
async def approve_transactions(job_id: str, session: AsyncSession = Depends(get_session)):
    """Commits AI-extracted transactions to the database after user review."""
    ...
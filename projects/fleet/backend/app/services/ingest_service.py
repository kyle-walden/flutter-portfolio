import json
import base64
import pymupdf
from pydantic import BaseModel
from pydantic_ai import Agent
from pydantic_ai.models.gemini import GeminiModel

# Define the structured output — the LLM MUST return this shape
class ExtractedTransaction(BaseModel):
    transaction_date: str       # ISO 8601 e.g. "2024-03-15"
    vehicle_registration: str
    liters: float
    total_cost: float
    merchant: str | None = None
    odometer_km: int | None = None

class ExtractionResult(BaseModel):
    transactions: list[ExtractedTransaction]
    confidence: float   # 0.0–1.0, LLM's self-reported confidence
    warnings: list[str] = []

# PydanticAI agent — structured output is enforced automatically
ingest_agent = Agent(
    GeminiModel('gemini-1.5-flash'),
    result_type=ExtractionResult,
    system_prompt="""
    You are a fuel card statement parser.
    Extract all fuel transactions from the provided document.
    For each transaction, extract: date, vehicle registration, liters filled,
    total cost (in local currency), merchant name, and odometer reading if present.
    If a field is missing, use null.
    Set confidence between 0.0 (very uncertain) and 1.0 (very certain).
    Add warnings for any rows that seem suspicious or have missing critical data.
    """
)

async def process_document(job_id: str, contents: bytes, filename: str):
    """Background task — runs after the HTTP response has been sent."""
    try:
        # Extract text from PDF using PyMuPDF
        if filename.lower().endswith('.pdf'):
            doc = pymupdf.open(stream=contents, filetype="pdf")
            text = "\n".join(page.get_text() for page in doc)
        else:
            text = contents.decode('utf-8')  # CSV

        # Run the PydanticAI agent
        result = await ingest_agent.run(
            f"Parse this fuel card statement:\n\n{text}"
        )

        # Store result in Redis for the frontend to poll
        await redis_client.set(
            f"job:{job_id}:result",
            result.data.model_dump_json(),
            ex=3600
        )
        await redis_client.set(f"job:{job_id}", "completed", ex=3600)

    except Exception as e:
        await redis_client.set(f"job:{job_id}", "failed", ex=3600)
        await redis_client.set(f"job:{job_id}:error", str(e), ex=3600)
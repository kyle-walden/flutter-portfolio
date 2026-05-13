from fastapi import APIRouter, Depends
from fastapi.responses import StreamingResponse
from pydantic import BaseModel
import json

router = APIRouter(prefix="/analyst", tags=["analyst"])

class QuestionRequest(BaseModel):
    question: str

@router.post("/ask")
async def ask_question(
    request: QuestionRequest,
    session: AsyncSession = Depends(get_session),
):
    result = await answer_question(request.question, session)
    return result
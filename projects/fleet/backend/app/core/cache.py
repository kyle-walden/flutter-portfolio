import hashlib
import json
import redis.asyncio as redis
from app.core.config import settings

redis_client = redis.from_url(settings.REDIS_URL)

CACHE_TTL = 300  # 5 minutes

async def cached_analyst_query(question: str, session):
    """
    Cache SQL results for common queries.
    Cache key = hash of the question string.
    Invalidate on any data mutation (handled by cache.clear_fleet_data()).
    """
    cache_key = f"analyst:{hashlib.md5(question.encode()).hexdigest()}"
    cached = await redis_client.get(cache_key)

    if cached:
        return json.loads(cached)

    from app.services.analyst_service import answer_question
    result = await answer_question(question, session)
    await redis_client.set(cache_key, result.model_dump_json(), ex=CACHE_TTL)
    return result
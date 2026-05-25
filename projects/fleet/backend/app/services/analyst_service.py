from pydantic import BaseModel
from pydantic_ai import Agent
from pydantic_ai.models.gemini import GeminiModel
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import text
import json

DB_SCHEMA = """
Table: vehicles (id, registration, make, model, year, odometer_km, status)
Table: drivers (id, first_name, last_name, license_number, status, assigned_vehicle_id)
Table: fuel_transactions (id, vehicle_id, driver_id, transaction_date, odometer_km, liters, total_cost, merchant)
Table: driver_notes (id, driver_id, note, created_at)
"""

class SQLResult(BaseModel):
    sql: str
    explanation: str   # LLM explains what the SQL does

class AnalystInsight(BaseModel):
    insight: str
    sql_used: str
    raw_data: list[dict]

sql_agent = Agent(
    GeminiModel('gemini-1.5-flash'),
    result_type=SQLResult,
    system_prompt=f"""
    You are a fleet data analyst. You have access to this PostgreSQL database schema:

    {DB_SCHEMA}

    When given a question, generate a safe SELECT SQL query (no mutations).
    Always include LIMIT 100 to prevent large result sets.
    Explain what the query does in plain English.
    """
)

insight_agent = Agent(
    GeminiModel('gemini-1.5-flash'),
    system_prompt="""
    You are a fleet analyst. You will receive raw SQL query results as JSON.
    Convert the data into a clear, actionable insight in 2-3 sentences.
    Include specific numbers, percentages, and comparisons where relevant.
    Flag any anomalies or concerns.
    """
)

async def answer_question(question: str, session: AsyncSession) -> AnalystInsight:
    # Step 1: Generate SQL
    sql_result = await sql_agent.run(question)
    sql_query = sql_result.data.sql

    # Step 2: Execute SQL (with safety guardrail — SELECT only)
    if not sql_query.strip().upper().startswith("SELECT"):
        raise ValueError("Only SELECT queries are permitted")

    rows = await session.execute(text(sql_query))
    raw_data = [dict(row._mapping) for row in rows.fetchall()]

    # Step 3: Generate human-readable insight
    insight_prompt = f"""
    Question: {question}
    Query result: {json.dumps(raw_data, default=str)}

    Provide a concise insight.
    """
    insight_result = await insight_agent.run(insight_prompt)

    return AnalystInsight(
        insight=insight_result.data,
        sql_used=sql_query,
        raw_data=raw_data,
    )
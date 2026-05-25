import pytest

GOLDEN_QUERIES = [
    {
        "question": "How many vehicles are currently active?",
        "expect_sql_contains": "WHERE status = 'active'",
        "expect_int_result": True,
    },
    {
        "question": "What is the total fuel spend this month?",
        "expect_sql_contains": ["SUM", "total_cost"],
        "expect_float_result": True,
    },
    {
        "question": "Which driver filled up most frequently last week?",
        "expect_sql_contains": ["COUNT", "drivers", "GROUP BY"],
    },
    # ... add up to 20
]

@pytest.mark.asyncio
async def test_golden_queries(async_session):
    from app.services.analyst_service import answer_question
    for q in GOLDEN_QUERIES:
        result = await answer_question(q["question"], async_session)
        assert result.sql_used is not None
        if "expect_sql_contains" in q:
            terms = q["expect_sql_contains"] if isinstance(q["expect_sql_contains"], list) else [q["expect_sql_contains"]]
            for term in terms:
                assert term.lower() in result.sql_used.lower(), \
                    f"Expected '{term}' in SQL for question: {q['question']}"
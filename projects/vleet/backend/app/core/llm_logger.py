import time
import logging

logger = logging.getLogger("llm")

class LLMCall:
    def __init__(self, feature: str, question: str):
        self.feature = feature
        self.question = question
        self.start = time.time()

    def log_result(self, result, token_usage: dict | None = None):
        elapsed = time.time() - self.start
        logger.info({
            "feature": self.feature,
            "question_preview": self.question[:100],
            "latency_ms": round(elapsed * 1000),
            "tokens": token_usage,
        })
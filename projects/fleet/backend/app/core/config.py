from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    DATABASE_URL: str = "postgresql+asyncpg://fleet:fleet_dev_password@localhost:5432/fleet_db"
    REDIS_URL: str = "redis://localhost:6379"
    GEMINI_API_KEY: str = ""

    model_config = {"env_file": ".env"}


settings = Settings()

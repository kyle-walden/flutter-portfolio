import uuid
from datetime import datetime
from sqlalchemy import String, Integer, DateTime, Enum
from sqlalchemy.orm import Mapped, mapped_column
from app.core.database import Base

class Vehicle(Base):
    __tablename__ = "vehicles"

    id: Mapped[str] = mapped_column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    registration: Mapped[str] = mapped_column(String(20), unique=True, nullable=False)
    make: Mapped[str] = mapped_column(String(100), nullable=False)
    model: Mapped[str] = mapped_column(String(100), nullable=False)
    year: Mapped[int] = mapped_column(Integer, nullable=False)
    odometer_km: Mapped[int] = mapped_column(Integer, default=0)
    status: Mapped[str] = mapped_column(String(20), default="active")  # active, maintenance, retired
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow)
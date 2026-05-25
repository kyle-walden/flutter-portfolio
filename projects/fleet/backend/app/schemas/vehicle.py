# backend/app/schemas/vehicle.py
from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class VehicleCreate(BaseModel):
    registration: str
    make: str
    model: str
    year: int
    odometer_km: int = 0
    status: str = "active"

class VehicleUpdate(BaseModel):
    registration: Optional[str] = None
    make: Optional[str] = None
    model: Optional[str] = None
    year: Optional[int] = None
    odometer_km: Optional[int] = None
    status: Optional[str] = None

class VehicleResponse(VehicleCreate):
    id: str
    created_at: datetime

    model_config = {"from_attributes": True}  # allows ORM model → schema conversion
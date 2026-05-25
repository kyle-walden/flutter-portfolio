from pydantic import BaseModel
from typing import Optional
from datetime import datetime


class DriverCreate(BaseModel):
    first_name: str
    last_name: str
    license_number: str
    license_expiry: datetime
    phone: Optional[str] = None
    email: Optional[str] = None
    status: str = "active"
    assigned_vehicle_id: Optional[str] = None


class DriverUpdate(BaseModel):
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    license_number: Optional[str] = None
    license_expiry: Optional[datetime] = None
    phone: Optional[str] = None
    email: Optional[str] = None
    status: Optional[str] = None
    assigned_vehicle_id: Optional[str] = None


class DriverResponse(DriverCreate):
    id: str
    created_at: datetime

    model_config = {"from_attributes": True}

from fastapi import APIRouter, HTTPException, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from app.core.database import get_session
from app.repositories.vehicle_repository import VehicleRepository
from app.schemas.vehicle import VehicleCreate, VehicleUpdate, VehicleResponse

router = APIRouter(prefix="/vehicles", tags=["vehicles"])

@router.get("/", response_model=list[VehicleResponse])
async def list_vehicles(session: AsyncSession = Depends(get_session)):
    repo = VehicleRepository(session)
    return await repo.get_all()

@router.get("/{vehicle_id}", response_model=VehicleResponse)
async def get_vehicle(vehicle_id: str, session: AsyncSession = Depends(get_session)):
    repo = VehicleRepository(session)
    vehicle = await repo.get_by_id(vehicle_id)
    if not vehicle:
        raise HTTPException(status_code=404, detail="Vehicle not found")
    return vehicle

@router.post("/", response_model=VehicleResponse, status_code=201)
async def create_vehicle(data: VehicleCreate, session: AsyncSession = Depends(get_session)):
    repo = VehicleRepository(session)
    return await repo.create(data)

@router.put("/{vehicle_id}", response_model=VehicleResponse)
async def update_vehicle(vehicle_id: str, data: VehicleUpdate, session: AsyncSession = Depends(get_session)):
    repo = VehicleRepository(session)
    vehicle = await repo.get_by_id(vehicle_id)
    if not vehicle:
        raise HTTPException(status_code=404, detail="Vehicle not found")
    return await repo.update(vehicle, data)

@router.delete("/{vehicle_id}", status_code=204)
async def delete_vehicle(vehicle_id: str, session: AsyncSession = Depends(get_session)):
    repo = VehicleRepository(session)
    vehicle = await repo.get_by_id(vehicle_id)
    if not vehicle:
        raise HTTPException(status_code=404, detail="Vehicle not found")
    await repo.delete(vehicle)
from fastapi import APIRouter, HTTPException, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from app.core.database import get_session
from app.repositories.driver_repository import DriverRepository
from app.schemas.driver import DriverCreate, DriverUpdate, DriverResponse

router = APIRouter(prefix="/drivers", tags=["drivers"])


@router.get("/", response_model=list[DriverResponse])
async def list_drivers(session: AsyncSession = Depends(get_session)):
    repo = DriverRepository(session)
    return await repo.get_all()


@router.get("/{driver_id}", response_model=DriverResponse)
async def get_driver(driver_id: str, session: AsyncSession = Depends(get_session)):
    repo = DriverRepository(session)
    driver = await repo.get_by_id(driver_id)
    if not driver:
        raise HTTPException(status_code=404, detail="Driver not found")
    return driver


@router.post("/", response_model=DriverResponse, status_code=201)
async def create_driver(data: DriverCreate, session: AsyncSession = Depends(get_session)):
    repo = DriverRepository(session)
    return await repo.create(data)


@router.put("/{driver_id}", response_model=DriverResponse)
async def update_driver(driver_id: str, data: DriverUpdate, session: AsyncSession = Depends(get_session)):
    repo = DriverRepository(session)
    driver = await repo.get_by_id(driver_id)
    if not driver:
        raise HTTPException(status_code=404, detail="Driver not found")
    return await repo.update(driver, data)


@router.delete("/{driver_id}", status_code=204)
async def delete_driver(driver_id: str, session: AsyncSession = Depends(get_session)):
    repo = DriverRepository(session)
    driver = await repo.get_by_id(driver_id)
    if not driver:
        raise HTTPException(status_code=404, detail="Driver not found")
    await repo.delete(driver)

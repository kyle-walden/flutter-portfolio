from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from app.models.driver import Driver
from app.schemas.driver import DriverCreate, DriverUpdate


class DriverRepository:
    def __init__(self, session: AsyncSession):
        self.session = session

    async def get_all(self) -> list[Driver]:
        result = await self.session.execute(select(Driver))
        return result.scalars().all()

    async def get_by_id(self, driver_id: str) -> Driver | None:
        result = await self.session.execute(select(Driver).where(Driver.id == driver_id))
        return result.scalar_one_or_none()

    async def create(self, data: DriverCreate) -> Driver:
        driver = Driver(**data.model_dump())
        self.session.add(driver)
        await self.session.commit()
        await self.session.refresh(driver)
        return driver

    async def update(self, driver: Driver, data: DriverUpdate) -> Driver:
        for field, value in data.model_dump(exclude_unset=True).items():
            setattr(driver, field, value)
        await self.session.commit()
        await self.session.refresh(driver)
        return driver

    async def delete(self, driver: Driver) -> None:
        await self.session.delete(driver)
        await self.session.commit()

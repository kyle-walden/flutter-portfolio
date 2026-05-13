@router.get("/summary/by-vehicle")
async def consumption_by_vehicle(session: AsyncSession = Depends(get_session)):
    """
    Returns L/100km per vehicle.
    Formula: (total_liters / total_km_driven) * 100
    """
    # Use SQLAlchemy aggregation or raw SQL
    ...
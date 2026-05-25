class FuelTransaction(Base):
    __tablename__ = "fuel_transactions"

    id: Mapped[str] = mapped_column(String, primary_key=True, default=lambda: str(uuid.uuid4()))
    vehicle_id: Mapped[str] = mapped_column(ForeignKey("vehicles.id"), nullable=False)
    driver_id: Mapped[str | None] = mapped_column(ForeignKey("drivers.id"), nullable=True)
    transaction_date: Mapped[datetime] = mapped_column(DateTime, nullable=False)
    odometer_km: Mapped[int] = mapped_column(Integer, nullable=False)
    liters: Mapped[float] = mapped_column(Float, nullable=False)
    total_cost: Mapped[float] = mapped_column(Float, nullable=False)
    merchant: Mapped[str | None] = mapped_column(String(200), nullable=True)
    fuel_card_ref: Mapped[str | None] = mapped_column(String(100), nullable=True)
    source: Mapped[str] = mapped_column(String(20), default="manual")  # manual | ai_ingest
    created_at: Mapped[datetime] = mapped_column(DateTime, default=datetime.utcnow)
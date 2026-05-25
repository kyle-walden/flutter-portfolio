import uuid

from repositories.booking_repository import BookingRepository

_REQUIRED_FIELDS = ("owner_uid", "customer", "date")


class BookingService:
    """Validates and persists public booking requests.

    Separates business logic (validation, ID generation) from persistence
    (BookingRepository) and transport (Flask route handlers).
    """

    def __init__(self, repo: BookingRepository | None = None) -> None:
        self._repo = repo or BookingRepository()

    def create_booking(self, payload: dict) -> dict:
        """Validate payload and create a booking.

        Raises ValueError with a descriptive message on invalid input.
        Returns the created booking dict on success.

        Production note: owner_uid would be cross-checked against the
        authenticated vendor's uid from the JWT claims before persisting
        to Firestore via the Admin SDK.
        """
        missing = [f for f in _REQUIRED_FIELDS if not payload.get(f)]
        if missing:
            raise ValueError(f"Missing required fields: {', '.join(missing)}")

        booking = {
            "id": str(uuid.uuid4()),
            "owner_uid": payload["owner_uid"],
            "customer": str(payload["customer"]),
            "date": str(payload["date"]),
        }
        self._repo.save(booking)
        return booking

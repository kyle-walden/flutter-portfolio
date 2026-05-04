class BookingRepository:
    """In-memory booking store.

    Production swap: replace with Firestore Admin SDK collection write.

    Example production pattern:
        db.collection('vendors').document(owner_uid)
          .collection('bookings').add(booking_dict)
    """

    def __init__(self) -> None:
        self._bookings: list[dict] = []

    def save(self, booking: dict) -> None:
        self._bookings.append(booking)

    def all(self) -> list[dict]:
        return list(self._bookings)

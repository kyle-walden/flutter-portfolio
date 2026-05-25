class SlugRepository:
    """In-memory slug store.

    Production swap: replace with Firestore conditional write (transaction)
    to ensure atomic reservation under concurrent requests.

    Example production pattern:
        db.collection('slugs').document(slug).create({'owner_id': owner_id})
        # Firestore raises AlreadyExists if the doc already exists → handle as 'taken'.
    """

    def __init__(self) -> None:
        self._store: dict[str, str] = {}  # slug → owner_id

    def get(self, slug: str) -> str | None:
        return self._store.get(slug)

    def save(self, slug: str, owner_id: str) -> None:
        self._store[slug] = owner_id

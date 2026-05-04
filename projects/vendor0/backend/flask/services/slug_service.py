import re

from repositories.slug_repository import SlugRepository

_SLUG_RE = re.compile(r"^[a-z0-9][a-z0-9-]{1,38}[a-z0-9]$")


class SlugService:
    """Orchestrates slug validation and reservation.

    Business rules live here; persistence is delegated to SlugRepository.
    """

    def __init__(self, repo: SlugRepository | None = None) -> None:
        self._repo = repo or SlugRepository()

    def validate(self, slug: str) -> bool:
        """Return True if slug meets format requirements."""
        return bool(_SLUG_RE.match(slug))

    def reserve(self, slug: str, owner_id: str) -> dict:
        """Reserve a slug for owner_id.

        Returns a status dict with one of: reserved | already_owned | taken | invalid.
        Idempotent: reserving an already-owned slug by the same owner returns 'already_owned'.
        """
        if not self.validate(slug):
            return {
                "status": "invalid",
                "message": "Slug must be 3–40 lowercase alphanumeric/hyphen characters",
            }

        existing_owner = self._repo.get(slug)
        if existing_owner is None:
            self._repo.save(slug, owner_id)
            return {"status": "reserved", "slug": slug}
        if existing_owner == owner_id:
            return {"status": "already_owned", "slug": slug}
        return {"status": "taken"}

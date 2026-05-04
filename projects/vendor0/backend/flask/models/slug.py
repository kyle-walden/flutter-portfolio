from dataclasses import dataclass


@dataclass
class SlugReservation:
    slug: str
    owner_id: str

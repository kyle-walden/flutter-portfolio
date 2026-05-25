from dataclasses import dataclass


@dataclass
class Booking:
    id: str
    owner_uid: str
    customer: str
    date: str

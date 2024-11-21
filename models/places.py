from pydantic import BaseModel
from uuid import UUID


class Place(BaseModel):
    place_id: UUID
    name: str
from pydantic import BaseModel
from typing import List, Optional

from schemas.locations import Place


class TripDay(BaseModel):
    attractions: Optional[List[Place]] = None
    restaurant: Optional[Place] = None


class Trip(BaseModel):
    name: str
    days: List[TripDay]

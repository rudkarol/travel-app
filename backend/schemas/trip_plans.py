from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime

from schemas.locations import Place


class TripDay(BaseModel):
    attractions: Optional[List[Place]] = None
    restaurant: Optional[Place] = None


class Trip(BaseModel):
    name: str
    start_date: datetime
    days: List[TripDay]

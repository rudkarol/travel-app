from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime

from models.locations import Place


class TripDay(BaseModel):
    places: Optional[List[str]] = None


class Trip(BaseModel):
    name: str
    start_date: datetime
    days: List[TripDay]

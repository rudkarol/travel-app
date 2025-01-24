from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime

from models.locations import LocationDetails


class TripDay(BaseModel):
    places: Optional[List[str]] = None


class Trip(BaseModel):
    name: str
    description: Optional[str] = None
    start_date: Optional[datetime] = None
    days: List[TripDay]


class TripDayResponse(BaseModel):
    places: Optional[List[LocationDetails]] = None


class TripResponse(BaseModel):
    name: str
    description: Optional[str] = None
    start_date: Optional[datetime] = None
    days: List[TripDayResponse]

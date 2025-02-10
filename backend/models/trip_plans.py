from pydantic import BaseModel, Field
from typing import List, Optional
from datetime import datetime
import uuid

from models.locations import LocationDetails


class TripBaseModel(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    name: str
    description: Optional[str] = None
    start_date: Optional[datetime] = None


class TripDay(BaseModel):
    places: Optional[List[str]] = None


class Trip(TripBaseModel):
    days: List[TripDay]


class TripDayResponse(BaseModel):
    places: Optional[List[LocationDetails]] = None


class TripResponse(TripBaseModel):
    days: List[TripDayResponse]

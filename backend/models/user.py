from typing import Optional, List
from odmantic import Model
from pydantic import BaseModel

from models.locations import Place
from models.trip_plans import Trip


class User(BaseModel):
    user_id: str
    email: str
    favorite_places: Optional[List[str]] = None
    trips: Optional[List[Trip]] = None

    # @validator('trips', whole=True)
    # def unique_trip_names(cls, trips):
    #     # Sprawdzenie unikalności nazw
    #     trip_names = [trip.name for trip in trips]
    #     if len(trip_names) != len(set(trip_names)):
    #         raise ValueError("fdghfdfg")
    #     return trips


class DbUser(Model):
    user_id: str
    email: str
    favorite_places: Optional[List[str]] = None
    trips: Optional[List[Trip]] = None


class UserDataUpdate(BaseModel):
    name: Optional[str] = None
    favorite_places: Optional[List[str]] = None
    trips: Optional[List[Trip]] = None

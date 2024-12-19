from typing import Optional, List
from odmantic import Model
from pydantic import BaseModel, EmailStr

from schemas.locations import Place
from schemas.trip_plans import Trip


class User(BaseModel):
    email: EmailStr
    name: Optional[str] = None
    favourite_places: Optional[List[Place]] = None
    trips: Optional[List[Trip]] = None

    # @validator('trips', whole=True)
    # def unique_trip_names(cls, trips):
    #     # Sprawdzenie unikalności nazw
    #     trip_names = [trip.name for trip in trips]
    #     if len(trip_names) != len(set(trip_names)):
    #         raise ValueError("fdghfdfg")
    #     return trips


class DbUser(Model):
    email: EmailStr
    name: Optional[str] = None
    favourite_places: Optional[List[Place]] = None
    trips: Optional[List[Trip]] = None


class UserDataUpdate(BaseModel):
    name: Optional[str] = None
    favourite_places: Optional[List[Place]] = None

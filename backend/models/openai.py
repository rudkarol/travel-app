from pydantic import BaseModel, Field
from typing import List

from models.locations import Location, Place


class AIInputLocation(BaseModel):
    location_id: str
    name: str
    address_string: str

    @classmethod
    def from_location(cls, location: Location) -> 'AIInputLocation':
        return cls(
            location_id=location.location_id,
            name=location.name,
            address_string=location.address_obj.address_string
        )


class AIInputFormat(BaseModel):
    attractions: List[AIInputLocation]
    restaurants: List[AIInputLocation]


class AIResponseDay(BaseModel):
    places: List[Place]


class AIResponseFormat(BaseModel):
    name: str
    description: str
    days: List[AIResponseDay]


class GenerateTripPlanRequest(BaseModel):
    lat: float
    lon: float
    currency: str
    days: int = Field(gt=0, le=7)

from pydantic import BaseModel, Field
from typing import List

from schemas.locations import Location


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


class AIResponseLocation(BaseModel):
    location_id: str
    description: str


class AIResponseDay(BaseModel):
    attractions: List[AIResponseLocation]
    restaurant: AIResponseLocation


class AIResponseFormat(BaseModel):
    days: List[AIResponseDay]


class GenerateTripPlanRequest(BaseModel):
    lat: float
    lon: float
    days: int = Field(gt=0, le=7)

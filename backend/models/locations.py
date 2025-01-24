from pydantic import BaseModel, Field
from typing import Literal, List, Optional

from dependencies import get_settings
from models.risks import CountryAdvisories

settings = get_settings()


class Image(BaseModel):
    url: str

    @classmethod
    def from_response(cls, data: dict) -> "Image":
        return cls(
            url=data["images"]["large"]["url"]
        )


class Place(BaseModel):
    location_id: str
    name: str
    description: Optional[str] = None


class AddressObj(BaseModel):
    # street1: Optional[str]
    # street2: Optional[str]
    # city: str
    # state: str
    country: Optional[str] = None
    # postalcode: Optional[str]
    address_string: str


class Location(BaseModel):
    location_id: str
    name: str
    address_obj: AddressObj
    photos: Optional[List[Image]] = None


class TripadvisorRequest(BaseModel):
    key: str = settings.tripadvisor_api_key


class TripadvisorFindSearchRequest(TripadvisorRequest):
    query: str = Field(..., alias="searchQuery")
    category: Optional[Literal["hotels", "attractions", "restaurants", "geos"]] = None


class SearchRequest(BaseModel):
    query: str
    category: Optional[Literal["hotels", "attractions", "restaurants", "geos"]] = None


class NearbySearchRequest(BaseModel):
    lat: float
    lon: float
    category: Optional[Literal["hotels", "attractions", "restaurants", "geos"]] = None


class SearchResponse(BaseModel):
    data: List[Location]

    def to_ai_input_list(self):
        from models.openai import AIInputLocation
        return [AIInputLocation.from_location(location) for location in self.data]


class Currency(BaseModel):
    currency: str = Field(..., description="ISO 4217 currency code")


class TripadvisorLocationDetailsRequest(TripadvisorRequest):
    currency: Currency


class DetailsRequest(BaseModel):
    location_id: str
    currency: Currency


# class Ancestor(BaseModel):
#     level: str
#     name: str
#     location_id: str


class LocationCategory(BaseModel):
    name: str


class LocationDetails(Location):
    description: Optional[str] = None
    # ancestors: List[Ancestor]
    latitude: float
    longitude: float
    category: LocationCategory
    subcategory: List[LocationCategory]
    safety_level: Optional[CountryAdvisories] = None
    photos: Optional[List[Image]] = None


class Photos(BaseModel):
    photos: List[Image] = Field(..., alias="data")

    @classmethod
    def from_response(cls, response: dict) -> "Photos":
        data = [Image.from_response(item) for item in response["data"]]
        return cls(data=data)


class ClimateMonth(BaseModel):
    tavg: Optional[float] = None
    tsun: Optional[int] = None

    class Config:
        from_attributes = True

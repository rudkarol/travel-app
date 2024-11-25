from pydantic import BaseModel, Field
from typing import Literal, List, Optional

from dependencies import get_settings
from schemas.risks import CountryAdvisories

settings = get_settings()


class DbPlace(BaseModel):
    location_id: str
    name: str


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


class TripadvisorRequest(BaseModel):
    key: str = settings.tripadvisor_api_key


class TripadvisorFindSearchRequest(TripadvisorRequest):
    query: str = Field(..., alias="searchQuery")
    category: Optional[Literal["hotels", "attractions", "restaurants", "geos"]] = None


class SearchRequest(BaseModel):
    query: str
    category: Optional[Literal["hotels", "attractions", "restaurants", "geos"]] = None


class SearchResponse(BaseModel):
    data: List[Location]


class TripadvisorLocationDetailsRequest(TripadvisorRequest):
    currency: str = Field(..., description="ISO 4217 currency code")


class DetailsRequest(BaseModel):
    location_id: str
    currency: str = Field(..., description="ISO 4217 currency code")


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
    #     TODO photos i inne pola


class Image(BaseModel):
    width: int
    height: int
    url: str

    @classmethod
    def from_response(cls, data: dict) -> "Image":
        return cls(
            width=data["images"]["large"]["width"],
            height=data["images"]["large"]["height"],
            url=data["images"]["large"]["url"]
        )


class Photos(BaseModel):
    photos: List[Image] = Field(..., alias="data")

    @classmethod
    def from_response(cls, response: dict) -> "Photos":
        data = [Image.from_response(item) for item in response["data"]]
        return cls(data=data)

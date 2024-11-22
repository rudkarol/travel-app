from pydantic import BaseModel, Field
from typing import Literal, List, Optional

from config import get_settings


settings = get_settings()


class DbPlace(BaseModel):
    location_id: str
    name: str


class AddressObj(BaseModel):
    # street1: Optional[str]
    # street2: Optional[str]
    # city: str
    # state: str
    country: str
    # postalcode: Optional[str]
    address_string: str


class Location(BaseModel):
    location_id: str
    name: str
    address_obj: AddressObj


class TripadvisorFindSearchRequest(BaseModel):
    key: str = settings.tripadvisor_api_key
    query: str = Field(..., alias="searchQuery")
    category: Optional[Literal["hotels", "attractions", "restaurants", "geos"]] = None


class SearchRequest(BaseModel):
    query: str
    category: Optional[Literal["hotels", "attractions", "restaurants", "geos"]] = None


class SearchResponse(BaseModel):
    data: List[Location]


class TripadvisorLocationDetailsRequest(BaseModel):
    key: str = settings.tripadvisor_api_key
    currency: str = Field(..., description="ISO 4217 currency code")


class DetailsRequest(BaseModel):
    location_id: str
    currency: str = Field(..., description="ISO 4217 currency code")


class Ancestor(BaseModel):
    level: str
    name: str
    location_id: str

class LocationDetails(Location):
    description: Optional[str] = None
    # ancestors: List[Ancestor]
    latitude: float
    longitude: float

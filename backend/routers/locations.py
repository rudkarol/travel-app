from fastapi import APIRouter, Query, Security
from typing import Annotated

from dependencies import get_database, get_token_verification
from models.risks import CountryAdvisories
from services.locations import fetch_tripadvisor_find_search, fetch_tripadvisor_location_details, fetch_tripadvisor_nearby_search, fetch_tripadvisor_location_photos
from models.locations import SearchRequest, DetailsRequest, LocationDetails, SearchResponse, NearbySearchRequest
from models.auth import TokenData

database = get_database()
router = APIRouter()
verify_user = get_token_verification()

@router.get("/locations/search/", response_model=SearchResponse)
async def search_locations(
        search_params: Annotated[SearchRequest, Query()],
        auth_result: Annotated[TokenData, Security(verify_user.verify)]
):
    """Endpoint do wyszukiwania lokacji"""

    locations = await fetch_tripadvisor_find_search(search_params)

    for location in locations.data:
        photos = await fetch_tripadvisor_location_photos(location.location_id)
        location.photos = photos.photos

    return locations

@router.get("/locations/nearby_search/", response_model=SearchResponse)
async def search_nearby_locations(
        search_params: Annotated[NearbySearchRequest, Query()],
        auth_result: Annotated[TokenData, Security(verify_user.verify)]
):
    """Endpoint do wyszukiwania lokacji w pobliżu danych koordynatów"""

    locations = await fetch_tripadvisor_nearby_search(search_params)

    for location in locations.data:
        photos = await fetch_tripadvisor_location_photos(location.location_id)
        location.photos = photos.photos

    return locations

@router.get("/location/", response_model=LocationDetails)
async def get_location_details(
        query_params: Annotated[DetailsRequest, Query()],
        auth_result: Annotated[TokenData, Security(verify_user.verify)]
):
    """Endpoint zwraca szczegoly lokalizacji,
    jesli jest to panstwo albo miasto, to zwraca dodatkowo
    poziom bezpieczenstwa, dane o klimacie, poziom cen
    lotow i zakwaterowania"""

    location_details = await fetch_tripadvisor_location_details(query_params)

    if location_details.category.name == "geographic":
        if location_details.address_obj.country:
            safety_level = await database.get_country_advisories(location_details.address_obj.country)
            safety_level = CountryAdvisories(**safety_level.model_dump())
        elif location_details.subcategory[0].name == "country":
            safety_level = await database.get_country_advisories(location_details.name)
            safety_level = CountryAdvisories(**safety_level.model_dump())
        else:
            safety_level = None

        location_details.safety_level = safety_level

    photos = await fetch_tripadvisor_location_photos(location_details.location_id)
    location_details.photos = photos.photos

    return location_details

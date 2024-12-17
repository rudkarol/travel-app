from fastapi import APIRouter, Query, Depends
from typing import Annotated

from dependencies import get_database, verify_token_and_user
from schemas.risks import CountryAdvisories
from services.locations import fetch_tripadvisor_find_search, fetch_tripadvisor_location_details
from schemas.locations import SearchRequest, DetailsRequest, LocationDetails, SearchResponse
from schemas.auth import User


database = get_database()
router = APIRouter()

@router.get("/locations/search/", response_model=SearchResponse)
async def search_locations(
        search_params: Annotated[SearchRequest, Query()],
        current_user: Annotated[User, Depends(verify_token_and_user)]
):
    """Endpoint do wyszukiwania lokacji"""

    locations = await fetch_tripadvisor_find_search(search_params)
    return locations

@router.get("/location/", response_model=LocationDetails)
async def get_location_details(
        query_params: Annotated[DetailsRequest, Query()],
        current_user: Annotated[User, Depends(verify_token_and_user)]
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

    return location_details

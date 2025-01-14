from fastapi import APIRouter, Query, Security
from typing import Annotated

from dependencies import get_database, get_token_verification
from schemas.risks import CountryAdvisories
from services.locations import fetch_tripadvisor_find_search, fetch_tripadvisor_location_details
from schemas.locations import SearchRequest, DetailsRequest, LocationDetails, SearchResponse
from schemas.auth import TokenData

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

    return location_details

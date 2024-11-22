from fastapi import APIRouter, Query
from typing import Annotated

from utils.locations import fetch_tripadvisor_find_search, fetch_tripadvisor_location_details
from models.locations import SearchRequest, DetailsRequest


router = APIRouter()

@router.get("/locations/search/")
async def search_locations(search_params: Annotated[SearchRequest, Query()]):
    """Endpoint do wyszukiwania lokacji"""

    locations = await fetch_tripadvisor_find_search(search_params)
    return locations

@router.get("/location/")
async def get_location_details(query_params: Annotated[DetailsRequest, Query()]):
    """Endpoint zwraca szczegoly lokalizacji,
    jesli jest to panstwo albo miasto, to zwraca dodatkowo
    poziom bezpieczenstwa, dane o klimacie, poziom cen
    lotow i zakwaterowania"""

    location_details = await fetch_tripadvisor_location_details(query_params)
    return location_details

from fastapi import APIRouter, Query
from typing import Annotated

from utils.locations import fetch_tripadvisor_find_search
from models.locations import SearchRequest


router = APIRouter()

@router.get("/locations/search/")
async def search_locations(search_params: Annotated[SearchRequest, Query()]):
    """Endpoint do wyszukiwania lokacji"""

    locations = await fetch_tripadvisor_find_search(search_params)
    return locations

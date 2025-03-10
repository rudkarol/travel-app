from fastapi import APIRouter, Query, Security
from typing import Annotated, List

from dependencies import get_token_verification
from services.locations import fetch_tripadvisor_find_search, fetch_tripadvisor_nearby_search, fetch_tripadvisor_location_photos, get_location_all_details
from models.locations import SearchRequest, DetailsRequest, LocationDetails, SearchResponse, NearbySearchRequest, Currency
from models.auth import TokenData


router = APIRouter()
verify_user = get_token_verification()


@router.get("/home/", response_model=List[LocationDetails])
async def get_recommended_locations(
        currency: Annotated[Currency, Query()],
        auth_result: Annotated[TokenData, Security(verify_user.verify)]
):
    """Endpoint do pobrania rekomendowanych lokalizacji"""

    RECOMMENDED_IDS = ["199909", "276740", "105127"]
    locations = []

    for location_id in RECOMMENDED_IDS:
        try:
            details = await get_location_all_details(
                DetailsRequest(location_id=location_id, currency=currency)
            )
            locations.append(details)
        except:
            pass

    return locations



@router.get("/locations/search/", response_model=List[LocationDetails])
async def search_locations(
        search_params: Annotated[SearchRequest, Query()],
        auth_result: Annotated[TokenData, Security(verify_user.verify)]
):
    """Endpoint do wyszukiwania lokacji"""

    locations = await fetch_tripadvisor_find_search(search_params)
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

    details = await get_location_all_details(query_params)
    return details

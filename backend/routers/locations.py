from fastapi import APIRouter, Query, Security
from typing import Annotated, List

from dependencies import get_token_verification
from services.locations import fetch_tripadvisor_find_search, get_location_all_details
from models.locations import SearchRequest, DetailsRequest, LocationDetails, Currency
from models.auth import TokenData


router = APIRouter()
verify_user = get_token_verification()


@router.get("/home", response_model=List[LocationDetails])
async def get_recommended_locations(
        currency: Annotated[Currency, Query()],
        auth_result: Annotated[TokenData, Security(verify_user.verify)]
):
    """Endpoint do pobrania rekomendowanych lokalizacji"""

    RECOMMENDED_IDS = ["294226", "187791", "187497", "293920", "187462", "187147", "304551"]
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


@router.get("/locations/search", response_model=List[LocationDetails])
async def search_locations(
        search_params: Annotated[SearchRequest, Query()],
        auth_result: Annotated[TokenData, Security(verify_user.verify)]
):
    """Endpoint do wyszukiwania lokacji"""

    locations = await fetch_tripadvisor_find_search(search_params)
    return locations

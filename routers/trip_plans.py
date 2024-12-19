from fastapi import APIRouter, Depends
from typing import Annotated, List, Optional
import math

from services.openai import openai_request
from services.locations import fetch_tripadvisor_nearby_search
from schemas.openai import GenerateTripPlanRequest, AIResponseFormat
from schemas.user import User
from schemas.trip_plans import Trip
from dependencies import verify_token_and_user, get_database


database = get_database()
router = APIRouter()

@router.post("/trip/generate")
async def generate_trip_plan(
        query_params: GenerateTripPlanRequest,
        current_user: Annotated[User, Depends(verify_token_and_user)]
) -> AIResponseFormat:
    """Endpoint do generowania kilkudniowego planu podróży.
    Dostępne generowanie planu dla 1 do 7 dni."""

    attractions=[]
    for day in range(math.ceil(query_params.days / 2)):
        a = await fetch_tripadvisor_nearby_search(lat=query_params.lat, lon=query_params.lon, category="attractions")
        a = a.to_ai_input_list()
        attractions.extend(a)

    restaurants=[]
    for day in range(math.ceil(query_params.days / 7)):
        r = await fetch_tripadvisor_nearby_search(lat=query_params.lat, lon=query_params.lon, category="restaurants")
        r = r.to_ai_input_list()
        restaurants.extend(r)

    trip_plan = await openai_request(attractions=attractions, restaurants=restaurants, days=query_params.days)
    return trip_plan


@router.get("/trip/plans")
async def get_current_user_trip_plans(
    current_user: Annotated[User, Depends(verify_token_and_user)]
) -> Optional[List[Trip]]:
    """Returns a list of the current user's trip plans"""

    return current_user.trips


@router.put("/trip/create")
async def create_users_trip_plan(
    trip_plan: Trip,
    current_user: Annotated[User, Depends(verify_token_and_user)]
):
    """Creates a new trip plan of the current user's"""

    new_user_data = User(**current_user.model_dump())
    if not new_user_data.trips:
        new_user_data.trips = [trip_plan]
    else:
        new_user_data.trips.append(trip_plan)
    await database.update_user(user=current_user, new_user_data=new_user_data)
    return {"message": "Trip plan created successfully"}

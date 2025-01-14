from fastapi import APIRouter, Security
from typing import Annotated, List, Optional
import math

from services.openai import openai_request
from services.locations import fetch_tripadvisor_nearby_search
from schemas.openai import GenerateTripPlanRequest, AIResponseFormat
from schemas.user import User
from schemas.trip_plans import Trip
from schemas.auth import TokenData
from dependencies import get_token_verification, get_database


database = get_database()
router = APIRouter()
verify_user = get_token_verification()


@router.post("/trip/generate")
async def generate_trip_plan(
        query_params: GenerateTripPlanRequest,
        auth_result: Annotated[TokenData, Security(verify_user.verify)]
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
    auth_result: Annotated[TokenData, Security(verify_user.verify)]
) -> Optional[List[Trip]]:
    """Returns a list of the current user's trip plans"""
    user = await database.get_user(auth_result.user_id)
    return user.trips


@router.put("/trip/create")
async def create_users_trip_plan(
    trip_plan: Trip,
    auth_result: Annotated[TokenData, Security(verify_user.verify)]
):
    """Creates a new trip plan of the current user's"""
    user = await database.get_user(auth_result.user_id)
    new_user_data = User(**user.model_dump())

    if not new_user_data.trips:
        new_user_data.trips = [trip_plan]
    else:
        new_user_data.trips.append(trip_plan)
    await database.update_user(user_id=auth_result.user_id, new_user_data=new_user_data)
    return {"message": "Trip plan created successfully"}

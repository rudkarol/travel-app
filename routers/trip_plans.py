from fastapi import APIRouter
# import math

from services.openai import openai_request
from services.locations import fetch_tripadvisor_nearby_search
from schemas.openai import GenerateTripPlanRequest, AIResponseFormat


router = APIRouter()

@router.post("/trip/generate")
async def generate_trip_plan(query_params: GenerateTripPlanRequest) -> AIResponseFormat:
    # for day in range(math.ceil(query_params.days / 5)):
    attractions = await fetch_tripadvisor_nearby_search(lat=query_params.lat, lon=query_params.lon, category="attractions")
    restaurants = await fetch_tripadvisor_nearby_search(lat=query_params.lat, lon=query_params.lon, category="restaurants")
    trip_plan = await openai_request(attractions=attractions.to_ai_input_list(), restaurants=restaurants.to_ai_input_list(), days=query_params.days)
    return trip_plan

from fastapi import APIRouter
import math

from services.openai import openai_request
from services.locations import fetch_tripadvisor_nearby_search
from schemas.openai import GenerateTripPlanRequest, AIResponseFormat


router = APIRouter()

@router.post("/trip/generate")
async def generate_trip_plan(query_params: GenerateTripPlanRequest) -> AIResponseFormat:
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

    print(len(attractions))
    print(len(restaurants))

    trip_plan = await openai_request(attractions=attractions, restaurants=restaurants, days=query_params.days)
    return trip_plan

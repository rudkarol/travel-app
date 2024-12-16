from fastapi import APIRouter

from services.openai import openai_request
from services.locations import fetch_tripadvisor_find_search
from schemas.openai import GenerateTripPlanRequest, AIResponseFormat
from schemas.locations import SearchRequest


router = APIRouter()

@router.post("/trip/generate")
async def generate_trip_plan(query_params: GenerateTripPlanRequest) -> AIResponseFormat:
    attractions = await fetch_tripadvisor_find_search(search_params=SearchRequest(query=query_params.location, category="attractions"))
    restaurants = await fetch_tripadvisor_find_search(search_params=SearchRequest(query=query_params.location, category="restaurants"))
    trip_plan = await openai_request(attractions=attractions.to_ai_input_list(), restaurants=restaurants.to_ai_input_list(), days=query_params.days)
    return trip_plan

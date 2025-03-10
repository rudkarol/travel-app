from fastapi import APIRouter, Security, Query
from typing import Annotated, List
import math

from services.openai import openai_request
from services.locations import fetch_tripadvisor_nearby_search, get_location_all_details
from models.openai import GenerateTripPlanRequest
from models.trip_plans import Trip, TripDay, TripResponse, TripDayResponse
from models.auth import TokenData
from models.locations import NearbySearchRequest, DetailsRequest, Currency
from dependencies import get_token_verification, get_database


database = get_database()
router = APIRouter()
verify_user = get_token_verification()


@router.post("/trip/generate")
async def generate_trip_plan(
        query_params: GenerateTripPlanRequest,
        auth_result: Annotated[TokenData, Security(verify_user.verify)]
) -> TripResponse:
    """Endpoint do generowania kilkudniowego planu podróży.
    Dostępne generowanie planu dla 1 do 7 dni.
    Zwraca wygenerowany plan i zapusuje go w bazie danych."""

    attractions=[]
    for day in range(math.ceil(query_params.days / 2)):
        a = await fetch_tripadvisor_nearby_search(NearbySearchRequest(lat=query_params.lat, lon=query_params.lon, category="attractions"))
        a = a.to_ai_input_list()
        attractions.extend(a)

    restaurants=[]
    for day in range(math.ceil(query_params.days / 7)):
        r = await fetch_tripadvisor_nearby_search(NearbySearchRequest(lat=query_params.lat, lon=query_params.lon, category="restaurants"))
        r = r.to_ai_input_list()
        restaurants.extend(r)

    trip_plan = await openai_request(attractions=attractions, restaurants=restaurants, days=query_params.days)

    trip_data = TripResponse(
        name=trip_plan.name,
        description=trip_plan.description,
        days=[]
    )

    trip_to_save = Trip(
        id=trip_data.id,
        name=trip_data.name,
        description=trip_data.description,
        days=[]
    )

    for trip_day in trip_plan.days:
        locations = TripDayResponse(places=[])
        locations_to_save = TripDay(places=[])

        for place in trip_day.places:
            locations_to_save.places.append(place.location_id)

            try:
                details = await get_location_all_details(
                    DetailsRequest(location_id=place.location_id, currency=Currency(currency=query_params.currency))
                )
                locations.places.append(details)
            except:
                pass

        trip_data.days.append(locations)
        trip_to_save.days.append(locations_to_save)

    await database.create_user_trip(auth_result.id, trip_to_save)

    return trip_data


@router.get("/trip/plans", response_model=List[TripResponse])
async def get_current_user_trip_plans(
    currency: Annotated[Currency, Query()],
    auth_result: Annotated[TokenData, Security(verify_user.verify)]
):
    """Zwraca listę planów podróży aktualnego użytkownika"""

    user = await database.get_user(auth_result.id)
    trips = []

    if user.trips:
        for trip_plan in user.trips:
            trip_data = TripResponse(
                id=trip_plan.id,
                name=trip_plan.name,
                description=trip_plan.description,
                start_date=trip_plan.start_date,
                days=[]
            )

            for trip_day in trip_plan.days:
                locations = TripDayResponse(places=[])

                for location_id in trip_day.places:
                    try:
                        details = await get_location_all_details(
                            DetailsRequest(location_id=location_id, currency=currency)
                        )
                        locations.places.append(details)
                    except:
                        pass

                trip_data.days.append(locations)

            trips.append(trip_data)

    return trips

@router.put("/trip/create")
async def create_new_trip_plan(
    trip_plan: Trip,
    auth_result: Annotated[TokenData, Security(verify_user.verify)]
):
    """Zapisuje nowy plan podróży aktualnego użytkownika"""

    await  database.create_user_trip(auth_result.id, trip_plan)
    return {"message": "Trip plan created successfully"}

@router.patch("/trip/update")
async def update_trip_plan(
    trip_plan: Trip,
    auth_result: Annotated[TokenData, Security(verify_user.verify)]
):
    """Aktualizuje plan podróży aktualnego użytkownika"""

    await database.update_trip(auth_result.id, trip_plan)
    return {"message": "Trip plan updated successfully"}

@router.delete("/trip/delete")
async def delete_current_user_trip_plan(
    trip_id: Annotated[str, Query()],
    auth_result: Annotated[TokenData, Security(verify_user.verify)]
):
    """Usuwa plan podróży o danym id z konta aktualnego użytkownika"""

    await database.remove_trip(auth_result.id, trip_id)
    return {"message": "Trip plan removed successfully"}

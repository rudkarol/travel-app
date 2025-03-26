import httpx
from datetime import datetime
from meteostat import Monthly, Point

import models.locations as lm
from dependencies import get_database
from models.locations import Currency
from models.risks import CountryAdvisories


database = get_database()


async def fetch_tripadvisor_find_search(search_params: lm.SearchRequest):
    url = "https://api.content.tripadvisor.com/api/v1/location/search"
    params = lm.TripadvisorRequest().model_dump()
    params.update(search_params)
    headers = {"accept": "application/json"}

    search_response = None

    async with httpx.AsyncClient() as client:
        r = await client.get(url, params=params, headers=headers)
        r.raise_for_status()
        search_response = lm.SearchResponse(**r.json())

    locations = []

    for location in search_response.data:
        try:
            details = await get_location_all_details(
                lm.DetailsRequest(location_id=location.location_id, currency=Currency(currency="usd"))
            )
            locations.append(details)
        except:
            pass

    return locations


async def fetch_tripadvisor_location_details(query_params: lm.DetailsRequest):
    url = f"https://api.content.tripadvisor.com/api/v1/location/{query_params.location_id}/details"
    params = lm.TripadvisorLocationDetailsRequest(currency=query_params.currency)
    headers = {"accept": "application/json"}

    try:
        async with httpx.AsyncClient() as client:
            r = await client.get(url, params=params.model_dump(), headers=headers)
            r.raise_for_status()
            return lm.LocationDetails(**r.json())
    except Exception as e:
        print(e)
        return


async def get_location_all_details(query_params: lm.DetailsRequest):
    try:
        location_details = await fetch_tripadvisor_location_details(query_params)
    except Exception as e:
        print(e)
        return

    try:
        # if location_details.category.name == "geographic":
        if location_details.address_obj.country:
            safety_level = await database.get_country_advisories(location_details.address_obj.country)
            safety_level = CountryAdvisories(**safety_level.model_dump())
        elif location_details.subcategory[0].name == "country":
            safety_level = await database.get_country_advisories(location_details.name)
            safety_level = CountryAdvisories(**safety_level.model_dump())

        location_details.safety_level = safety_level
    except Exception as e:
        print(e)

    photos = await fetch_tripadvisor_location_photos(location_details.location_id)
    location_details.photos = photos.photos

    try:
        climate = fetch_climate_data(location_details.latitude, location_details.longitude)
        location_details.climate = climate
    except Exception as e:
        print(e)

    return location_details


async def fetch_tripadvisor_location_photos(location_id: str):
    url = f"https://api.content.tripadvisor.com/api/v1/location/{location_id}/photos"
    params = lm.TripadvisorRequest()
    headers = {"accept": "application/json"}

    try:
        async with httpx.AsyncClient() as client:
            r = await client.get(url, params=params.model_dump(), headers=headers)
            r.raise_for_status()
            return lm.Photos.from_response(r.json())
    except:
        return None


async def fetch_tripadvisor_nearby_search(search_params: lm.NearbySearchRequest):
    url = "https://api.content.tripadvisor.com/api/v1/location/nearby_search"
    params = lm.TripadvisorRequest().model_dump()
    params.update({
        "latLong": str(search_params.lat) + "," + str(search_params.lon),
        "category": search_params.category
    })
    headers = {"accept": "application/json"}

    async with httpx.AsyncClient() as client:
        r = await client.get(url, params=params, headers=headers)
        r.raise_for_status()
        return lm.SearchResponse(**r.json())


def fetch_climate_data(lat: float, lon: float):
    year = datetime.now().year - 1
    start = datetime(year, 1, 1)
    end = datetime(year, 12, 31)
    location = Point(lat, lon)

    data = Monthly(location, start, end)
    data = data.fetch()
    data = data.reset_index()

    month_list = [lm.ClimateMonth.model_validate(row) for row in data.to_dict(orient="records")]
    return month_list

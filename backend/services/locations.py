import httpx
from datetime import datetime
from meteostat import Monthly, Point

import schemas.locations as lm


async def fetch_tripadvisor_find_search(search_params: lm.SearchRequest):
    url = "https://api.content.tripadvisor.com/api/v1/location/search"
    params = lm.TripadvisorFindSearchRequest(searchQuery=search_params.query, category=search_params.category)
    headers = {"accept": "application/json"}

    async with httpx.AsyncClient() as client:
        r = await client.get(url, params=params.model_dump(by_alias=True), headers=headers)
        r.raise_for_status()
        return lm.SearchResponse(**r.json())


async def fetch_tripadvisor_location_details(query_params: lm.DetailsRequest):
    url = f"https://api.content.tripadvisor.com/api/v1/location/{query_params.location_id}/details"
    params = lm.TripadvisorLocationDetailsRequest(currency=query_params.currency)
    headers = {"accept": "application/json"}

    async with httpx.AsyncClient() as client:
        r = await client.get(url, params=params.model_dump(), headers=headers)
        r.raise_for_status()
        return lm.LocationDetails(**r.json())


async def fetch_tripadvisor_location_photos(location_id: str):
    url = f"https://api.content.tripadvisor.com/api/v1/location/{location_id}/photos"
    params = lm.TripadvisorRequest()
    headers = {"accept": "application/json"}

    async with httpx.AsyncClient() as client:
        r = await client.get(url, params=params.model_dump(), headers=headers)
        r.raise_for_status()
        photos = lm.Photos.from_response(r.json())
        return photos.model_dump(by_alias=False)


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
    year = datetime.now().year
    year = year - 1
    start = datetime(year, 1, 1)
    end = datetime(year, 12, 31)
    location = Point(lat, lon)

    data = Monthly(location, start, end)
    data = data.fetch()

    month_list = [lm.ClimateMonth.model_validate(row) for row in data.to_dict(orient="records")]
    return month_list

import httpx

from models.locations import SearchRequest, TripadvisorFindSearchRequest, SearchResponse

async def fetch_tripadvisor_find_search(search_params: SearchRequest):
    url = "https://api.content.tripadvisor.com/api/v1/location/search"

    async with httpx.AsyncClient() as client:
        params = TripadvisorFindSearchRequest(searchQuery=search_params.query, category=search_params.category)
        headers = {"accept": "application/json"}
        r = await client.get(url, params=params.model_dump(by_alias=True), headers=headers)
        r.raise_for_status()
        return SearchResponse(**r.json())
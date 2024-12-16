from openai import OpenAI

from dependencies import get_settings
from schemas.openai import AIResponseFormat
from schemas.locations import SearchResponse


settings = get_settings()


def openai_request(places: list[SearchResponse], days: int) -> AIResponseFormat:
    # TODO: rozdzielić places na attractions i restaurants
    client = OpenAI(api_key=settings.openai_api_key)
    prompt = f"""
    You are a travel assistant tasked with creating a multi-day trip plan for a traveler. Here is a list of places they want to visit:
    {places}
    Create a {days}-day itinerary that groups places logically to minimize travel time and maximize the travel experience. 
    Distribute visits evenly across each day and suggest a lunch option for each day. 
    For each location, provide a short description of what the traveler will experience there, including key highlights or unique features. 
    If relevant, suggest the best time of day to visit specific locations.
    """

    completion = client.beta.chat.completions.parse (
        model="gpt-4o-mini",
        messages=[
            {
                "role": "system",
                "content": "You are a helpful travel assistant."
            },
            {
                "role": "user",
                "content": prompt
            }
        ],
        response_format=AIResponseFormat,
        temperature=0.7
    )

    r = completion.choices[0].message

    if r.refusal:
        raise Exception(r.refusal)

    return r.parsed

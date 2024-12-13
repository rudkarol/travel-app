from openai import OpenAI

from dependencies import get_settings
from schemas.locations import SearchResponse


settings = get_settings


def openai_request(places: SearchResponse):
    client = OpenAI(api_key=settings.openai_api_key)
    # TODO: prompt, response model
    prompt = ""

    r = client.chat.completions.create (
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
        temperature=0.7,
        max_tokens=254,
        top_p=1
    )
    # TODO: convert response to pydantic model
    return r.choices[0].message

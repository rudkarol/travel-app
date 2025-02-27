from fastapi import APIRouter
from fastapi.responses import RedirectResponse
from httpx import AsyncClient

from dependencies import get_settings

router = APIRouter()
settings = get_settings()

# Test Only
@router.get("/auth/login")
def login():
    return RedirectResponse(
        "https://dev-i0adeksdsq2nka6l.eu.auth0.com/authorize"
        "?response_type=code"
        "&client_id=qnXTziaZimSsP4kmSwfrEC1LXMR0bIxS"
        f"&redirect_uri=http://{settings.server_address}/auth/token"
        "&scope=offline_access"
        "&audience=https://travel-planner.com"
    )


# Test Only
@router.get("/auth/token")
async def get_access_token(code: str):
    payload = {
        "grant_type": "authorization_code",
        "client_id": "qnXTziaZimSsP4kmSwfrEC1LXMR0bIxS",
        "client_secret": "sbSHBeQjCFqsGyrQHHZANV4uV4JxsQegaTSFQTtjJBGNP7SFjM6N3ZSVCsB02I54",
        "code": code,
        "redirect_uri": f"http://{settings.server_address}/auth/token"
    }
    headers = {"content-type": "application/x-www-form-urlencoded"}

    async with AsyncClient() as client:
        response = await client.post("https://dev-i0adeksdsq2nka6l.eu.auth0.com/oauth/token", data=payload, headers=headers)

    return response.json()

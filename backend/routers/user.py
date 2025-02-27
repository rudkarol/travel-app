from fastapi import APIRouter, Security, Query, HTTPException
from typing import Annotated, List
import httpx
from pydantic import EmailStr

from dependencies import get_database, get_token_verification
from models.auth import TokenData
from models.locations import LocationDetails, Currency, DetailsRequest, settings
from services.locations import get_location_all_details
from services.auth import get_m2m_auth0_token


database = get_database()
router = APIRouter()
verify_user = get_token_verification()


@router.delete("/user/me/delete")
async def delete_current_user_account(
    auth_result: Annotated[TokenData, Security(verify_user.verify)]
):
    """Deletes current user"""

    try:
        m2m_token = await get_m2m_auth0_token()

        async with httpx.AsyncClient() as client:
            response = await client.delete(
                f"https://{settings.auth0_domain}/api/v2/users/{auth_result.id}",
                headers={
                    "Authorization": f"Bearer {m2m_token}",
                    "Content-Type": "application/json"
                }
            )

            if response.status_code != 204:
                raise HTTPException(
                    status_code=400,
                    detail=f"Unable to delete profile: {response.json().get('message', 'Unknown error')}"
                )

            await database.delete_user(auth_result.id)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.patch("/user/me/change-email")
async def update_current_user_email(
    new_email: EmailStr,
    auth_result: Annotated[TokenData, Security(verify_user.verify)]
):
    """Updates current user email and marks it as verified"""

    try:
        m2m_token = await get_m2m_auth0_token()

        async with httpx.AsyncClient() as client:
            response = await client.patch(
                f"https://{settings.auth0_domain}/api/v2/users/{auth_result.id}",
                headers = {
                    "Authorization": f"Bearer {m2m_token}",
                    "Content-Type": "application/json"
                },
                json = {
                    "email": new_email,
                    "email_verified": True
                }
            )

            if response.status_code != 200:
                raise HTTPException(
                    status_code=400,
                    detail=f"Unable to update profile: {response.json().get('message', 'Unknown error')}"
                )

            return response.json()
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/user/me/favorites", response_model=List[LocationDetails])
async def get_current_user_favorites(
    currency: Annotated[Currency, Query()],
    auth_result: Annotated[TokenData, Security(verify_user.verify)]
):
    """Returns current user favorite places list"""

    user = await database.get_user(auth_result.id)
    locations = []


    if user.favorite_places:
        for location_id in user.favorite_places:
            details = await get_location_all_details(
                DetailsRequest(location_id=location_id, currency=currency)
            )
            locations.append(details)

    return locations


@router.put("/user/me/favorites")
async def update_current_user_favorites(
    data: List[str],
    auth_result: Annotated[TokenData, Security(verify_user.verify)]
):
    """Updates current user favorite places list"""

    await database.update_user_favorites(user_id=auth_result.id, favorites_list=data)
    return {"message": "User's favorites list successfully updated"}

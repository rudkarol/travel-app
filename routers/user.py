from fastapi import APIRouter, Depends
from typing import Annotated
from pydantic import EmailStr

from dependencies import verify_token_and_user, get_database
from schemas.auth import Token
from schemas.user import User, UserDataUpdate
from services.auth import create_access_token, verify_db_code

database = get_database()
router = APIRouter()


@router.get("/user/me/", response_model=User)
async def read_users_me(
    current_user: Annotated[User, Depends(verify_token_and_user)]
):
    return current_user


@router.delete("/user/me/delete")
async def delete_current_user_account(
    verification_code: str,
    current_user: Annotated[User, Depends(verify_token_and_user)]
):
    """Deletes current user. Always get a verification code via /auth/request-code before request."""

    await verify_db_code(email=current_user.email, code_to_verify=verification_code)
    await database.delete_user(current_user.email)
    return {"message": "User deleted successfully"}


@router.patch("/user/me/update-email", response_model=Token)
async def update_current_user_email(
    new_email: EmailStr,
    verification_code: str,
    current_user: Annotated[User, Depends(verify_token_and_user)]
):
    """Updates current user email. Returns new access token.
    Always get a verification code via /auth/request-code before request."""

    await verify_db_code(email=current_user.email, code_to_verify=verification_code)
    new_user_data = User(**current_user.model_dump())
    new_user_data.email = new_email
    await database.update_user(user=current_user, new_user_data=new_user_data)
    access_token = create_access_token(new_email)
    return Token(access_token=access_token, token_type="bearer")


@router.patch("/user/me/update-data")
async def update_current_user_data(
    data: UserDataUpdate,
    current_user: Annotated[User, Depends(verify_token_and_user)]
):
    """Updates current user data (name and favourite places)"""

    await database.update_user(user=current_user, new_user_data=data)
    return {"message": "User data updated successfully"}

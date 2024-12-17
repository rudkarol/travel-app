from fastapi import APIRouter, Depends
from typing import Annotated
from pydantic import EmailStr

from dependencies import verify_token_and_user, get_database
from schemas.auth import User, Token
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
    return {"message": "User deleted succesfully"}


@router.patch("/user/me/update-email", response_model=Token)
async def update_current_user_email(
    new_email: EmailStr,
    verification_code: str,
    current_user: Annotated[User, Depends(verify_token_and_user)]
):
    """Updating current user email. Returns new access token.
    Always get a verification code via /auth/request-code before request."""

    await verify_db_code(email=current_user.email, code_to_verify=verification_code)
    await database.update_user_email(email=current_user.email, new_email=new_email)
    access_token = create_access_token(new_email)
    return Token(access_token=access_token, token_type="bearer")

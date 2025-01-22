from fastapi import APIRouter, Security, Depends
from typing import Annotated, List

from dependencies import get_database, get_token_verification
from models.auth import TokenData
from models.user import User, UserDataUpdate


database = get_database()
router = APIRouter()
verify_user = get_token_verification()


@router.get("/user/me/", response_model=User)
async def read_users_me(
    auth_result: Annotated[TokenData, Depends(verify_user.verify)]
):
    user = await database.get_user(auth_result.user_id)
    return user

# TODO: migrate to auth0
# @router.delete("/user/me/delete")
# async def delete_current_user_account(
#     verification_code: str,
#     current_user: Annotated[User, Depends(verify_token_and_user)]
# ):
#     """Deletes current user. Always get a verification code via /auth/request-code before request."""
#
#     await verify_db_code(email=current_user.email, code_to_verify=verification_code)
#     await database.delete_user(current_user.email)
#     return {"message": "User deleted successfully"}


# TODO: migrate to auth0 or delete
# @router.patch("/user/me/update-email", response_model=Token)
# async def update_current_user_email(
#     new_email: EmailStr,
#     verification_code: str,
#     current_user: Annotated[User, Depends(verify_token_and_user)]
# ):
#     """Updates current user email. Returns new access token.
#     Always get a verification code via /auth/request-code before request."""
#
#     await verify_db_code(email=current_user.email, code_to_verify=verification_code)
#     new_user_data = User(**current_user.model_dump())
#     new_user_data.email = new_email
#     await database.update_user(user=current_user, new_user_data=new_user_data)
#     access_token = create_access_token(new_email)
#     return Token(access_token=access_token, token_type="bearer")


# @router.patch("/user/me/update-data")
# async def update_current_user_data(
#     data: UserDataUpdate,
#     auth_result: Annotated[TokenData, Security(verify_user.verify)]
# ):
#     """Updates current user data (name and favorite places)"""
#
#     await database.update_user(user_id=auth_result.user_id, new_user_data=data)
#     return {"message": "User data updated successfully"}


@router.put("/user/me/favorites")
async def update_current_user_favorites(
    data: List[str],
    auth_result: Annotated[TokenData, Security(verify_user.verify)]
):
    """Updates current user favorite places list"""

    await database.update_user_favorites(user_id=auth_result.user_id, favorites_list=data)
    return {"message": "User's favorites list successfully updated"}

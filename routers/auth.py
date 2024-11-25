from fastapi import Depends, HTTPException, status, APIRouter, BackgroundTasks, Response
from datetime import datetime, timedelta
from typing import Annotated

from dependencies import get_settings, send_verification_email
from schemas.auth import CodeRequest, VerificationRequest, User, Token
from services.auth import generate_verification_code, verify_db_code, create_access_token, verify_token_and_user, \
    save_code, login_or_register

settings = get_settings()
router = APIRouter()


@router.post("/auth/request-code")
async def request_verification_code(
        email_request: CodeRequest,
        background_tasks: BackgroundTasks
):
    """Endpoint do pobrania kodu weryfikacyjnego"""

    code = generate_verification_code()
    expiry = datetime.now() + timedelta(minutes=settings.verification_code_expire_minutes)
    await save_code(email=email_request.email, code=code, expiry=expiry)

    background_tasks.add_task(send_verification_email, email_request.email, code)

    return {"message": "Verification code sent"}


@router.post("/auth/verify")
async def verify_code(verification_request: VerificationRequest, response: Response):
    """Endpoint do logowania - weryfikacja kodu i generowanie JWT"""

    verification_result = await verify_db_code(email=verification_request.email, code_to_verify=verification_request.code)
    if not verification_result:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or expired verification code"
        )

    is_login = await login_or_register(verification_request.email)
    if is_login:
        response.status_code = status.HTTP_200_OK
    else:
        response.status_code = status.HTTP_201_CREATED

    access_token = create_access_token(verification_request.email)
    return Token(access_token=access_token, token_type="bearer")


@router.get("/users/me/", response_model=User)
async def read_users_me(
        current_user: Annotated[User, Depends(verify_token_and_user)],
):
    return current_user

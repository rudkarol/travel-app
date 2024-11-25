from fastapi import Depends, HTTPException, status, APIRouter, BackgroundTasks
from datetime import datetime, timedelta
from typing import Annotated

from config import get_settings
from schemas.auth import EmailRequest, VerificationRequest, User, Token
from services.auth import generate_verification_code, send_verification_email, verify_db_code, create_access_token, get_current_user, save_code


settings = get_settings()
router = APIRouter()

@router.post("/auth/request-code")
async def request_verification_code(
        email_request: EmailRequest,
        background_tasks: BackgroundTasks
):
    """Endpoint do pobrania kodu weryfikacyjnego"""

    code = generate_verification_code()
    expiry = datetime.now() + timedelta(minutes=settings.verification_code_expire_minutes)
    await save_code(email=email_request.email, code=code, expiry=expiry)

    background_tasks.add_task(send_verification_email, email_request.email, code)

    return {"message": "Verification code sent"}

@router.post("/auth/verify")
async def verify_code(verification_request: VerificationRequest):
    """Endpoint do logowania - weryfikacji kodu i wygenerowania JWT"""

    verification_result = await verify_db_code(email=verification_request.email, code_to_verify=verification_request.code)

    if not verification_result :
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or expired verification code"
        )

    access_token = create_access_token(verification_request.email)
    return Token(access_token=access_token, token_type="bearer")

@router.get("/users/me/", response_model=User)
async def read_users_me(
    current_user: Annotated[User, Depends(get_current_user)],
):
    return current_user

from fastapi import APIRouter, BackgroundTasks
from datetime import datetime, timedelta

from dependencies import get_settings, send_verification_email
from schemas.auth import CodeRequest, VerificationRequest, Token
from services.auth import generate_verification_code, verify_db_code, create_access_token, save_code

settings = get_settings()
router = APIRouter()


@router.post("/auth/request-code")
async def request_verification_code(
        code_request: CodeRequest,
        background_tasks: BackgroundTasks
):
    """Endpoint do pobrania kodu weryfikacyjnego"""

    code = generate_verification_code()
    expiry = datetime.now() + timedelta(minutes=settings.verification_code_expire_minutes)
    await save_code(email=code_request.email, code=code, expiry=expiry)

    background_tasks.add_task(send_verification_email, code_request.email, code)

    return {"message": "Verification code sent"}


@router.post("/auth/login", response_model=Token)
async def login_or_register_new_account(verification_request: VerificationRequest):
    """Endpoint do logowania - weryfikacja kodu i generowanie JWT.
    Jeśli konto nie istnieje, to zostanie zarejestrowane"""

    await verify_db_code(email=verification_request.email, code_to_verify=verification_request.code)
    access_token = create_access_token(verification_request.email)
    return Token(access_token=access_token, token_type="bearer")

from fastapi import Depends, HTTPException, status, APIRouter, BackgroundTasks
from datetime import datetime, timedelta, timezone
from fastapi.security import HTTPBearer
from typing import Annotated
import jwt
from jwt.exceptions import InvalidTokenError
import string
import secrets

from .models import EmailRequest, VerificationRequest, User, Token, TokenData
from config import get_settings
from database import get_database


settings = get_settings()

SECRET_KEY = settings.jwt_secret_key
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30
VERIFICATION_CODE_LENGTH = 6
VERIFICATION_CODE_EXPIRE_MINUTES = 15

database = get_database()

security = HTTPBearer()

def generate_verification_code():
    """Generuje kod weryfikacyjny"""

    alphabet = string.ascii_uppercase + string.digits
    verification_code = ''.join(secrets.choice(alphabet) for _ in range(VERIFICATION_CODE_LENGTH))
    return verification_code

def create_access_token(email: str):
    """Tworzy JWT"""

    expire = datetime.now(timezone.utc) + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    to_encode = {"sub": email, "exp": expire}
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt

async def get_current_user(token: str = Depends(security)):
    """Weryfikuje JWT i zwraca użytkownika"""

    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )

    try:
        payload = jwt.decode(token.credentials, SECRET_KEY, algorithms=[ALGORITHM])
        email: str = payload.get("sub")
        print(f"user email: {email}")
        if email is None:
            raise credentials_exception
        token_data = TokenData(email=email)
    except InvalidTokenError:
        raise credentials_exception
    user = database.get_user(email=token_data.email)
    if user is None:
        raise credentials_exception
    return user

async def send_verification_email(email: str, code: str):
    """Wysyla email z kodem weryfikacyjnym"""

    # TODO: obsluga email
    print(f"Sending verification code {code} to {email}")

router = APIRouter()

@router.post("/auth/request-code")
async def request_verification_code(
        email_request: EmailRequest,
        background_tasks: BackgroundTasks
):
    """Endpoint do pobrania kodu weryfikacyjnego"""

    code = generate_verification_code()
    expiry = datetime.now(timezone.utc) + timedelta(minutes=VERIFICATION_CODE_EXPIRE_MINUTES)
    database.save_code(email=email_request.email, code=code, expiry=expiry)

    background_tasks.add_task(send_verification_email, email_request.email, code)

    return {"message": "Verification code sent"}

@router.post("/auth/verify")
async def verify_code(verification_request: VerificationRequest):
    """Endpoint do logowania - weryfikacji kodu i wygenerowania JWT"""

    if not database.verify_code(
            email=verification_request.email,
            code_to_verify=verification_request.code
    ):
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

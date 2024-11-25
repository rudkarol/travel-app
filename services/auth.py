from fastapi import Depends, HTTPException, status
from datetime import datetime, timedelta
from fastapi.security import HTTPBearer
from pydantic import EmailStr
import jwt
from jwt.exceptions import InvalidTokenError
import string
import secrets

from config import get_settings
from database import get_database
from schemas.auth import TokenData


settings = get_settings()
database = get_database()
security = HTTPBearer()

def generate_verification_code():
    """Generuje kod weryfikacyjny"""

    alphabet = string.ascii_uppercase + string.digits
    verification_code = ''.join(secrets.choice(alphabet) for _ in range(settings.verification_code_length))
    return verification_code

async def verify_db_code(email: EmailStr, code_to_verify: str):
    """Weryfikuje kod otrzymany od uzytkownika"""

    db_code = await database.get_code(email)

    if db_code.code == code_to_verify:
        if datetime.now() < db_code.expiry:
            return True

async def save_code(email: EmailStr, code: str, expiry: datetime):
    """Zapis kodu do bazy danych"""

    await database.save_code(email=email, code=code, expiry=expiry)

def create_access_token(email: EmailStr):
    """Tworzy JWT"""

    expire = datetime.now() + timedelta(minutes=settings.access_token_expire_minutes)
    to_encode = {"sub": email, "exp": expire}
    encoded_jwt = jwt.encode(to_encode, settings.jwt_secret_key, algorithm=settings.algorithm)
    return encoded_jwt

async def get_current_user(token: str = Depends(security)):
    """Weryfikuje JWT i zwraca użytkownika"""

    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )

    try:
        payload = jwt.decode(token.credentials, settings.jwt_secret_key, algorithms=[settings.algorithm])
        email: EmailStr = payload.get("sub")
        if email is None:
            raise credentials_exception
        token_data = TokenData(email=email)
    except InvalidTokenError:
        raise credentials_exception
    user = await database.get_user(email=token_data.email)
    if user is None:
        raise credentials_exception
    return user

async def send_verification_email(email: EmailStr, code: str):
    """Wysyla email z kodem weryfikacyjnym"""

    # TODO: obsluga email
    print(f"Sending verification code {code} to {email}")

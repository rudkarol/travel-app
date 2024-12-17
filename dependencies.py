from functools import lru_cache

import jwt
from fastapi import Depends, HTTPException
from jwt import InvalidTokenError
from pydantic import EmailStr
from starlette import status

from config import Settings


@lru_cache
def get_settings():
    return Settings()


from database import Database


@lru_cache
def get_database():
    return Database()


async def send_verification_email(email: EmailStr, code: str):
    """Wysyla email z kodem weryfikacyjnym"""

    # TODO: obsluga email
    print(f"Sending verification code {code} to {email}")


from schemas.auth import TokenData
from services.auth import security, settings, database


async def verify_token_and_user(token: str = Depends(security)):
    """Weryfikuje JWT i sprawdza czy użytkownik jest zarejestrowany w bazie danych"""

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
    user = await database.get_user(token_data.email)
    if user is None:
        raise credentials_exception
    return user

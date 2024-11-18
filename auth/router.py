from fastapi import Depends, HTTPException, status
from datetime import datetime, timedelta, timezone
from fastapi.security import HTTPBearer
from typing import Annotated
import jwt
from jwt.exceptions import InvalidTokenError
import string
import secrets

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


async def get_current_user(token: Annotated[str, Depends(security)]):
    """Weryfikuje JWT i zwraca użytkownika"""

    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )

    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username: str = payload.get("sub")
        if username is None:
            raise credentials_exception
        return username
    except InvalidTokenError:
        raise credentials_exception


async def send_verification_email(email: str, code: str):
    """Wysyla email z kodem weryfikacyjnym"""

    # TODO: obsluga email
    print(f"Sending verification code {code} to {email}")


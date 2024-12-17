from datetime import datetime, timedelta
from fastapi.security import HTTPBearer
from pydantic import EmailStr
import jwt
import string
import secrets

from dependencies import get_database, get_settings

settings = get_settings()
database = get_database()
security = HTTPBearer()


def generate_verification_code():
    alphabet = string.ascii_uppercase + string.digits
    verification_code = ''.join(secrets.choice(alphabet) for _ in range(settings.verification_code_length))
    return verification_code


async def verify_db_code(email: EmailStr, code_to_verify: str):
    code_data = await database.get_code(email)

    if not code_data:
        return False

    if code_data.code == code_to_verify:
        if datetime.now() < code_data.expiry:
            await database.delete_code(code_data)

            db_user = await database.get_user(email)
            if not db_user:
                # Rejestracja nowego użytkownika - jeśli nie istnieje w bazie danych
                await database.create_user(email)
            return True


async def save_code(email: EmailStr, code: str, expiry: datetime):
    await database.save_code(email=email, code=code, expiry=expiry)


def create_access_token(email: EmailStr):
    expire = datetime.now() + timedelta(days=settings.access_token_expire_minutes)
    to_encode = {"sub": email, "exp": expire}
    encoded_jwt = jwt.encode(to_encode, settings.jwt_secret_key, algorithm=settings.algorithm)
    return encoded_jwt

from functools import lru_cache
from pydantic import EmailStr

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

from functools import lru_cache
from config import Settings

@lru_cache
def get_settings():
    return Settings()


from database import Database

@lru_cache
def get_database():
    return Database()


from services.auth import VerifyToken

@lru_cache
def get_token_verification():
    return VerifyToken()

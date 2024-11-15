from pydantic_settings import BaseSettings, SettingsConfigDict
from functools import lru_cache
from pathlib import Path


class Settings(BaseSettings):
    app_name: str
    admin_email: str

    model_config = SettingsConfigDict(env_file=Path(__file__).parent / ".env", env_file_encoding='utf-8')

@lru_cache
def get_settings():
    return Settings()
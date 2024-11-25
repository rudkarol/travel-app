from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    app_name: str
    admin_email: str

    # auth
    jwt_secret_key: str
    algorithm: str = "HS256"
    access_token_expire_minutes: int = 30
    verification_code_length: int = 6
    verification_code_expire_minutes: int = 15

    tripadvisor_api_key: str

    model_config = SettingsConfigDict(env_file=".env", env_file_encoding='utf-8')

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    app_name: str
    admin_email: str

    mongo_uri: str

    # auth0
    auth0_domain: str
    auth0_api_audience: str
    auth0_issuer: str
    auth0_algorithms: str

    tripadvisor_api_key: str
    openai_api_key: str

    model_config = SettingsConfigDict(env_file=".env", env_file_encoding='utf-8')

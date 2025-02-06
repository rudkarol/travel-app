import jwt
from fastapi import HTTPException, status, Depends
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from typing import Optional
from auth0.authentication import GetToken

from dependencies import get_settings
from models.auth import TokenData


settings = get_settings()
security = HTTPBearer()


class UnauthorizedException(HTTPException):
    def __init__(self, detail: str):
        super().__init__(
            status.HTTP_403_FORBIDDEN,
            detail=detail
        )


class UnauthenticatedException(HTTPException):
    def __init__(self):
        super().__init__(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Could not validate credentials",
            headers={"WWW-Authenticate": "Bearer"},
        )


class VerifyToken:
    """Auth0 token verification"""

    def __init__(self):
        jwks_url = f"https://{settings.auth0_domain}/.well-known/jwks.json"
        self.jwks_client = jwt.PyJWKClient(jwks_url)

    async def verify(self, token: Optional[HTTPAuthorizationCredentials] = Depends(security)):
        if token is None:
            raise UnauthenticatedException

        # Get 'kid' from token
        try:
            signing_key = self.jwks_client.get_signing_key_from_jwt(token.credentials).key
        except jwt.exceptions.PyJWKClientError as error:
            raise UnauthorizedException(str(error))
        except jwt.exceptions.DecodeError as error:
            raise UnauthorizedException(str(error))

        try:
            payload = jwt.decode(
                token.credentials,
                signing_key,
                algorithms=settings.auth0_algorithms,
                audience=settings.auth0_api_audience,
                issuer=settings.auth0_issuer,
            )
        except Exception as error:
            raise UnauthorizedException(str(error))

        return TokenData(**payload)


async def get_m2m_auth0_token():
    try:
        get_token = GetToken(settings.auth0_domain, settings.auth0_m2m_client_id, client_secret=settings.auth0_m2m_client_secret)
        token = get_token.client_credentials(settings.auth0_management_api_audience)

        return token['access_token']
    except Exception as e:
        raise HTTPException(status_code=500, detail="Unable to obtain Auth0 M2M token")

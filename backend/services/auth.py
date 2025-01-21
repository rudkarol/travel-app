import jwt
from fastapi import HTTPException, status, Depends
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from typing import Optional

from dependencies import get_settings
from models.auth import TokenData


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
        self.settings = get_settings()

        jwks_url = f"https://{self.settings.auth0_domain}/.well-known/jwks.json"
        self.jwks_client = jwt.PyJWKClient(jwks_url)

    async def verify(self, token: Optional[HTTPAuthorizationCredentials] = Depends(security)):
        if token is None:
            raise UnauthenticatedException

        # This gets the 'kid' from the passed token
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
                algorithms=self.settings.auth0_algorithms,
                audience=self.settings.auth0_api_audience,
                issuer=self.settings.auth0_issuer,
            )
        except Exception as error:
            raise UnauthorizedException(str(error))

        return TokenData(**payload)
from pydantic import BaseModel, EmailStr
from odmantic import Model
from typing import List, Optional
from datetime import datetime

from schemas.locations import DbPlace


class CodeRequest(BaseModel):
    email: EmailStr


class VerificationRequest(BaseModel):
    email: EmailStr
    code: str


class Token(BaseModel):
    access_token: str
    token_type: str


class TokenData(BaseModel):
    email: Optional[EmailStr] = None


class DbUser(Model):
    email: EmailStr
    name: Optional[str] = None
    favourite_places: Optional[List[DbPlace]] = None


class User(BaseModel):
    email: EmailStr
    name: Optional[str] = None
    favourite_places: Optional[List[DbPlace]] = None
#     TODO change DbPlace to Place


class Otp(Model):
    """OTP - (one-time password) klasa kodu weryfikacyjnego"""
    email: EmailStr
    code: str
    expiry: datetime

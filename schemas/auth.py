from pydantic import BaseModel, EmailStr
from odmantic import Model
from typing import Optional
from datetime import datetime


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


class Otp(Model):
    """OTP - (one-time password) klasa kodu weryfikacyjnego"""
    email: EmailStr
    code: str
    expiry: datetime

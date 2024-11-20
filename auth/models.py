from pydantic import BaseModel, EmailStr
from odmantic import Model
from typing import List, Optional
from uuid import UUID
from datetime import datetime


class EmailRequest(BaseModel):
    email: EmailStr

class VerificationRequest(BaseModel):
    email: EmailStr
    code: str

class Token(BaseModel):
    access_token: str
    token_type: str

class TokenData(BaseModel):
    email: Optional[EmailStr] = None

class Place(BaseModel):
    place_id: UUID
    name: str

class User(Model):
    email: EmailStr
    name: Optional[str] = None
    favourite_places: Optional[List[Place]] = None

class Otp(Model):
    """OTP - (one-time password) klasa kodu weryfikacyjnego"""
    email: EmailStr
    code: str
    expiry: datetime

from typing import Optional, List
from odmantic import Model
from pydantic import BaseModel, EmailStr

from schemas.locations import Place


class User(BaseModel):
    email: EmailStr
    name: Optional[str] = None
    favourite_places: Optional[List[Place]] = None


class DbUser(Model):
    email: EmailStr
    name: Optional[str] = None
    favourite_places: Optional[List[Place]] = None

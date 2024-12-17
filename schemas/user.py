from typing import Optional, List
from odmantic import Model
from pydantic import BaseModel, EmailStr

from schemas.locations import DbPlace


class User(BaseModel):
    email: EmailStr
    name: Optional[str] = None
    favourite_places: Optional[List[DbPlace]] = None
    #TODO: change DbPlace to Place


class DbUser(Model):
    email: EmailStr
    name: Optional[str] = None
    favourite_places: Optional[List[DbPlace]] = None

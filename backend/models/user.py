from typing import Optional, List
from odmantic import Model
from pydantic import BaseModel, EmailStr

from models.trip_plans import Trip


class User(BaseModel):
    user_id: str
    email: str
    favorite_places: Optional[List[str]] = None
    trips: Optional[List[Trip]] = None


class DbUser(Model):
    user_id: str
    email: str
    favorite_places: Optional[List[str]] = None
    trips: Optional[List[Trip]] = None


class UserDataUpdate(BaseModel):
    favorite_places: Optional[List[str]] = None
    trips: Optional[List[Trip]] = None

from typing import Optional, List
from odmantic import Model
from odmantic.bson import BaseBSONModel, ObjectId

from models.trip_plans import Trip


class User(BaseBSONModel):
    id: ObjectId
    favorite_places: Optional[List[str]] = None
    trips: Optional[List[Trip]] = None


class DbUser(Model):
    favorite_places: Optional[List[str]] = None
    trips: Optional[List[Trip]] = None

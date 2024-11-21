from pydantic import BaseModel
from odmantic import Model
from datetime import datetime


class CountryItem(BaseModel):
    country: str
    level: int
    pub_date: datetime
    link: str

class CountryAdvisories(Model):
    country: str
    level: int
    pub_date: datetime
    link: str

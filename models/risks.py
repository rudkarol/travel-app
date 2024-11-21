from pydantic import BaseModel, Field, HttpUrl, field_validator
from odmantic import Model
from datetime import datetime

class CountryItem(BaseModel):
    country: str
    level: int
    pub_date: datetime = Field(alias="pubDate")
    link: HttpUrl

    @field_validator("country", "level")
    def extract_components(self, v, values):
        # przykladowy tytul:
        # Poland - Level 1: Exercise Normal Precautions

        parts = values["title"].split(" - Level ")
        values["country"] = parts[0]
        level_parts = parts[1].split(": ")
        values["level"] = level_parts[0]
        return v

class Country(Model):
    country: str
    level: int
    pub_date: datetime
    link: HttpUrl

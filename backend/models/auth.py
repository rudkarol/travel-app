from pydantic import BaseModel, Field, field_validator
from odmantic.bson import BaseBSONModel, ObjectId


class Token(BaseModel):
    access_token: str
    token_type: str


class TokenData(BaseBSONModel):
    id: ObjectId = Field(..., alias="sub")

    @field_validator("id", mode="before")
    def remove_prefix(cls, value: str) -> ObjectId:
        return ObjectId(value.split("|")[-1])

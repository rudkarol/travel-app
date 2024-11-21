from datetime import datetime
from functools import lru_cache
from odmantic import AIOEngine
from pydantic import EmailStr

from models.auth import User, Otp
from models.risks import CountryAdvisories, CountryItem

class Database:
    def __init__(self):
        self.engine = AIOEngine(database="travelDB")

    async def get_code(self, email: EmailStr):
        code_data = await self.engine.find_one(Otp, Otp.email == email)
        return code_data

    async def save_code(self, email: EmailStr, code: str, expiry: datetime):
        code_data = await self.get_code(email)
        if not code_data:
            code_data = Otp(email=email, code=code, expiry=expiry)
        code_data.code = code
        code_data.expiry = expiry
        await self.engine.save(code_data)

    async def get_user(self, email: EmailStr):
        user_data = await self.engine.find_one(User, User.email == email)
        return user_data

    async def update_country_advisories(self, country_to_update: CountryItem):
        country_data = await self.engine.find_one(CountryAdvisories, CountryAdvisories.country == country_to_update.country)
        country_data.model_update(country_to_update)
        await self.engine.save(country_data)

@lru_cache
def get_database():
    return Database()

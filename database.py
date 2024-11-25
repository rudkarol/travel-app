from datetime import datetime
from odmantic import AIOEngine
from pydantic import EmailStr

from schemas.auth import DbUser, Otp
from schemas.risks import DbCountryAdvisories, CountryItem


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
        else:
            code_data.code = code
            code_data.expiry = expiry
        await self.engine.save(code_data)

    async def delete_code(self, code_data: Otp):
        await self.engine.delete(code_data)

    async def get_user(self, email: EmailStr):
        user_data = await self.engine.find_one(DbUser, DbUser.email == email)
        return user_data

    async def create_user(self, email: EmailStr):
        new_user = DbUser(email=email)
        await self.engine.save(new_user)

    async def delete_user(self, email: EmailStr):
        await self.engine.remove(DbUser, DbUser.email == email)

    async def get_country_advisories(self, country_name: str):
        country_data = await self.engine.find_one(DbCountryAdvisories, DbCountryAdvisories.country == country_name)
        return country_data

    async def update_country_advisories(self, country_to_update: CountryItem):
        country_data = await self.get_country_advisories(country_to_update.country)
        if not country_data:
            country_data = DbCountryAdvisories(**country_to_update.model_dump())
        else:
            country_data.model_update(country_to_update)
        await self.engine.save(country_data)

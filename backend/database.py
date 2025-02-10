from odmantic import AIOEngine
from odmantic.engine import AsyncIOMotorClient
from typing import List

from models.user import DbUser, User
from models.risks import DbCountryAdvisories, CountryItem
from dependencies import get_settings

settings = get_settings()


class Database:
    def __init__(self):
        self.engine = AIOEngine(
            client=AsyncIOMotorClient(settings.mongo_uri),
            database="travel_app"
        )

    async def get_user(self, user_id: str):
        user_data = await self.engine.find_one(DbUser, DbUser.user_id == user_id)
        return user_data

    async def delete_user(self, user_id: str):
        await self.engine.remove(DbUser, DbUser.user_id == user_id)

    async def update_user(self, user_id: str, new_user_data: User):
        user_data = await self.get_user(user_id)
        user_data.model_update(new_user_data)
        await self.engine.save(user_data)

    async def update_user_favorites(self, user_id: str, favorites_list: List[str]):
        user_data = await self.get_user(user_id)
        user_data.favorite_places = favorites_list
        await self.engine.save(user_data)

    async def remove_trip(self, user_id: str, trip_id: str):
        user = await self.get_user(user_id)
        if not user:
            print("no user")
            return

        if not user.trips:
            print("no trips")
            return

        original_len = len(user.trips)
        user.trips = [trip for trip in user.trips if trip.id.lower() != trip_id.lower()]

        if len(user.trips) == original_len:
            print("same len")
            return

        await self.engine.save(user)

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

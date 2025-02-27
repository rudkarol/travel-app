from odmantic import AIOEngine
from odmantic.engine import AsyncIOMotorClient
from odmantic.bson import ObjectId
from typing import List

from models.trip_plans import Trip
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

    async def get_user(self, user_id: ObjectId):
        user_data = await self.engine.find_one(DbUser, DbUser.id == user_id)
        return user_data

    async def delete_user(self, user_id: ObjectId):
        await self.engine.remove(DbUser, DbUser.id == user_id)

    async def update_user(self, user_id: ObjectId, new_user_data: User):
        user_data = await self.get_user(user_id)
        user_data.model_update(new_user_data)
        await self.engine.save(user_data)

    async def update_user_favorites(self, user_id: ObjectId, favorites_list: List[str]):
        user_data = await self.get_user(user_id)
        user_data.favorite_places = favorites_list
        await self.engine.save(user_data)

    async def update_trip(self, user_id: ObjectId, trip_update: Trip):
        user = await self.get_user(user_id)

        if not user or not user.trips:
            return

        for index, trip in enumerate(user.trips):
            if trip.id.lower() == trip_update.id.lower():
                trip_data = trip.model_dump()
                new_data = trip_update.model_dump()
                trip_data.update(new_data)
                updated_trip = Trip.model_validate(trip_data)

                user.trips[index] = updated_trip
                await self.engine.save(user)
                return

    async def remove_trip(self, user_id: ObjectId, trip_id: str):
        user = await self.get_user(user_id)

        if not user or not user.trips:
            return

        original_len = len(user.trips)
        user.trips = [trip for trip in user.trips if trip.id.lower() != trip_id.lower()]

        if len(user.trips) == original_len:
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

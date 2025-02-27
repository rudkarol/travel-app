from dependencies import get_database
from models.trip_plans import Trip
from models.user import User
from bson import ObjectId

database = get_database()


async def create_trip_plan(user_id: ObjectId, plan: Trip):
    user = await database.get_user(user_id)
    new_user_data = User(**user.model_dump())

    if not new_user_data.trips:
        new_user_data.trips = [plan]
    else:
        new_user_data.trips.append(plan)

    await database.update_user(user_id=user_id, new_user_data=new_user_data)

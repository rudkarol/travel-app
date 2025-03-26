from fastapi import Depends, FastAPI
from typing_extensions import Annotated
from apscheduler.schedulers.asyncio import AsyncIOScheduler
from contextlib import asynccontextmanager

from services.risks import update_risks
from routers import auth as auth_router
from routers import locations, trip_plans, user


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Uruchomienie przy starcie aplikacji update'u i schedulera,
    ktory co 24h aktualizuje baze danych zawierajaca
    informacje o pozimie bezpieczenstwa w krajach.
    Wylaczenie schedulera przy zamykaniu aplikacji"""

    await update_risks()
    scheduler = AsyncIOScheduler()
    scheduler.add_job(update_risks, 'interval', hours=24)
    scheduler.start()
    yield
    scheduler.shutdown()

app = FastAPI(lifespan=lifespan)
app.include_router(auth_router.router)
app.include_router(locations.router)
app.include_router(trip_plans.router)
app.include_router(user.router)

from config import Settings
from dependencies import get_settings
@app.get("/info")
async def info(settings: Annotated[Settings, Depends(get_settings)]):
    return {
        "app_name": settings.app_name
    }

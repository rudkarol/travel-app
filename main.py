from fastapi import Depends, FastAPI
from typing_extensions import Annotated

from config import Settings, get_settings
from routers import auth as auth_router

app = FastAPI()

app.include_router(auth_router.router)

@app.get("/info")
async def info(settings: Annotated[Settings, Depends(get_settings)]):
    return {
        "app_name": settings.app_name,
        "admin_email": settings.admin_email
    }


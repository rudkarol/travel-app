from fastapi import Depends, FastAPI
from typing_extensions import Annotated

from config.config import Settings, get_settings

app = FastAPI()

@app.get("/info")
async def info(settings: Annotated[Settings, Depends(get_settings)]):
    return {
        "app_name": settings.app_name,
        "admin_email": settings.admin_email
    }

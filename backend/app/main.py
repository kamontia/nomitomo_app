from fastapi import FastAPI
from mangum import Mangum
from app.presentation import auth_router, user_router, chat_router, shop_router
from app.infrastructure.database import engine, Base

app = FastAPI(title="Nomitomo API", version="0.1.0")

app.include_router(auth_router.router)
app.include_router(user_router.router)
app.include_router(chat_router.router)
app.include_router(shop_router.router)

@app.get("/health")
def health_check():
    return {"status": "ok"}

# Lambda Handler
handler = Mangum(app)

# Database Table Creation (For MVP/Dev only - use Alembic in prod)
@app.on_event("startup")
async def startup():
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)

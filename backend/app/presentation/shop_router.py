from typing import Annotated
from fastapi import APIRouter, Depends
from pydantic import BaseModel

from app.domain.shop import ShopPost
from app.domain.user import User
from app.dependencies import get_current_user, get_shop_repository
from app.infrastructure.shop_repository import ShopRepository
from app.application.shop_usecase import ShopUseCase

router = APIRouter(prefix="/shops", tags=["Shops"])

class CreateShopPostRequest(BaseModel):
    shop_name: str
    comment: str | None = None

@router.post("/posts", response_model=ShopPost)
async def create_post(
    request: CreateShopPostRequest,
    current_user: Annotated[User, Depends(get_current_user)],
    shop_repo: Annotated[ShopRepository, Depends(get_shop_repository)]
):
    usecase = ShopUseCase(shop_repo)
    return await usecase.create_post(current_user.id, request.shop_name, request.comment)

@router.get("/", response_model=list[ShopPost])
async def list_posts(
    current_user: Annotated[User, Depends(get_current_user)],
    shop_repo: Annotated[ShopRepository, Depends(get_shop_repository)]
):
    usecase = ShopUseCase(shop_repo)
    return await usecase.list_public_posts()

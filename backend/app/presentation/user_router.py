from typing import Annotated
from fastapi import APIRouter, Depends
from pydantic import BaseModel

from app.domain.user import User
from app.dependencies import get_current_user, get_user_repository
from app.infrastructure.user_repository import UserRepository
from app.application.toggle_recruiting_usecase import ToggleRecruitingUseCase
from app.application.list_recruiting_users_usecase import ListRecruitingUsersUseCase

router = APIRouter(prefix="/users", tags=["Users"])

class UpdateStatusRequest(BaseModel):
    is_recruiting: bool

@router.post("/me/status")
async def update_status(
    request: UpdateStatusRequest,
    current_user: Annotated[User, Depends(get_current_user)],
    user_repo: Annotated[UserRepository, Depends(get_user_repository)]
) -> User:
    usecase = ToggleRecruitingUseCase(user_repo)
    return await usecase.execute(current_user.id, request.is_recruiting)

@router.get("/recruiting")
async def list_recruiting(
    current_user: Annotated[User, Depends(get_current_user)],
    user_repo: Annotated[UserRepository, Depends(get_user_repository)]
) -> list[User]:
    usecase = ListRecruitingUsersUseCase(user_repo)
    return await usecase.execute()

from typing import Annotated

from fastapi import Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.infrastructure.database import get_db
from app.infrastructure.user_repository import UserRepository
from app.infrastructure.chat_repository import ChatRepository
from app.infrastructure.shop_repository import ShopRepository
from app.application.register_user_usecase import RegisterUserUseCase
from app.infrastructure.database import get_db

async def get_user_repository(session: Annotated[AsyncSession, Depends(get_db)]) -> UserRepository:
    return UserRepository(session)

async def get_chat_repository(session: Annotated[AsyncSession, Depends(get_db)]) -> ChatRepository:
    return ChatRepository(session)

async def get_shop_repository(session: Annotated[AsyncSession, Depends(get_db)]) -> ShopRepository:
    return ShopRepository(session)

# Use Cases
async def get_register_user_usecase(
    user_repo: Annotated[UserRepository, Depends(get_user_repository)]
) -> RegisterUserUseCase:
    return RegisterUserUseCase(user_repo)




# Security
from fastapi.security import OAuth2PasswordBearer
from jose import JWTError, jwt
from fastapi import HTTPException, status
from app.core.config import settings
from app.domain.user import User

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="auth/login")

async def get_current_user(
    token: Annotated[str, Depends(oauth2_scheme)],
    user_repo: Annotated[UserRepository, Depends(get_user_repository)]
) -> User:
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, settings.SECRET_KEY, algorithms=[settings.ALGORITHM])
        user_id: str | None = payload.get("sub")
        if user_id is None:
            raise credentials_exception
    except JWTError:
        raise credentials_exception
    
    # Check if user_id is valid UUID
    try:
        from uuid import UUID
        uuid_obj = UUID(user_id)
    except ValueError:
        raise credentials_exception

    user = await user_repo.get_by_id(uuid_obj)
    if user is None:
        raise credentials_exception
    return user

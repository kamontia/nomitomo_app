from uuid import UUID

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.domain.user import User
from app.infrastructure.models import UserModel

class UserRepository:
    def __init__(self, session: AsyncSession):
        self.session = session

    async def create(self, user: User) -> User:
        user_model = UserModel(
            id=user.id,
            line_user_id=user.line_user_id,
            firebase_uid=user.firebase_uid,
            display_name=user.display_name,
            avatar_url=user.avatar_url,
            bio=user.bio,
            is_recruiting=user.is_recruiting,
            created_at=user.created_at,
            updated_at=user.updated_at,
        )
        self.session.add(user_model)
        await self.session.flush()
        return user

    async def get_by_id(self, user_id: UUID) -> User | None:
        result = await self.session.execute(select(UserModel).where(UserModel.id == user_id))
        model = result.scalars().first()
        if model:
            return User.model_validate(model)
        return None

    async def update(self, user: User) -> User:
        user_model = await self.session.get(UserModel, user.id)
        if user_model:
            user_model.display_name = user.display_name
            user_model.bio = user.bio
            user_model.avatar_url = user.avatar_url
            user_model.is_recruiting = user.is_recruiting
            user_model.updated_at = user.updated_at
            await self.session.flush()
        return user

    async def list_recruiting(self) -> list[User]:
        stmt = select(UserModel).where(UserModel.is_recruiting == True)
        result = await self.session.execute(stmt)
        models = result.scalars().all()
        return [User.model_validate(model) for model in models]

    async def get_by_line_id(self, line_user_id: str) -> User | None:
        result = await self.session.execute(select(UserModel).where(UserModel.line_user_id == line_user_id))
        model = result.scalars().first()
        if model:
            return User.model_validate(model)
        return None

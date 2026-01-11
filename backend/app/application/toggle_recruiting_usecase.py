from uuid import UUID
from app.domain.user import User
from app.infrastructure.user_repository import UserRepository

class ToggleRecruitingUseCase:
    def __init__(self, user_repo: UserRepository):
        self.user_repo = user_repo

    async def execute(self, user_id: UUID, is_recruiting: bool) -> User:
        user = await self.user_repo.get_by_id(user_id)
        if not user:
            raise ValueError("User not found")
        
        user.is_recruiting = is_recruiting
        return await self.user_repo.update(user)

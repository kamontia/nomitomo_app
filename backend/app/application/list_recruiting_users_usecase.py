from app.domain.user import User
from app.infrastructure.user_repository import UserRepository

class ListRecruitingUsersUseCase:
    def __init__(self, user_repo: UserRepository):
        self.user_repo = user_repo

    async def execute(self) -> list[User]:
        return await self.user_repo.list_recruiting()

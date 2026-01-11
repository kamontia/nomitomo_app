from datetime import datetime
from uuid import UUID
from app.domain.shop import ShopPost
from app.infrastructure.shop_repository import ShopRepository

class ShopUseCase:
    def __init__(self, shop_repo: ShopRepository):
        self.shop_repo = shop_repo

    async def create_post(self, user_id: UUID, shop_name: str, comment: str | None) -> ShopPost:
        # ID and CreatedAt are generated here for now (or by DB default, but explicit is better for logic)
        from uuid import uuid4
        new_post = ShopPost(
            id=uuid4(),
            user_id=user_id,
            shop_name=shop_name,
            comment=comment,
            created_at=datetime.utcnow()
        )
        return await self.shop_repo.create_post(new_post)

    async def list_public_posts(self) -> list[ShopPost]:
        # Only show posts older than 1 day
        from datetime import timedelta
        until = datetime.utcnow() - timedelta(days=1)
        return await self.shop_repo.list_public_posts(until)

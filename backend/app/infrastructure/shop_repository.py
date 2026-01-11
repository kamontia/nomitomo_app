from datetime import datetime
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.domain.shop import ShopPost
from app.infrastructure.models import ShopPostModel

class ShopRepository:
    def __init__(self, session: AsyncSession):
        self.session = session

    async def create_post(self, post: ShopPost) -> ShopPost:
        model = ShopPostModel(
            id=post.id,
            user_id=post.user_id,
            shop_name=post.shop_name,
            comment=post.comment,
            created_at=post.created_at
        )
        self.session.add(model)
        await self.session.flush()
        return post

    async def list_recent_posts(self, since: datetime) -> list[ShopPost]:
        stmt = select(ShopPostModel).where(
            ShopPostModel.created_at > since
        ).order_by(ShopPostModel.created_at.desc())
        
        result = await self.session.execute(stmt)
        models = result.scalars().all()
        return [ShopPost.model_validate(m) for m in models]
    
    async def list_public_posts(self, until: datetime) -> list[ShopPost]:
        # Rules: only show posts older than 'until' (24h ago)
        stmt = select(ShopPostModel).where(
            ShopPostModel.created_at < until
        ).order_by(ShopPostModel.created_at.desc())
        
        result = await self.session.execute(stmt)
        models = result.scalars().all()
        return [ShopPost.model_validate(m) for m in models]

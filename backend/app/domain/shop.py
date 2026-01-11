from uuid import UUID
from datetime import datetime
from pydantic import BaseModel, ConfigDict

class ShopPost(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: UUID
    user_id: UUID
    shop_name: str
    comment: str | None
    created_at: datetime

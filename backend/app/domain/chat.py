from uuid import UUID
from datetime import datetime
from pydantic import BaseModel, ConfigDict

class ChatRoom(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: UUID
    user_a_id: UUID
    user_b_id: UUID
    created_at: datetime

class ChatMessage(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: UUID
    room_id: UUID
    sender_id: UUID
    content: str
    created_at: datetime

from uuid import UUID
from datetime import datetime
from sqlalchemy import select, and_
from sqlalchemy.ext.asyncio import AsyncSession

from app.domain.chat import ChatRoom, ChatMessage
from app.infrastructure.models import ChatRoomModel, ChatMessageModel

class ChatRepository:
    def __init__(self, session: AsyncSession):
        self.session = session

    async def get_or_create_room(self, user_a_id: UUID, user_b_id: UUID) -> ChatRoom:
        # Check if room exists (order doesn't matter)
        stmt = select(ChatRoomModel).where(
            ((ChatRoomModel.user_a_id == user_a_id) & (ChatRoomModel.user_b_id == user_b_id)) |
            ((ChatRoomModel.user_a_id == user_b_id) & (ChatRoomModel.user_b_id == user_a_id))
        )
        result = await self.session.execute(stmt)
        model = result.scalars().first()

        if model:
            return ChatRoom.model_validate(model)

        # Create new room
        new_room = ChatRoomModel(user_a_id=user_a_id, user_b_id=user_b_id)
        self.session.add(new_room)
        await self.session.flush()
        return ChatRoom.model_validate(new_room)

    async def create_message(self, room_id: UUID, sender_id: UUID, content: str) -> ChatMessage:
        new_msg = ChatMessageModel(
            room_id=room_id,
            sender_id=sender_id,
            content=content
        )
        self.session.add(new_msg)
        await self.session.flush()
        return ChatMessage.model_validate(new_msg)

    async def list_messages(self, room_id: UUID, since: datetime) -> list[ChatMessage]:
        stmt = select(ChatMessageModel).where(
            ChatMessageModel.room_id == room_id,
            ChatMessageModel.created_at > since
        ).order_by(ChatMessageModel.created_at)
        
        result = await self.session.execute(stmt)
        models = result.scalars().all()
        return [ChatMessage.model_validate(m) for m in models]

    async def get_room_by_id(self, room_id: UUID) -> ChatRoom | None:
        stmt = select(ChatRoomModel).where(ChatRoomModel.id == room_id)
        result = await self.session.execute(stmt)
        model = result.scalars().first()
        return ChatRoom.model_validate(model) if model else None

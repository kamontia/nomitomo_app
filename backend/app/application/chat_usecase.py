from datetime import datetime, timedelta
from uuid import UUID
from app.domain.chat import ChatRoom, ChatMessage
from app.infrastructure.chat_repository import ChatRepository

class ChatUseCase:
    def __init__(self, chat_repo: ChatRepository):
        self.chat_repo = chat_repo

    async def get_or_create_room(self, user_a_id: UUID, user_b_id: UUID) -> ChatRoom:
        return await self.chat_repo.get_or_create_room(user_a_id, user_b_id)

    async def send_message(self, room_id: UUID, sender_id: UUID, content: str) -> ChatMessage:
        return await self.chat_repo.create_message(room_id, sender_id, content)

    async def list_messages(self, room_id: UUID) -> list[ChatMessage]:
        # Only fetch messages from last 3 days
        since = datetime.utcnow() - timedelta(days=3)
        return await self.chat_repo.list_messages(room_id, since)

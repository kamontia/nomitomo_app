from typing import Dict, List
from fastapi import WebSocket
from uuid import UUID

class ChatConnectionManager:
    def __init__(self):
        # user_id -> list of active websockets (supports multiple devices)
        self.active_connections: Dict[UUID, List[WebSocket]] = {}

    async def connect(self, websocket: WebSocket, user_id: UUID):
        await websocket.accept()
        if user_id not in self.active_connections:
            self.active_connections[user_id] = []
        self.active_connections[user_id].append(websocket)

    def disconnect(self, websocket: WebSocket, user_id: UUID):
        if user_id in self.active_connections:
            self.active_connections[user_id].remove(websocket)
            if not self.active_connections[user_id]:
                del self.active_connections[user_id]

    async def send_personal_message(self, message: str, user_id: UUID):
        if user_id in self.active_connections:
            for connection in self.active_connections[user_id]:
                await connection.send_text(message)

    async def broadcast_to_room(self, message: str, user_ids: List[UUID]):
        for user_id in user_ids:
            await self.send_personal_message(message, user_id)

manager = ChatConnectionManager()

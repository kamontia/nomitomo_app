from typing import Annotated
from uuid import UUID
from fastapi import APIRouter, Depends
from pydantic import BaseModel

from app.domain.chat import ChatRoom, ChatMessage
from app.domain.user import User
from app.dependencies import get_current_user, get_chat_repository
from app.infrastructure.chat_repository import ChatRepository
from app.application.chat_usecase import ChatUseCase

from fastapi import APIRouter, Depends, WebSocket, WebSocketDisconnect
from pydantic import BaseModel
from app.core.chat_ws_manager import manager
import json

router = APIRouter(prefix="/chats", tags=["Chats"])

class CreateRoomRequest(BaseModel):
    target_user_id: UUID

class SendMessageRequest(BaseModel):
    content: str

@router.post("/", response_model=ChatRoom)
async def create_room(
    request: CreateRoomRequest,
    current_user: Annotated[User, Depends(get_current_user)],
    chat_repo: Annotated[ChatRepository, Depends(get_chat_repository)]
):
    usecase = ChatUseCase(chat_repo)
    return await usecase.get_or_create_room(current_user.id, request.target_user_id)

@router.post("/{room_id}/messages", response_model=ChatMessage)
async def send_message(
    room_id: UUID,
    request: SendMessageRequest,
    current_user: Annotated[User, Depends(get_current_user)],
    chat_repo: Annotated[ChatRepository, Depends(get_chat_repository)]
):
    usecase = ChatUseCase(chat_repo)
    msg = await usecase.send_message(room_id, current_user.id, request.content)
    
    # Broadcast to recipients
    room = await chat_repo.get_room_by_id(room_id)
    if room:
        msg_payload = json.dumps(msg.model_dump(), default=str)
        await manager.broadcast_to_room(msg_payload, [room.user_a_id, room.user_b_id])
    
    return msg

@router.get("/{room_id}/messages", response_model=list[ChatMessage])
async def list_messages(
    room_id: UUID,
    current_user: Annotated[User, Depends(get_current_user)],
    chat_repo: Annotated[ChatRepository, Depends(get_chat_repository)]
):
    usecase = ChatUseCase(chat_repo)
    return await usecase.list_messages(room_id)

@router.websocket("/ws/{user_id}")
async def websocket_endpoint(websocket: WebSocket, user_id: UUID):
    await manager.connect(websocket, user_id)
    try:
        while True:
            # We don't expect messages from client via WS for now (only server -> client)
            # Use HTTP POST for sending to maintain consistency with REST
            await websocket.receive_text()
    except WebSocketDisconnect:
        manager.disconnect(websocket, user_id)

from uuid import UUID
from typing import Annotated
from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from datetime import datetime

from app.application.create_event_usecase import CreateEventUseCase, CreateEventCommand
from app.application.list_events_usecase import ListEventsUseCase
from app.dependencies import get_create_event_usecase, get_current_user, get_list_events_usecase

class CreateEventRequest(BaseModel):
    # host_id is inferred from token
    title: str
    description: str | None = None
    start_time: datetime
    location_name: str
    capacity: int

class EventResponse(BaseModel):
    id: UUID
    title: str
    status: str

router = APIRouter(prefix="/events", tags=["Events"])

@router.get("/", response_model=list[EventResponse])
async def list_events(
    use_case: Annotated[ListEventsUseCase, Depends(get_list_events_usecase)],
    limit: int = 20,
    offset: int = 0
):
    events = await use_case.execute(limit=limit, offset=offset)
    return [
        EventResponse(
            id=event.id,
            title=event.title,
            status=event.status.value
        ) for event in events
    ]

@router.post("/", response_model=EventResponse)
async def create_event(
    request: CreateEventRequest,
    current_user: Annotated[object, Depends(get_current_user)],
    use_case: Annotated[CreateEventUseCase, Depends(get_create_event_usecase)]
):
    command = CreateEventCommand(
        host_id=current_user.id,
        title=request.title,
        description=request.description,
        start_time=request.start_time,
        location_name=request.location_name,
        capacity=request.capacity
    )
    
    event = await use_case.execute(command)
    
    return EventResponse(
        id=event.id,
        title=event.title,
        status=event.status.value
    )

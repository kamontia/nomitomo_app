from uuid import uuid4, UUID
from datetime import datetime
from pydantic import BaseModel

from app.domain.event import Event, EventStatus
from app.infrastructure.event_repository import EventRepository

class CreateEventCommand(BaseModel):
    host_id: UUID
    title: str
    description: str | None = None
    start_time: datetime
    location_name: str
    capacity: int = 4

class CreateEventUseCase:
    def __init__(self, event_repo: EventRepository):
        self.event_repo = event_repo

    async def execute(self, command: CreateEventCommand) -> Event:
        # Validation checks could go here (e.g. start_time > now)
        
        new_event = Event(
            id=uuid4(),
            host_id=command.host_id,
            title=command.title,
            description=command.description,
            start_time=command.start_time,
            location_name=command.location_name,
            capacity=command.capacity,
            status=EventStatus.PLANNED,
            created_at=datetime.now(),
            updated_at=datetime.now()
        )
        
        return await self.event_repo.create(new_event)

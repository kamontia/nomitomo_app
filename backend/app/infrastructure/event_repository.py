from datetime import datetime
from uuid import UUID

from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from app.domain.event import Event, EventStatus
from app.infrastructure.models import EventModel

class EventRepository:
    def __init__(self, session: AsyncSession):
        self.session = session

    async def create(self, event: Event) -> Event:
        event_model = EventModel(
            id=event.id,
            host_id=event.host_id,
            title=event.title,
            description=event.description,
            start_time=event.start_time,
            end_time=event.end_time,
            location_name=event.location_name,
            location_address=event.location_address,
            budget_min=event.budget_min,
            budget_max=event.budget_max,
            capacity=event.capacity,
            status=event.status,
            created_at=event.created_at,
            updated_at=event.updated_at,
        )
        self.session.add(event_model)
        await self.session.flush()
        return event

    async def list_all(self, limit: int = 20, offset: int = 0) -> list[Event]:
        # Using 2.0 style select
        stmt = select(EventModel).order_by(EventModel.start_time.desc()).limit(limit).offset(offset)
        result = await self.session.execute(stmt)
        models = result.scalars().all()
        return [Event.model_validate(model) for model in models]

    async def get_by_id(self, event_id: UUID) -> Event | None:
        result = await self.session.execute(select(EventModel).where(EventModel.id == event_id))
        model = result.scalars().first()
        if model:
            return Event.model_validate(model)
        return None

    async def list_upcoming(self) -> list[Event]:
        # Simple implementation: list all future events that are not canceled
        now = datetime.now()
        stmt = select(EventModel).where(
            EventModel.start_time > now,
            EventModel.status == EventStatus.PLANNED
        ).order_by(EventModel.start_time)
        
        result = await self.session.execute(stmt)
        models = result.scalars().all()
        return [Event.model_validate(m) for m in models]

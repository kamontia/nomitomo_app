from app.domain.event import Event
from app.infrastructure.event_repository import EventRepository

class ListEventsUseCase:
    def __init__(self, event_repo: EventRepository):
        self.event_repo = event_repo

    async def execute(self, limit: int = 20, offset: int = 0) -> list[Event]:
        return await self.event_repo.list_all(limit, offset)

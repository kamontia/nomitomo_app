from datetime import datetime
from enum import Enum
from uuid import UUID, uuid4
from pydantic import BaseModel, Field, ConfigDict

class EventStatus(str, Enum):
    PLANNED = "PLANNED"
    CANCELED = "CANCELED"
    COMPLETED = "COMPLETED"

class Event(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: UUID = Field(default_factory=uuid4)
    host_id: UUID
    title: str
    description: str | None = None
    start_time: datetime
    end_time: datetime | None = None
    location_name: str
    location_address: str | None = None
    budget_min: int | None = None
    budget_max: int | None = None
    capacity: int
    status: EventStatus = EventStatus.PLANNED
    created_at: datetime = Field(default_factory=datetime.now)
    updated_at: datetime = Field(default_factory=datetime.now)

    def cancel(self):
        self.status = EventStatus.CANCELED
        self.updated_at = datetime.now()

    def is_full(self, current_participants_count: int) -> bool:
        return current_participants_count >= self.capacity

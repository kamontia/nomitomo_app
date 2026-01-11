from datetime import datetime
from uuid import UUID, uuid4
from pydantic import BaseModel, Field, ConfigDict

class User(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: UUID = Field(default_factory=uuid4)
    line_user_id: str
    firebase_uid: str | None = None
    display_name: str
    avatar_url: str | None = None
    bio: str | None = None
    is_recruiting: bool = False
    created_at: datetime = Field(default_factory=datetime.now)
    updated_at: datetime = Field(default_factory=datetime.now)

    def update_profile(self, display_name: str | None, bio: str | None, avatar_url: str | None) -> None:
        if display_name:
            self.display_name = display_name
        if bio:
            self.bio = bio
        if avatar_url:
            self.avatar_url = avatar_url
        self.updated_at = datetime.now()

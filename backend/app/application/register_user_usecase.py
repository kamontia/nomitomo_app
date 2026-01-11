from uuid import uuid4
from datetime import datetime

from app.domain.user import User
from app.infrastructure.user_repository import UserRepository

# DTOs
from pydantic import BaseModel

class RegisterUserCommand(BaseModel):
    line_access_token: str # In real world, verify this
    line_user_id: str # Extracted from token
    display_name: str
    avatar_url: str | None = None

import httpx
from fastapi import HTTPException, status
from app.core.config import settings

class RegisterUserUseCase:
    def __init__(self, user_repo: UserRepository):
        self.user_repo = user_repo

    async def execute(self, command: RegisterUserCommand) -> User:
        # 1. Verify LINE Access Token
        async with httpx.AsyncClient() as client:
            # Verify token
            verify_resp = await client.get(
                "https://api.line.me/oauth2/v2.1/verify",
                params={"access_token": command.line_access_token}
            )
            if verify_resp.status_code != 200:
                raise HTTPException(
                    status_code=status.HTTP_401_UNAUTHORIZED,
                    detail="Invalid LINE access token"
                )
            
            # Check channel ID (if configured)
            if settings.LINE_CHANNEL_ID:
                verify_data = verify_resp.json()
                if verify_data.get("client_id") != settings.LINE_CHANNEL_ID:
                    raise HTTPException(
                        status_code=status.HTTP_401_UNAUTHORIZED,
                        detail="LINE token issued for different channel"
                    )

            # 2. Get Profile
            profile_resp = await client.get(
                "https://api.line.me/v2/profile",
                headers={"Authorization": f"Bearer {command.line_access_token}"}
            )
            if profile_resp.status_code != 200:
                raise HTTPException(
                    status_code=status.HTTP_401_UNAUTHORIZED,
                    detail="Failed to fetch LINE profile"
                )
            
            profile = profile_resp.json()
            line_user_id = profile["userId"]
            display_name = profile["displayName"]
            avatar_url = profile.get("pictureUrl")

        # 3. Register or Update User
        existing_user = await self.user_repo.get_by_line_id(line_user_id)
        if existing_user:
            # Update profile info if changed
            existing_user.display_name = display_name
            existing_user.avatar_url = avatar_url
            return await self.user_repo.update(existing_user)
        
        new_user = User(
            id=uuid4(),
            line_user_id=line_user_id,
            display_name=display_name,
            avatar_url=avatar_url,
            is_recruiting=False,
            created_at=datetime.now(),
            updated_at=datetime.now()
        )
        return await self.user_repo.create(new_user)

from typing import Annotated
from fastapi import APIRouter, Depends
from pydantic import BaseModel

from app.application.register_user_usecase import RegisterUserUseCase, RegisterUserCommand
from app.dependencies import get_register_user_usecase

class LoginRequest(BaseModel):
    line_access_token: str
    display_name: str # Simplified: usually fetched from LINE
    avatar_url: str | None = None

class LoginResponse(BaseModel):
    user_id: str
    display_name: str
    access_token: str

router = APIRouter(prefix="/auth", tags=["Auth"])

@router.post("/login", response_model=LoginResponse)
async def login(
    request: LoginRequest,
    use_case: Annotated[RegisterUserUseCase, Depends(get_register_user_usecase)]
):
    # Mock extracting LINE User ID from token
    # In reality: verify(request.line_access_token) -> line_user_id
    mock_line_user_id = f"line_{request.line_access_token[:10]}"
    
    command = RegisterUserCommand(
        line_access_token=request.line_access_token,
        line_user_id=mock_line_user_id,
        display_name=request.display_name,
        avatar_url=request.avatar_url,
    )
    
    user = await use_case.execute(command)
    
    # Generate backend session token (JWT)
    from app.core import security
    backend_token = security.create_access_token(subject=user.id)
    
    return LoginResponse(
        user_id=str(user.id),
        display_name=user.display_name,
        access_token=backend_token
    )

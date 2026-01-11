import asyncio
import httpx
from datetime import datetime
from uuid import uuid4

BASE_URL = "http://localhost:8000"

async def register_user(client, display_name):
    # Register/Login
    line_token = f"mock_token_{display_name}"
    response = await client.post(
        f"{BASE_URL}/auth/login",
        json={"line_access_token": line_token, "display_name": display_name}
    )
    if response.status_code != 200:
        print(f"Failed to login {display_name}: {response.text}")
        return None
    return response.json()["access_token"], response.json()["user_id"]

async def main():
    async with httpx.AsyncClient() as client:
        print("--- 1. Verification: User Matching ---")
        # Login 2 users
        token_a, id_a = await register_user(client, "UserA")
        token_b, id_b = await register_user(client, "UserB")
        
        headers_a = {"Authorization": f"Bearer {token_a}"}
        headers_b = {"Authorization": f"Bearer {token_b}"}

        # User A sets recruiting status to True
        resp = await client.post(
            f"{BASE_URL}/users/me/status",
            json={"is_recruiting": True},
            headers=headers_a
        )
        print(f"User A Status Update: {resp.status_code}")

        # User B checks recruiting list
        resp = await client.get(f"{BASE_URL}/users/recruiting", headers=headers_b)
        recruiting_users = resp.json()
        print(f"Recruiting Users seen by B: {len(recruiting_users)}")
        assert any(u["id"] == id_a for u in recruiting_users)

        print("\n--- 2. Verification: Chat System ---")
        # User B starts chat with User A
        resp = await client.post(
            f"{BASE_URL}/chats/",
            json={"target_user_id": id_a},
            headers=headers_b
        )
        room = resp.json()
        room_id = room["id"]
        print(f"Chat Room Created: {room_id}")

        # User B sends message
        await client.post(
            f"{BASE_URL}/chats/{room_id}/messages",
            json={"content": "Hello A!"},
            headers=headers_b
        )
        
        # User A checks messages
        resp = await client.get(f"{BASE_URL}/chats/{room_id}/messages", headers=headers_a)
        msgs = resp.json()
        print(f"Messages seen by A: {len(msgs)}")
        assert len(msgs) == 1
        assert msgs[0]["content"] == "Hello A!"

        print("\n--- 3. Verification: Shop Recommendations ---")
        # User A posts a shop
        await client.post(
            f"{BASE_URL}/shops/posts",
            json={"shop_name": "Hidden Gem Bar", "comment": "Great sake!"},
            headers=headers_a
        )

        # User B checks posts (Should be empty immediately as logic is > 24h old posts ONLY? Wait, plan says < 24h is hidden?)
        # Logic implemented: list_public_posts checks created_at < 24h ago.
        # So a fresh post should NOT be visible.
        resp = await client.get(f"{BASE_URL}/shops/", headers=headers_b)
        posts = resp.json()
        print(f"Shop Posts seen by B (should be 0): {len(posts)}")
        assert len(posts) == 0

        print("\n--- Verification Complete ---")

if __name__ == "__main__":
    loop = asyncio.get_event_loop()
    loop.run_until_complete(main())

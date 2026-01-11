import asyncio
import websockets
import json
import httpx
from uuid import UUID

BASE_URL = "http://localhost:8000"
WS_URL = "ws://localhost:8000/chats/ws"

async def register_user(client, name):
    resp = await client.post(f"{BASE_URL}/auth/login", json={"line_access_token": f"token_{name}", "display_name": name})
    data = resp.json()
    return data["access_token"], data["user_id"]

async def test_websocket():
    async with httpx.AsyncClient() as client:
        # 1. Register two users
        token_a, id_a = await register_user(client, "UserA")
        token_b, id_b = await register_user(client, "UserB")
        
        headers_a = {"Authorization": f"Bearer {token_a}"}
        headers_b = {"Authorization": f"Bearer {token_b}"}

        # 2. Create a room
        resp = await client.post(f"{BASE_URL}/chats/", json={"target_user_id": id_b}, headers=headers_a)
        room = resp.json()
        room_id = room["id"]
        print(f"Room created: {room_id}")

        # 3. User B connects to WebSocket
        async with websockets.connect(f"{WS_URL}/{id_b}") as ws_b:
            print(f"User B connected to WS")

            # 4. User A sends message via REST
            print("User A sending message...")
            await client.post(f"{BASE_URL}/chats/{room_id}/messages", json={"content": "WS Test Message"}, headers=headers_a)

            # 5. User B should receive message via WS
            print("Waiting for User B to receive message...")
            try:
                msg_raw = await asyncio.wait_for(ws_b.recv(), timeout=5.0)
                msg_info = json.loads(msg_raw)
                print(f"User B received message: {msg_info['content']}")
                assert msg_info["content"] == "WS Test Message"
                print("WS Real-time delivery SUCCESS")
            except asyncio.TimeoutError:
                print("FAILED: User B did not receive message via WS")

if __name__ == "__main__":
    asyncio.run(test_websocket())

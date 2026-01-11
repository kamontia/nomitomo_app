import urllib.request
import json
import urllib.error
import time
import sys

BASE_URL = "http://127.0.0.1:8000"

def run_request(method, endpoint, data=None, headers=None):
    if headers is None:
        headers = {}
    
    url = f"{BASE_URL}{endpoint}"
    req = urllib.request.Request(url, method=method, headers=headers)
    
    if data:
        json_data = json.dumps(data).encode('utf-8')
        req.add_header('Content-Type', 'application/json')
        req.data = json_data
        
    try:
        with urllib.request.urlopen(req) as response:
            status = response.status
            body = response.read().decode('utf-8')
            try:
                json_body = json.loads(body)
                return status, json_body
            except:
                return status, body
    except urllib.error.HTTPError as e:
        return e.code, e.reason
    except Exception as e:
        return None, str(e)

def main():
    print(f"Checking {BASE_URL}...")
    
    # 1. Health
    print("\n[1] Health Check")
    status, body = run_request("GET", "/health")
    if status == 200:
        print("PASS")
    else:
        print(f"FAIL: {status} {body}")
        sys.exit(1)

    # 2. Login
    print("\n[2] Login")
    login_data = {"line_access_token": "fake_token_123", "display_name": "Test User"}
    status, body = run_request("POST", "/auth/login", data=login_data)
    if status == 200 and "access_token" in body:
        token = body["access_token"]
        print("PASS (Token received)")
    else:
        print(f"FAIL: {status} {body}")
        sys.exit(1)

    # 3. Create Event (Unauthorized)
    print("\n[3] Create Event (Unauthorized)")
    event_data = {
        "title": "Secret Party",
        "start_time": "2025-01-01T18:00:00",
        "location_name": "Secret Base",
        "capacity": 10
    }
    status, body = run_request("POST", "/events/", data=event_data)
    if status == 401:
        print("PASS (401 received)")
    else:
        print(f"FAIL: Expected 401, got {status}")

    # 4. Create Event (Authorized)
    print("\n[4] Create Event (Authorized)")
    auth_headers = {"Authorization": f"Bearer {token}"}
    status, body = run_request("POST", "/events/", data=event_data, headers=auth_headers)
    if status == 200:
        print("PASS (Event created)")
    else:
        print(f"FAIL: {status} {body}")

    # 5. List Events
    print("\n[5] List Events")
    status, body = run_request("GET", "/events/", headers=auth_headers)
    if status == 200 and isinstance(body, list):
        found = any(e['title'] == "Secret Party" for e in body)
        if found:
            print("PASS (Event found in list)")
        else:
            print("FAIL: Event not found in list")
            print(body)
    else:
        print(f"FAIL: {status} {body}")

if __name__ == "__main__":
    main()

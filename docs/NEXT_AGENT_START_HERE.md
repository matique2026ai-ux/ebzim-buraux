# NEXT AGENT START HERE

> [!IMPORTANT]
> **DO NOT START CODING OR DEBUGGING UNTIL YOU READ THIS FIL**E.

## 1. Safety First
- **X** Do **NOT** open Swagger (`/api/docs`).
- **X** Do **NOT** re-investigate MongoDB Atlas connectivity. It is working.
- **X** Do **NOT** use Memory Fallback (Mock DB). We are on **REAL RUNTIME**.
- **X** Do **NOT** drift into Admin Dashboard tasks.

## 2. Current Mission
The project is in a **Manual Testing Phase**.
Your only goal is to maintain the current working state and support the user in manually testing the **Normal User Login**.

## 3. Credentials for Troubleshooting
- **User**: `matique2025@gmail.com`
- **Password**: `12345678`
- **Role**: Normal Public User.

## 4. Operational Setup
The system is currently running on:
- **Backend**: Port 3000 (NestJS)
- **Frontend**: Port 5000 (Flutter Web Static Release)

## 5. Mandatory Reading Order
1. [AGENT_HANDOFF.md](file:///c:/Users/PCIB/Desktop/ebzim-app/docs/AGENT_HANDOFF.md) - The full Master Truth (13 sections).
2. [PROJECT_ARCHITECTURE.md](file:///c:/Users/PCIB/Desktop/ebzim-app/docs/PROJECT_ARCHITECTURE.md) - How the servers talk.
3. [LOCALIZATION_POLICY.md](file:///c:/Users/PCIB/Desktop/ebzim-app/docs/LOCALIZATION_POLICY.md) - Language rules.

## 6. If Something Fails
If the user reports a login failure:
- Check the console at `http://localhost:5000`.
- Verify the backend logs (port 3000).
- Check the `auth_service.dart` implementation vs the Atlas account role.

**Now, stand by and wait for the user to initiate the manual test.**

# NEXT AGENT START HERE

> [!IMPORTANT]
> **DO NOT START CODING OR DEBUGGING UNTIL YOU READ THIS FIL**E.

## 1. Safety First
- **X** Do **NOT** open Swagger (`/api/docs`).
- **X** Do **NOT** re-investigate MongoDB Atlas connectivity. It is fully operational and the IP allowlisting issue has been resolved.
- **X** Do **NOT** use Memory Fallback (Mock DB). We are on **REAL RUNTIME**.
- **X** Do **NOT** drift into Admin Dashboard tasks until explicit user request.
- **Note on UI/UX:** The Visual Polish, Dashboard, About Page, and Profile flows have been successfully completed in previous sessions (RP-024 to RP-033). **Only redesign or modify these components if the user explicitly asks you to change their mind.**

## 2. Current Mission
The project is in a **Manual Testing Phase**. The user successfully connected to the cloud DB today.
Your goal is to support the user in manually testing the Application UI, specifically:
1. Review the **About Page** redesign (Institutional look).
2. Validate Terminology ("Executive Office").
3. Verify the **Profile & Membership** hierarchy.

## 3. Credentials for Troubleshooting
- **User**: `matique2025@gmail.com`
- **Password**: `12345678`
- **Role**: Normal Public User.

## 4. Operational Setup
The system is currently running on:
- **Backend**: Port 3000 (NestJS)
- **Frontend**: Port 5000 (Flutter Web Static Release)

## 5. Mandatory Reading Order
1. [AGENT_HANDOFF.md](file:///c:/Users/PCIB/Desktop/ebzim-app/docs/AGENT_HANDOFF.md) - The full Master Truth.
2. [PROJECT_ARCHITECTURE.md](file:///c:/Users/PCIB/Desktop/ebzim-app/docs/PROJECT_ARCHITECTURE.md) - How the servers talk.
3. [LOCALIZATION_POLICY.md](file:///c:/Users/PCIB/Desktop/ebzim-app/docs/LOCALIZATION_POLICY.md) - Language rules.

## 6. Where We Left Off
- The backend successfully overcame the SSL/TLS IP block after the user authorized their new IP address in MongoDB Atlas.
- Real user login works normally with real data.
- The next step is to continue evaluating the UI (Profile screen and About screen).

**Now, stand by and wait for the user to initiate the next test or code request.**

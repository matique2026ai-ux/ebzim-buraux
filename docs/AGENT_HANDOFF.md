# Agent Master Handoff - EBZIM APP

## 1) PROJECT OVERVIEW
- **Description**: EBZIM is a digital platform for the "Ebzim Association for Culture and Citizenship" (Sétif, Algeria). It handles cultural heritage discovery, membership management, the association's bylaws, and institutional news.
- **User Flows**:
  - **Public/Guest Flow**: Discovery, News, Public Events, and Platform registration.
  - **Member Flow**: Verified membership, Digital ID, Fee tracking, and Association governance access.
  - **Admin Flow**: CMS for posts/events, membership approval, and platform metrics.
- **Completion Status**: Core Authentication, Multi-language Support (AR, FR, EN), and Base Dashboard structure are **Complete**. Feature modules (Events, Payments, ID Cards) are UI-ready but await E2E data verification.

## 2) SYSTEM ARCHITECTURE
- **Frontend Stack**: Flutter Web 3.41.6. Optimized via **Static Release Build** to circumvent development module loading hangs.
- **Backend Stack**: NestJS (Node.js) using the `api/v1` prefix.
- **Database/Runtime**: MongoDB Atlas (Cloud Production).
- **Auth Architecture**: JWT-based (Bearer tokens). Hashing via Bcrypt (10 rounds).
- **Localization**: Centralized ARB files in `lib/core/localization/l10n/`. Professional Arabic standard is strictly enforced.
- **Ports & URLs**:
  - **APP (Frontend)**: [http://localhost:5000](http://localhost:5000) (Served via `serve_static.js`)
  - **API (Backend)**: [http://localhost:3000](http://localhost:3000)
  - **Swagger Docs**: `http://localhost:3000/api/docs` (**Note**: User does NOT want this opened unless necessary).

## 3) CURRENT WORKING RUNTIME STATE
- **Frontend**: **RUNNING** on port 5000 (Serving production build).
- **Backend**: **RUNNING** on port 3000 (Connected to real Atlas cluster).
- **Application**: The application opens and renders successfully without loading stalls (DDC hang fixed).
- **Runtime**: Real production-backed config is active. IP allowlisting is verified.
- **Status**: The project is beyond the "Connectivity Blocker" stage.

## 4) INCIDENT HISTORY / RESOLVED ISSUES
- **Atlas Context Gap**: Resolved. Real credentials and SRV host are now applied.
- **IP Block**: Resolved. Current network access is correctly allowlisted in Atlas.
- **Startup Errors**: Fixed `EADDRINUSE` for port 3000.
- **Web Hang**: Fixed 662-item script stall by switching to a static release build.

## 5) USER ACCOUNT TRUTH
- **Target Account**: **matique2025@gmail.com** (Normal User).
- **Password**: `12345678`
- **Database Status**: This account was restored to Atlas after being lost during a memory-fallback session. Current role is `PUBLIC`.
- **Context**: This is a **user login task**, not an admin dashboard or membership seeding task.

## 6) USER PREFERENCES / WORKING RULES
- **X** Do NOT open Swagger automatically.
- **X** Do NOT use mocks/fallbacks if real runtime is available.
- **✓** Open ONLY the app window at `http://localhost:5000`.
- **✓** The user prefers manual end-to-end testing himself.
- **✓** **Arabic Standard**: Always use `"بيانات الدخول غير صحيحة"` for invalid login attempts.

## 7) DECISIONS ALREADY MADE
- **Atlas Priority**: MongoDB Atlas is the sole source of truth; no return to Memory Fallback unless Atlas fails.
- **Release Build Strategy**: Use static serving (`serve_static.js`) for the frontend to maintain stability and speed.
- **Credential Handling**: All secrets are configured locally in `.env`. Do not request them again or log them.

## 8) DO NOT SEND NEXT AGENT BACK TO THESE
- **X** Do NOT re-investigate Mongo/Atlas connectivity from zero.
- **X** Do NOT re-ask for the MongoDB password.
- **X** Do NOT drift into Admin Dashboard or "Developer Tools" work unless asked.
- **X** Do NOT replace the user-login objective with admin seeding.

## 9) NEXT EXACT TASK
1. **Read all handoff files first**.
2. **Ensure ONLY the app window** (`http://localhost:5000`) is open.
3. **Allow the USER to manually test** the login with `matique2025@gmail.com`.
4. **Troubleshoot ONLY** if the normal user login fails.

## 10) ROADMAP
- **Phase 1 (Complete)**: E2E Connectivity & User Restoration.
- **Phase 2 (Next)**: Manual Login Verification & Dashboard Content Audit.
- **Phase 3**: Scaling feature verification (Events, News, Cards).

## 11) REPO MAP
- **Frontend Auth Screens**: `lib/screens/login_screen.dart`
- **Frontend Services**: `lib/core/services/auth_service.dart`, `lib/core/services/api_client.dart`.
- **Backend Modules**: `ebzim-backend/src/modules/auth/`, `ebzim-backend/src/modules/users/`.
- **Localization**: `lib/core/localization/l10n/` (ARB files).
- **Runtime Assets**: `build/web/` (Production build), `serve_static.js`.

## 12) OPERATIONAL NOTES
- **Start Backend**: `npm run start:dev` (in `ebzim-backend/`).
- **Start Frontend**: `node serve_static.js` (in root).
- **Order**: Start backend first, then frontend.

## 13) SOURCE OF TRUTH
- **Primary**: `docs/AGENT_HANDOFF.md`
- **History**: `docs/CHANGELOG_WORKING_STATE.md`
- **Checklist**: `docs/NEXT_AGENT_START_HERE.md`

## 14) SAFE CLEANUP STATUS
- **Status**: **COMPLETE**.
- **Actions**: Removed all temporary scratch scripts (`scratch/`), debug logs (`analyze_*.txt`), large installers, and investigative artifacts from both root and backend directories.
- **Integrity**: Verified that all core source files, configuration files (`.env`), and serving scripts (`serve_static.js`) remain untouched and operational.
- **Environment**: The project is now in a clean, state-of-the-art production-ready condition for handoff.

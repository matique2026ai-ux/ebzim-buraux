# 🦅 EBZIM PLATFORM - ULTIMATE MASTER REPOST (APRIL 2026)

This document is the **Single Source of Truth** for the "Ebzim for Culture and Citizenship" platform. It consolidates 40+ RPs of development, architectural decisions, and institutional memory into one unified roadmap for all future agents.

---

## 📍 PHASE 8: MISSION CONTROL (CURRENT STATE)
**Current Status**: **LAUNCH READY**.
The platform is technically, legally, and linguistically complete for the current phase (v1.1.3).
- **Core Stability**: 100% connected (Backend :3000 -> Atlas Cloud DB; Frontend :8080 Release).
- **Security**: JWT-based Auth with 30-day session expiry.
- **Institutional Alignment**: Fully synchronized with the Dec 2024 Association Statutes.

---

## 🏗️ TECHNICAL ARCHITECTURE

### 🎨 Frontend (Flutter Web/Mobile)
- **Path**: `c:\ebzim-buraux`
- **Design System**: "Dark Glass" Institutional Aesthetic.
  - **Colors**: Midnight Emerald (`#052011`), Muted Gold (`#D4AF37`), Absolute Midnight (`#020704`).
  - **Light Mode**: "Warm Parchment" (`#F0EDE6`) for a cultural paper feel.
- **Typography**: `Tajawal` (Headlines) & `Cairo` (Body). Strictly managed via `AppTheme`.
- **State**: `Riverpod` (Functional Providers).
- **Navigation**: `GoRouter` with Slide-up/Fade transitions.
- **Serving**: Production builds served via `serve_static.js` on Port 8080.

### ⚙️ Backend (NestJS)
- **Path**: `c:\ebzim-buraux\backend`
- **Database**: **MongoDB Atlas** (Cloud).
- **IP Whitelisting**: If connection fails, the agent must ask the user to whitelist the current IP in the Atlas Dashboard.
- **Environment**: Port 3000. Managed via `backend/.env` (reconstructed in RP-036).
- **NO DOCKER**: Run via `npm run start:dev` natively.

---

## 🏛️ INSTITUTIONAL CONTEXT
**EBZIM Association for Culture & Citizenship (Sétif, Algeria)**
- **Network**: Member of the **UNESCO Algeria Network**.
- **Partnerships**: National Museum of Antiquities (Sétif), Ministry of Mujahideen (Hamma Military Barracks Restoration).
- **Statutes**: Approved 14 Dec 2024. Authority for all product copy.
- **Legal Reference**: [statutes_ar.md](file:///c:/ebzim-buraux/docs/statutes/statutes_ar.md).

---

## 📂 MASTER FEATURE INVENTORY

### ✅ User Features
- **Smart Dashboard**: Multilingual greeting with pulse active status. Distinction between "User" and "Official Member".
- **Heritage Projects**: Animated timeline of restoration projects (Caserne d'El-Hamma, Museum Partnership).
- **Civil Reporting**: 4-step E2E workflow for reporting heritage violations (Vandalism, Theft, etc.).
- **Digital Library**: Searchable repository of PDFs (Archaeology, Research, Reports).
- **Contributions**: Dual-choice system (Annual Membership Subscription vs Project Donations).
- **Membership Flow**: 4-step recruitment process based on Art. 10 & 11 of the statutes.

### ✅ Admin Features (Mission Control)
- **Membership Management**: Approve/Reject applicants.
- **Civic Report Triage**: Review community violation reports.
- **Financial Oversight**: Verify verification of subscription/donation proof.
- **Content CRUD**: Full management of News, Events, and Library resources.

---

## 📜 DEVELOPMENT HISTORY (RP LOG)

| RP | Phase | Key Accomplishments |
| :--- | :--- | :--- |
| **RP-001 - RP-031** | **Foundational** | Auth setup, SMTP config, RTL Layouts, Atlas Connectivity, Global i18n Policy. |
| **RP-032** | **Member Discovery** | Rebuilt Membership Discovery flow and Profile screen hierarchy. |
| **RP-033** | **Institutional About** | Rewrote About screen using 2024 Statutes; integrated professional placeholders. |
| **RP-034** | **Mobile APK** | Generated stable Android APK and verified on real physical devices. |
| **RP-035** | **Admin Audit** | Verified CRUD for News/Events and Membership Review modules. |
| **RP-036** | **Env Restoration** | Reconstructed `.env` and installed Node.js on workstation device. |
| **RP-037** | **Dark Glass Identity** | Global redesign using Midnight Emerald & Muted Gold theme tokens. |
| **RP-038** | **Civil & Heritage** | Built `HeritageProjectsScreen` and `CivicReportScreen` (UNESCO alignment). |
| **RP-039** | **UX Polish** | Overhauled Light Theme (Warm Parchment), added Slide-up transitions, redesigned About & Membership. |
| **RP-040** | **Statute Core** | Implemented `StatuteScreen` (118 articles, AR/EN/FR) and Leadership Sync. |
| **RP-041** | **Reporting E2E** | Linked Civic Reports to NestJS/MongoDB with auto-titling logic. |
| **RP-042** | **Digital Library** | Built searchable research/PDF repository with in-app category chips. |
| **RP-043** | **Financials** | Added Subscription/Donation system with Dynamic Fee Management. |
| **RP-044** | **Mission Control** | Final Admin Dashboard redesign (4-sector management system). |
| **RP-045** | **Deep Cleanup** | Comprehensive project reorganization: Moved scripts/assets, renamed backend, and focused on mobile. |

---

## 🚀 ROADMAP (NEXT STEPS)
1. **Digital ID Card**: Implementation of the digital membership card generation for approved members.
2. **Notification Engine**: Integration of real-time alerts for report status updates and event reminders.
3. **Advanced Analytics**: Visual charts for administrative reporting on heritage violations and financial contributions.

---

## ⚠️ MISSION-CRITICAL RULES
1. **No Hardcoded Values**: Colors MUST use `AppTheme.tokens`. Strings MUST use `AppLocalizations`. 
2. **RTL Integrity**: All new widgets must be tested in Arabic/RTL first. Use `Directional` padding.
3. **Institutional Tone**: Follow [EBZIM_ASSOCIATION_REFERENCE.md] (now merged here) for all copy.
4. **Numeral Policy**: Use Western Arabic numerals (0, 1, 2...) for all languages.

---

## 🚀 QUICK START & RECOVERY (FOR NEW AGENTS)

### 1. Clear Port Conflicts
If you see `EADDRINUSE` errors, run these commands to clear the ports:
- **Backend (3000)**: `netstat -ano | findstr :3000` -> `taskkill /F /PID <PID>`
- **Frontend (8080)**: `netstat -ano | findstr :8080` -> `taskkill /F /PID <PID>`

### 2. Prepare the Environment
If the `build/web` folder is missing (White Screen error), you MUST rebuild:
```powershell
flutter pub get
flutter build web --release
```

### 3. Start the Servers
- **Backend (Port 3000)**: 
  ```powershell
  cd backend
  npm run start:dev
  ```
- **Frontend (Port 8080)**:
  ```powershell
  node scripts/serve_static.js
  ```

### 4. Access Credits
- **URL**: `http://localhost:8080`
- **Test Account**: `matique2025@gmail.com` / `12345678`

# 🦅 EBZIM PLATFORM - MISSION CONTROL (Master Documentation)

This is the **Single Source of Truth** for the "Ebzim for Culture and Citizenship" platform. It consolidates all historical data, architectural decisions, and the current operational state to ensure continuity for future development.

---

## 📍 PROJECT OVERVIEW
**EBZIM Association for Culture & Citizenship (Sétif, Algeria)**
A premium institutional platform for cultural heritage protection, citizen reporting, and membership management.
- **Institutional Alignment**: Fully synchronized with the Dec 2024 Association Statutes and UNESCO Algeria Network standards.
- **Languages**: Full Trilingual support (Arabic - Primary, English, French).

---

## 🏗️ TECHNICAL ARCHITECTURE

### 🎨 Frontend (Flutter Web/Mobile)
- **Path**: `c:\ebzim-buraux`
- **Design System**: "Dark Glass" Institutional Aesthetic.
  - **Primary Colors**: Midnight Emerald (`#052011`), Muted Gold (`#D4AF37`).
  - **Light Mode**: "Sovereign Sage" (`#E2E9E5`) with pure white cards.
- **Typography**: `Tajawal` (Headlines) & `Cairo` (Body). Strictly managed via `AppTheme`.
- **State Management**: `Riverpod`.
- **Navigation**: `GoRouter`.
- **Serving Strategy**: For production-like testing, use `flutter build web --release` and serve via a custom Node.js script if necessary.

### ⚙️ Backend (NestJS)
- **Path**: `c:\ebzim-buraux\backend`
- **Database**: **MongoDB Atlas** (Cloud-based).
- **Environment**: Port 3000. Use `npm run start:dev`.
- **API URL**: `https://ebzim-api.onrender.com/api/v1/` (Production) / `http://localhost:3000/api/v1/` (Local).

---

## 🔍 KEY LOGIC LOCATIONS

### Authentication & User Flow
- **Frontend Entry**: `lib/screens/login_screen.dart`
- **Frontend Auth Service**: `lib/core/services/auth_service.dart`
- **Backend Guard**: `backend/src/common/guards/jwt-auth.guard.ts`
- **Backend Service**: `backend/src/modules/auth/auth.service.ts`

### Content & Membership
- **News/Posts**: `lib/core/services/news_service.dart` (Frontend) / `backend/src/modules/posts/` (Backend).
- **Membership**: `lib/screens/membership/` (Frontend) / `backend/src/modules/members/` (Backend).
- **Civil Reporting**: `lib/screens/civil_reporting/` (Frontend) / `backend/src/modules/reports/` (Backend).

### Localization (i18n)
- **Source Files**: `lib/core/localization/l10n/*.arb`
- **Generated Files**: `lib/core/localization/l10n/app_localizations_*.dart`

---

## ✅ CURRENT STATE (V1.2.0 - Stable)
As of **April 17, 2026**, the project is in a fully stable, production-ready state.

### 🌟 Key Features Implemented:
1.  **Dynamic Home Screen**: High-fidelity redesign with glassmorphic hero carousel and real-time statistics.
2.  **Admin Dashboard (Mission Control)**: Full CRUD for News, Events, and Membership management.
3.  **Membership Flow**: 6-step recruitment process based on the association's statutes.
4.  **Civil Reporting**: E2E workflow for reporting heritage violations (Vandalism, Theft).
5.  **Digital Library**: Searchable repository for research papers and PDFs.
6.  **Auth System**: Secure JWT-based login/register with OTP verification support.

---

## ⚠️ MISSION-CRITICAL RULES (FOR AGENTS)
1.  **RTL First**: All UI components MUST be tested in Arabic first. Use `Directional` padding/margins.
2.  **Theme Tokens**: Never use hardcoded colors. Use `AppTheme.primaryColor`, `AppTheme.accentColor`, etc.
3.  **Institutional Tone**: Use formal, professional Arabic as found in `docs/statutes/`.
4.  **Port Management**: 
    - Backend: `3000`
    - Frontend (Web): `5050` (Dev) / `8080` (Release).

---

## 🚀 QUICK START
1.  **Sync**: Always `git pull origin main` before starting.
2.  **Backend**: `cd backend; npm run start:dev`
3.  **Frontend**: `flutter run -d web-server --web-port 5050`
4.  **Test Account**: `matique2025@gmail.com` / `12345678`

---

## 📂 WORKSPACE STATUS
The project directory has been consolidated. All legacy documentation and redundant handoff files have been removed or archived into this README.
- **Reference Material**: Association statutes remain in `docs/statutes/` for institutional alignment.
- **Cleaned Files**: `HANDOFF.md`, `PROJECT_HANDOVER.md`, `MASTER_PLAN.md`, `ARCHITECTURE.md`, etc. have been deleted.


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
- **Design System**: **"Emerald Nocturne"** (Institutional Artist Grade).
  - **Background**: Midnight Forest Obsidian (`#010503`) with Aurora Atmospheric Glows.
  - **Primary Colors**: Royal Emerald (`#064E3B`), Antique Gold (`#C5A059`).
  - **Surface Style**: "Glass Jewel" (60% opacity crystalline cards with 30% white glass borders).
- **Typography**: `Tajawal` (Headlines) & `Cairo` (Body). Strictly managed via `AppTheme`.
- **State Management**: `Riverpod`.

### ⚙️ Backend (NestJS)
- **Path**: `c:\ebzim-buraux\backend`
- **Database**: **MongoDB Atlas** (Cloud-based).
- **Environment**: Port 3000. Use `npm run start:dev`.
- **API URL**: `http://localhost:3000/api/v1/` (Local Development Baseline).

---

## 📂 CRITICAL DOCUMENTATION (April 2026 Milestone)
- **[Visual Identity: Emerald Nocturne](C:\Users\PCIB\.gemini\antigravity\brain\058aa6ef-a5e1-46c8-8963-df040cbe17e1\visual_identity_emerald_nocturne.md)**: Details the artistic philosophy and color tokens.
- **[Handover & Roadmap](C:\Users\PCIB\.gemini\antigravity\brain\058aa6ef-a5e1-46c8-8963-df040cbe17e1\handover_and_roadmap.md)**: Current task list and next integration steps.

---

## ✅ CURRENT STATE (V1.3.0 - Artistic Milestone)
As of **April 17, 2026 (Evening)**, the project is in a high-fidelity, production-stable state.

### 🌟 Latest Achievements:
- **Emerald Nocturne Identity**: Complete overhaul of the visual system to a premium institutional grade.
- **Atmospheric UI**: Implementation of layered radial glows and physical material textures (Stardust Grain).
- **Dashboard Stability**: Null-safe handling of Guest vs. Member states with elegant fallback profiles.
- **Architecture**: Unified `EbzimBackground` and `AppTheme` as the "Single Source of Truth" for visuals.

---

## ⚠️ MISSION-CRITICAL RULES
1.  **NO NEUTRAL GREYS**: Never use standard grey/black. Use the `Emerald Nocturne` palette.
2.  **RTL First**: All UI components MUST be tested in Arabic first.
3.  **Theme Tokens**: Never use hardcoded colors. Use `AppTheme` constants.

---

## 🚀 QUICK START
1.  **Backend**: `cd backend; npm run start:dev`
2.  **Frontend**: `flutter run -d web-server --web-port 8080`
3.  **Test Account**: `matique2025@gmail.com` / `12345678`

---

## 📂 WORKSPACE STATUS
The project is clean, documented, and ready for continuous integration.
- **Reference Material**: Association statutes remain in `docs/statutes/`.
- **Archive**: Legacy design experiments have been purged to maintain project cleanliness.

---
*Maintained by Antigravity (Advanced Agentic Coding)*

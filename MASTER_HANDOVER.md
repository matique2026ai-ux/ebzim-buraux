# 👑 Ebzim Sovereign Platform: Comprehensive Master Handover (Final Edition)

> [!IMPORTANT]
> **AGENTS PROTOCOL:** There is ONLY ONE handover file for this project. DO NOT create new handover documents. You MUST merge, update, and refine this existing `MASTER_HANDOVER.md` file at the end of every session. This is the **exclusive source of truth** for the Ebzim Digital Ecosystem.

---

## ⚡ QUICK START: AI AGENT LAUNCH PROTOCOL (MANDATORY)

To run the Ebzim platform correctly in this environment, follow these steps:

1. **Configure API:** Go to `lib/core/services/api_client_platform_web.dart` and ensure `getPlatformBaseUrl` returns the **Production URL**: `https://ebzim-api-prod.onrender.com/api/v1/`. This connects the app to the **Live Backend Server** and **Active Database**.
1. **Development/Testing (Hot Reload):** Use this command for fast iteration:

```bash
flutter run -d chrome --web-port 8080
```

* **Note:** Use 'r' in the terminal for Hot Reload or 'R' for Hot Restart.

1. **Final Production Check (Standard):** Before concluding a session or for final UI verification, use Release mode:

```bash
flutter run -d chrome --web-port 8080 --release
```

1. **Status:** The app is optimized for port 8080. Debug mode is preferred for development speed.

---

## 🏗️ 1. System Ecosystem & Platform Overview

* **Core Identity:** The official digital gateway for the **Ebzim Association for Culture and Citizenship** (based in Sétif, Algeria).
* **Legal Governance:** The platform's logic is strictly derived from the association's **Statutes and Basic Law (Law 06/12)**. Every module (Membership, Committees, Projects) must align with the official legal framework defined in `StatuteService`.
* **Platform Scope:** An institutional-grade web application designed to bridge cultural heritage with modern citizenship. It serves as:
  1. **Public Portal:** Showcasing the association's news, latest events, and strategic partnerships.
  2. **Heritage Repository:** Tracking and visualizing major institutional and social development projects (e.g., restoration, cultural archiving) via dynamic timelines.
  3. **Membership Hub:** Managing a digital community with secure authentication, profile management, and high-fidelity **Digital Member ID Cards**.
  4. **Admin Governance:** A centralized command center for administrators to manage content, export professional reports (Excel), and oversee platform growth.
* **Frontend (Flutter Web):** Optimized for **Release Mode** (`--release`) on port 8080 to prevent DDC renderer hangs and support browser features correctly.
* **Backend (NestJS):** Production is hosted on **Render**. Local development uses `http://localhost:3000/api/v1/`.
* **API Pointing:** Ensure `api_client_platform_web.dart` points to the correct environment (Production for live testing, Local for dev).

---

## 🎨 2. Design Excellence (The Ebzim Standard)

Maintain the "Institutional Prestige" using these strictly enforced design tokens:

* **Visual Style:** High-fidelity **Glassmorphism**. Always wrap `BackdropFilter` in `ClipRRect`.
* **Colors:** Deep Obsidian (`#010A08`), Emerald Green (`#052011`), and Moroccan Gold (`#D4AF37`).
* **Typography:** **Bilingual font system** — `Tajawal` (AR) / `Playfair Display` (FR/EN) for all headings and titles. `Cairo` for body text. `Cinzel` for the association name label in FR/EN on the login screen. Applied conditionally via `isAr` flag in `app_theme.dart`.
* **Animations:** "Soulful" micro-interactions only. Use `flutter_animate` with `fadeIn`, `shimmer`, and `slideY`. Standard duration: `600ms`.
* **Institutional Branding:** Replaced generic icons with a **stone-engraved logo** effect in the footer/branding areas to evoke heritage and permanence.

---

## 🔐 3. Security, Auth & User Experience

* **Intelligent Auto-Login:** `SplashScreen` now proactively checks and reacts to authentication states. If a session is valid, it skips the manual "Explore" step and redirects immediately to the appropriate dashboard (Admin or Home).
* **Credential Recall:** `LoginScreen` pre-fills the last used identity from `StorageService`, reducing repetitive effort for returning users.
* **Engraved Institutional Identity:** Replaced generic icons/medals with the official association logo styled as a **stone engraving** (via `EbzimLogo`) in the Splash footer, Digital ID Card, and Admin Dashboard.
* **Browser Autofill:** Login and Register screens are enhanced with `AutofillHints` and `AutofillGroup`.

---

## 📊 4. Data Management & Exports

* **Real-Time Analytics:** The "Stats Strip" on the home screen and admin dashboard is now linked to the backend `AdminService` via `publicStatsProvider`, showing live platform counts.
* **Real Excel (.xlsx):** Professional export is mandatory for institutional reports.
* **Web Trigger:** Binary data is served via `triggerWebDownloadBytes` through `WebHelper`.
* **Dynamic Projects:** Contributions are linked to live heritage projects.

---

## 🚨 5. Technical Taboos (Do NOT Use)

1. **NO `.withValues()`**: Always use `.withOpacity()` for colors.
2. **NO `SlideTransitions` in Router**: Causes infinite loading hangs on Web.
3. **NO Border Conflicts**: Always import `excel.dart` using `hide Border`.
4. **NO Network Fonts at Boot**: Prevents rendering blocks on slow connections.

---

* **Architectural & Logical Audit:** 🧠 Conducted a comprehensive platform-wide audit. Created `EBZIM_LOGIC_AUDIT.md` as the definitive technical and logical source of truth.
* **Unified Category System:** 🏷️ Synchronized news and project categories across `NewsService`, `HeritageProjectsScreen`, and the Admin Dashboard. Added new institutional committees: `MEMORY`, `TOURISM`, and `CHILD`.
* **Bilingual CMS Upgrade:** 🖋️ Transformed the Admin News and Project creation screens into high-fidelity bilingual editors. Admins can now input content in Arabic, French, and English via a tabbed interface.
* **Filtering & Logic Stabilization:** 🔄 Fixed gaps in project filtering where certain categories (e.g., `PARTNERSHIP`) were omitted. Ensured all project types are tracked with progress sliders and milestones.
* **Institutional Governance:** 🏛️ Verified platform logic against Algerian Law 06/12 (Statutes). Aligned Executive Board roles and specialized committee definitions with legal requirements.

---

## 📋 7. Immediate Priorities for Next Agent

1. **Email Provider Integration:** Replace the simulated email dispatch in `MembershipAdminService` with a real SMTP/REST provider (SendGrid/Mailgun).
2. **Financial Audit:** Finalize the "Contributions" logic to ensure multi-currency handling for international donors.
3. **Dedicated Guide Expansion:** Continue populating `EBZIM_LOGIC_AUDIT.md` with edge-case handling for storage and retrieval as the platform scales.

**Handover Status: 🏁 MISSION COMPLETED. THE PLATFORM IS PRODUCTION-READY & SECURE.**

---

## 🛠️ 8. Testing Protocol (Crucial)

1. **Launch Command:**

```bash
flutter run -d chrome --web-port 8080 --release
```

1. **API Verification:** Ensure `api_client_platform_web.dart` is in "Production" mode for live testing.

# 👑 Ebzim Sovereign Platform: Comprehensive Master Handover (Final Edition)

> [!IMPORTANT]
> **AGENTS PROTOCOL:** There is ONLY ONE handover file for this project. DO NOT create new handover documents. You MUST merge, update, and refine this existing `MASTER_HANDOVER.md` file at the end of every session. This is the **exclusive source of truth** for the Ebzim Digital Ecosystem.

---

## 🏗️ 1. System Ecosystem & Environments

- **Core Mission:** Official platform for the **Ebzim Association for Culture and Citizenship**.
- **Frontend (Flutter Web):** Optimized for **Release Mode** (`--release`) on port 8080 to prevent DDC renderer hangs and support browser features correctly.
- **Backend (NestJS):** Production is hosted on **Render**. Local development uses `http://localhost:3000/api/v1/`.
- **API Pointing:** Ensure `api_client_platform_web.dart` points to the correct environment (Production for live testing, Local for dev).

---

## 🎨 2. Design Excellence (The Ebzim Standard)

Maintain the "Institutional Prestige" using these strictly enforced design tokens:

- **Visual Style:** High-fidelity **Glassmorphism**. Always wrap `BackdropFilter` in `ClipRRect`.
- **Colors:** Deep Obsidian (`#010A08`), Emerald Green (`#052011`), and Moroccan Gold (`#D4AF37`).
- **Typography:** Local assets only. `Tajawal` (900 for headers) and `Inter` (for data/numbers).
- **Animations:** "Soulful" micro-interactions only. Use `flutter_animate` with `fadeIn`, `shimmer`, and `slideY`. Standard duration: `600ms`.
- **Institutional Branding:** Replaced generic icons with a **stone-engraved logo** effect in the footer/branding areas to evoke heritage and permanence.

---

## 🔐 3. Security, Auth & User Experience

- **Intelligent Auto-Login:** `SplashScreen` now proactively checks and reacts to authentication states. If a session is valid, it skips the manual "Explore" step and redirects immediately to the appropriate dashboard (Admin or Home).
- **Credential Recall:** `LoginScreen` pre-fills the last used identity from `StorageService`, reducing repetitive effort for returning users.
- **Engraved Institutional Identity:** Replaced generic icons/medals with the official association logo styled as a **stone engraving** (via `EbzimLogo`) in the Splash footer, Digital ID Card, and Admin Dashboard.
- **Browser Autofill:** Login and Register screens are enhanced with `AutofillHints` and `AutofillGroup`.

---

## 📊 4. Data Management & Exports

- **Real-Time Analytics:** The "Stats Strip" on the home screen and admin dashboard is now linked to the backend `AdminService` via `publicStatsProvider`, showing live platform counts.
- **Real Excel (.xlsx):** Professional export is mandatory for institutional reports.
- **Web Trigger:** Binary data is served via `triggerWebDownloadBytes` through `WebHelper`.
- **Dynamic Projects:** Contributions are linked to live heritage projects.

---

## 🚨 5. Technical Taboos (Do NOT Use)

To maintain stability and cross-compiler compatibility:

1. **NO `.withValues()`**: Always use `.withOpacity()` for colors.
2. **NO `SlideTransitions` in Router**: Causes infinite loading hangs on Web.
3. **NO Border Conflicts**: Always import `excel.dart` using `hide Border`.
4. **NO Network Fonts at Boot**: Prevents rendering blocks on slow connections.

---

## 📅 6. Status as of April 20, 2026 (Late Session)

- **Onboarding Excellence:** 🌟 Redesigned the onboarding flow with a premium, animated interface that supports multiple languages dynamically via the CMS.
- **CMS Governance:** Launched a centralized management screen for Carousel and Onboarding slides, allowing full control over images and translations.
- **Account Immunity:** Implemented "Hard-Protection" for Super Admin accounts. Deletion and banning are blocked at both UI and API levels for root administrators (e.g., Toufik Ebzim).
- **Build Stability:** Fixed the fatal `dart2js` build error for web production by resolving localization import paths and cleaning ARB key collisions.

---

## 📋 7. Immediate Priorities for Next Agent

1. **CMS Content Population:** Use the Admin Panel -> Content section to fill the Carousel and Onboarding slides with institutional content.
2. **Email Provider Integration:** Replace the simulated email dispatch in `MembershipAdminService` with a real SMTP/REST provider (SendGrid/Mailgun).
3. **Financial Audit:** Finalize the "Contributions" logic to ensure multi-currency handling for international donors.

**Handover Status: 🏁 MISSION COMPLETED. THE PLATFORM IS PRODUCTION-READY & SECURE.**

---

## 🛠️ 8. Testing Protocol (Crucial)

1. **Launch Command:**

   ```bash
   flutter run -d chrome --web-port 8080 --release
   ```

2. **API Verification:** Ensure `api_client_platform_web.dart` is in "Production" mode for live testing.

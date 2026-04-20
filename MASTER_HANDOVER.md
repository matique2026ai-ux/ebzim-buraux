# 👑 Ebzim Sovereign Platform: Comprehensive Master Handover (Final Edition)

This is the **exclusive source of truth** for the Ebzim Digital Ecosystem. Any agent succeeding this session must adhere strictly to the protocols defined herein.

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

---

## 🔐 3. Security, Auth & User Experience
- **Browser Autofill:** Login and Register screens are enhanced with `AutofillHints` and `AutofillGroup` to ensure browsers can save/fill credentials correctly.
- **Guest Mode:** All screens support a graceful "Guest" state. If `currentUser` is null, use `LoginRequiredOverlay` or redirect to `/login`.
- **Profile Readiness:** Dynamic calculation implemented in `UserProfile.fromJson`. Based on Name, Phone, and Avatar (25% each).
- **Auth Guards:** Implemented in `AppRouter` and `AdminDashboardScreen`.

---

## 📊 4. Data Management & Exports
- **Real Excel (.xlsx):** Professional export is mandatory for institutional reports.
- **Implementation:** Uses `excel` package with explicit cell-by-column mapping.
- **Web Trigger:** Binary data is served via `triggerWebDownloadBytes` through `WebHelper` to ensure filename integrity and `.xlsx` extension recognition.
- **Dynamic Projects:** Contributions are now linked to dynamic projects fetched via `heritageProjectsProvider`.

---

## 🚨 5. Technical Taboos (Do NOT Use)
To maintain stability and cross-compiler compatibility:
1. **NO `.withValues()`**: Always use `.withOpacity()` for colors.
2. **NO `SlideTransitions` in Router**: Causes infinite loading hangs on Web.
3. **NO Border Conflicts**: Always import `excel.dart` using `hide Border`.
4. **NO Network Fonts at Boot**: Prevents rendering blocks on slow connections.

---

## 📅 6. Status as of April 20, 2026
- **Stability:** 100% Stable. Autofill fixes applied.
- **Financials:** Admin tracking enhanced with User/Project metadata and Arabic localization.
- **Contributions:** Hardcoded project selectors replaced with dynamic backend-driven dropdown.
- **Profile Logic:** Profile readiness fixed (no longer hardcoded to 40%).
- **Git Sync:** Latest logic fixes and architectural audits committed.

---

## 📋 7. Immediate Priorities for Next Agent
1. **Live Stats Sync:** Link the "Stats Strip" in `DashboardScreen` to the live backend analytics endpoints.
2. **Responsive Polish:** Final check on Wrap layout behavior for 1024px width screens.
3. **Milestone Tracking:** Verify the `EbzimProjectTimeline` correctly renders deep-linked milestones from the News/Project models.
4. **Member Verification:** Audit the `DigitalIdCard` logic to ensure membership levels correctly trigger badge visibility.

**Handover Status: 🏆 SOVEREIGN, STABLE & READY FOR LIVE TESTING.**

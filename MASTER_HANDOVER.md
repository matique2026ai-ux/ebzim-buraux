# 👑 Ebzim Sovereign Platform: Comprehensive Master Handover (Final Edition)

This is the **exclusive source of truth** for the Ebzim Digital Ecosystem. Any agent succeeding this session must adhere strictly to the protocols defined herein.

---

## 🏗️ 1. System Ecosystem & Environments
- **Core Mission:** Official platform for the **Ebzim Association for Culture and Citizenship**.
- **Frontend (Flutter Web):** Optimized for **Release Mode** (`--release`) on port 8080 to prevent DDC renderer hangs.
- **Backend (NestJS):** Currently running locally on `http://localhost:3000/api/v1/`. Production is hosted on **Render**.
- **Mobile Assets:** Final stable APKs (e.g., `ebzim-v4-final.apk`) are located in the project root for reference.

---

## 🎨 2. Design Excellence (The Ebzim Standard)
Maintain the "Institutional Prestige" using these strictly enforced design tokens:
- **Visual Style:** High-fidelity **Glassmorphism**. Always wrap `BackdropFilter` in `ClipRRect`.
- **Colors:** Deep Obsidian (`#010A08`), Emerald Green (`#052011`), and Moroccan Gold (`#D4AF37`).
- **Typography:** Local assets only. `Tajawal` (900 for headers) and `Inter` (for data/numbers).
- **Animations:** "Soulful" micro-interactions only. Use `flutter_animate` with `fadeIn`, `shimmer`, and `slideY`. Standard duration: `600ms`.

---

## 🔐 3. Security, Auth & Guest Experience
- **Guest Mode:** All screens support a graceful "Guest" state. If `currentUser` is null, use `LoginRequiredOverlay` or redirect to `/login`.
- **Auth Guards:** Implemented in `AppRouter` and `AdminDashboardScreen`.
- **Admin Privilege:** Super Admin level is required for Financials and System Settings.

---

## 📊 4. Data Management & Exports
- **Real Excel (.xlsx):** Professional export is mandatory for institutional reports.
- **Implementation:** Uses `excel` package with explicit cell-by-column mapping.
- **Web Trigger:** Binary data is served via `triggerWebDownloadBytes` (Base64/Blob hybrid) to ensure filename integrity and `.xlsx` extension recognition.

---

## 🚨 5. Technical Taboos (Do NOT Use)
To maintain stability and cross-compiler compatibility:
1. **NO `.withValues()`**: Always use `.withOpacity()` for colors.
2. **NO `SlideTransitions` in Router**: Causes infinite loading hangs on Web.
3. **NO Border Conflicts**: Always import `excel.dart` using `hide Border`.
4. **NO Network Fonts at Boot**: Prevents rendering blocks on slow connections.

---

## 📅 6. Status as of April 19, 2026
- **Stability:** 100% Stable. All DDC compiler and name conflict errors resolved.
- **Home UI:** Fully overhauled (Stats, Projects, News, About).
- **Admin Flow:** Excel export refined and verified to open in separate columns.
- **Git Sync:** Latest code pushed to `origin/main`.

---

## 📋 7. Immediate Priorities for Next Agent
1. **Live Stats Sync:** Link the "Stats Strip" to the live backend analytics endpoints.
2. **Responsive Polish:** Final check on Wrap layout behavior for 1024px width screens.
3. **Milestone Tracking:** Ensure the `EbzimProjectTimeline` correctly renders deep-linked milestones from the News/Project models.

**Handover Status: 🏆 SOVEREIGN, STABLE & READY FOR PRODUCTION.**

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
- **Super Admin Sovereignty:** Enforced "Sole Supervisor" policy. Only `matique2025` retains Super Admin status; system-generated accounts are demoted to Admin in the UI.
- **Membership Lifecycle:** Integrated automated user notifications and email triggers into the membership review workflow.
- **Navigation Architecture:** Implemented "State Cleanup" using `context.go()` for administrative transitions to prevent memory accumulation.
- **CMS Synchronization:** Fixed state persistence issues where CMS changes weren't instantly reflected on the Home Screen.

---

## 📋 7. Immediate Priorities for Next Agent
1. **Live Stats Sync:** Link the "Stats Strip" in `DashboardScreen` to the live backend analytics endpoints.
2. **Member Verification:** Audit the `DigitalIdCard` logic to ensure membership levels correctly trigger badge visibility.
3. **Email Provider Integration:** Replace the simulated email dispatch in `MembershipAdminService` with a real SMTP/REST provider.
4. **Clean Navigation Audit:** Continue auditing `context.push` usage to ensure absolute screen disposal across all administrative modules.

**Handover Status: 🏆 SOVEREIGN, STABLE & READY FOR LIVE TESTING.**

---

## 🛠️ 8. Testing Protocol (Crucial)
The platform is currently optimized for **LIVE Production Testing**.

### 🌍 Primary: Live Production Testing
1. **API Pointing:** Ensure `lib/core/services/api_client_platform_web.dart` returns the production Render URL.
2. **Launch Command:**
   ```bash
   flutter run -d chrome --web-port 8080 --release
   ```
   *Note: Port 8080 is mandatory for consistent web session handling.*

### 💻 Secondary: Local Development Testing (Optional)
1. **API Pointing:** Switch `api_client_platform_web.dart` to `localhost:3000`.
2. **Backend:** Run `npm run start:dev` in the `backend` folder.
3. **Seeding:** Use `npx ts-node scripts/seed.ts` if the DB is empty.
4. **Launch:** Same as above (`--release` mode still recommended).

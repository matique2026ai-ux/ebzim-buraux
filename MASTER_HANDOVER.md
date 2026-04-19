# 👑 Ebzim Sovereign Platform: Master Handover & Source of Truth (April 2026)

This document is the **ONLY** reference required for any agent taking over the Ebzim project. It contains the full architectural context, critical stability rules, and the current state of the platform.

---

## 🏗️ 1. Global Architecture Overview
The Ebzim platform is a full-stack institutional system:
- **Frontend:** Flutter Web (optimised for Release Mode on port 8080).
- **Backend:** NestJS + MongoDB (Running locally on `http://localhost:3000/api/v1/`).
- **Core Mission:** A premium digital archive and management system for cultural heritage and citizenship.

---

## 🎨 2. The "Ebzim Premium" Standard (UI/UX)
Any UI update **MUST** follow these high-fidelity institutional rules:
- **Design Language:** Glassmorphism with deep obsidian backgrounds and emerald/gold accents.
- **Typography:** Mandatory use of `Tajawal` (Arabic) and `Inter` (Latin). Weights 700-900 for headers.
- **Animations:** Use `flutter_animate`. Durations must stay between `400ms` and `800ms`. Use "soulful" transitions (expanding underlines, subtle glows).
- **Stability Rule:** Avoid complex `SlideTransitions` in the Router; they cause web renderer hangs.

---

## 📊 3. Key Technical Features
### 🚀 Real Excel Export (.xlsx)
- **Logic:** Uses the `excel` package. Do not use CSV for official reports.
- **Implementation:** Binary downloads are handled via `triggerWebDownloadBytes` in `web_helper_web.dart`.
- **Formatting:** Data is explicitly mapped to columns (A, B, C...) to ensure it opens perfectly in Excel on Windows.

### 🗺️ Dynamic Project Timeline
- **Widget:** `EbzimProjectTimeline` (found in `core/common_widgets`).
- **Integration:** Directly linked to the Admin creation flow for milestones and progress tracking.

---

## 🚨 4. Critical Stability & Build Rules
### ✅ The "White Screen" Fix
If the web app hangs on a white screen:
1. Kill all Dart/Flutter processes: `taskkill /F /IM dart.exe ; taskkill /F /IM flutter.exe`
2. **ALWAYS** run in release mode: `flutter run -d web-server --web-port 8080 --release`

### ✅ API & Compatibility
- **API Client:** Configured in `api_client.dart` with platform-specific proxies in `api_client_platform_web.dart`.
- **Opacity:** Use `.withOpacity(...)` instead of `.withValues(...)` to ensure compatibility with the current DDC compiler.
- **Border Conflict:** When importing `excel.dart`, always use `hide Border` to avoid conflicts with Flutter's painting library.

---

## 📅 5. Current State & Latest Milestone (April 19, 2026)
- **Home Screen:** Fully overhauled with premium stats, artistic project cards, and news previews.
- **Admin Panel:** Fully functional user management with **Real Excel Export** and membership request review.
- **Stability:** Project is 100% stable, builds successfully, and all critical bugs are resolved.
- **Git:** All code is pushed to `origin/main`.

---

## 📋 6. Next Steps for the Agent
1. **Responsive Audit:** Ensure the new project cards scale elegantly on tablet-sized browsers.
2. **Backend Sync:** Verify live data integration for the "Stats Strip" (currently uses builder logic).
3. **Performance:** Monitor the `CustomScrollView` for any frame drops due to heavy animations.

**Status:** 🏆 **PREMIUM, STABLE & READY FOR CONTINUATION.**

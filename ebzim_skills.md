# 🧠 Ebzim App - Senior Context & Skills File
**Project:** Ebzim App (جمعية إبزيم للثقافة والمواطنة)
**Platform:** Flutter (Android/iOS) + Web (Compatible)
**Backend:** NestJS + MongoDB (REST API) — NO DOCKER
**Architecture:** Feature-First (Screaming Architecture)
**Database:** MongoDB — installed locally on the developer's machine

---

## 🏗️ 1. Architecture & State Management
- **State Management:** `flutter_riverpod` (v2.5.1). ALWAYS use `ConsumerWidget` or `ConsumerStatefulWidget`. Never use `setState` for global state.
- **Routing:** `go_router`. Use `context.go()` or `context.push()` with named routes. The app uses a `ShellRoute` for the main bottom navigation.
- **Structure:** Feature-First.
  - `lib/core/`: Reusable widgets, theme, routing, API client, localization.
  - `lib/features/`: Isolated features (auth, events, association, dashboard, members, membership, notifications, profile, settings, onboarding).
- **Backend Communication:** `dio` is used in `lib/core/services/api_client.dart`. It handles interceptors, tokens (via `flutter_secure_storage`), and platform-specific base URLs:
  - Physical Android Device: `http://YOUR_LOCAL_IP:3000`
  - Android Emulator: `http://10.0.2.2:3000`
  - Web: `http://localhost:3000`

## 👤 2. User Roles & Authentication
- The system supports **3 roles**: User (مستخدم عادي), Member (عضو), Admin (مشرف).
- Auth is handled via **JWT tokens** stored in `flutter_secure_storage`.
- Login is Email/Password ONLY. 
- **NO biometric/fingerprint login** — this feature is disabled and must NOT be added unless explicitly requested.
- A "طلب عضوية" (Request Membership) button must always be visible on the login screen.
- Role-based navigation: after login, the router checks the user's role and redirects accordingly.

## 🎨 3. UI / UX Design System (The "Stitch" & Premium Glassmorphism Aesthetic)
- **Theme:** Custom theme defined in `lib/core/theme/app_theme.dart`. ALWAYS use `Theme.of(context)` — never hardcode colors.
- **Primary Color:** Deep Green. **Secondary Color:** Light Emerald Green (used in Splash Screen background).
- **Glassmorphism:** Use the existing `GlassCard` widget in `lib/core/common_widgets/` for all card-like containers.
- **Buttons & Bars:** Use `PrimaryButton`, `EbzimAppBar`, and `EbzimSliverAppBar`. Do NOT recreate standard Flutter widgets.
- **Animations:** Use `flutter_animate` for all micro-interactions (`.animate().fade().slideY()`).
- **Language:** Multi-language (AR, EN, FR). Primary focus is **Arabic (RTL)**. Always use `Directionality`-safe padding/margin. Use `EdgeInsetsDirectional` instead of `EdgeInsets` for RTL safety.
- **Splash Screen:** Light Emerald green background with the association logo centered in a GlassCard. Arabic title + French subtitle.

## 🔌 4. Backend (NestJS — Local, No Docker)
- **Folder:** `ebzim-backend/`
- **Modules:** Auth (JWT), Users, Events, Categories, Memberships.
- **Database:** MongoDB — installed locally. Connection via `mongodb://127.0.0.1:27017/ebzim_db`
- **Environment file:** `ebzim-backend/.env` must ALWAYS contain:
  ```
  PORT=3000
  MONGODB_URI=mongodb://127.0.0.1:27017/ebzim_db
  JWT_SECRET=ebzim_super_secret_jwt_key_2026
  NODE_ENV=development
  ```
- **NEVER use Docker.** Run NestJS via `npm run start:dev` and MongoDB natively.

## 🚀 5. Critical Development Rules for AI Agent
1. **NEVER break Web Compatibility:** `dart:io` leakage in `api_client_platform.dart` was fixed before. NEVER import `dart:io` directly in UI files or shared logic.
2. **NO Dummy/Generic Code:** Always use the project's own widgets (`GlassCard`, `PrimaryButton`). Production-ready code only.
3. **RTL First:** All layouts must render correctly in Arabic (Right-to-Left).
4. **Read Before Write:** Before modifying any feature file, always read it first (`cat` or view) to understand the existing Riverpod providers and GoRouter path structure.
5. **NEVER refactor folder structure without explicit permission.** The current folder structure is final.
6. **NEVER use Docker** for the backend under any circumstances.
7. **NEVER add biometric login** unless explicitly asked.
8. **Zero Errors Policy:** Before running or testing the app, run `dart analyze` and fix all errors. Do not proceed with a broken codebase.

## 📋 6. Current Screen Status
| Feature | Screen | Status |
| :--- | :--- | :--- |
| Onboarding | Splash + Slider | ✅ Implemented |
| Auth | Login (Email/Password, No Biometrics) | ✅ Implemented |
| Auth | Register | ✅ Implemented |
| Navigation | Main Shell (Bottom Nav) | ✅ Implemented |
| Association | Home, About | ✅ Implemented |
| Events | List + Detail Page | ✅ Implemented |
| User | Dashboard, Profile | ✅ Implemented |
| Membership | Application Flow | ✅ Implemented |
| Admin | Dashboard | 🔲 Pending |

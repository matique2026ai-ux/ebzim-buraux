# 👑 Ebzim Sovereign Platform — Comprehensive Master Handover

> [!IMPORTANT]
> **AGENTS PROTOCOL:** There is ONLY ONE handover file for this project. DO NOT create new handover documents. You MUST merge, update, and refine this existing `MASTER_HANDOVER.md` at the end of every session. This is the **exclusive source of truth** for the Ebzim Digital Ecosystem.

---

## ⚡ QUICK START: AI AGENT LAUNCH PROTOCOL (MANDATORY)

**🚨 TO ALL FUTURE AI AGENTS: READ THIS ENTIRE SECTION BEFORE TOUCHING ANYTHING 🚨**

### Step 1 — Understand the Monorepo Structure

This is a **MONOREPO** containing both the frontend and backend:

```
c:\ebzim-buraux\
├── lib/                        ← Flutter Web (Frontend)
├── backend/                    ← NestJS API (Backend) ← DO NOT IGNORE THIS
│   ├── src/modules/            ← All API modules
│   └── src/modules/hero/       ← Example: Hero CMS module
├── MASTER_HANDOVER.md          ← YOU ARE HERE
└── render.yaml                 ← Render deployment config (backend)
```

> [!CAUTION]
> The backend at `c:\ebzim-buraux\backend\` is the **same repository**. Never tell the user "I cannot find the backend" — it is right here. Any change to the backend + `git push` triggers an automatic redeploy on Render.

### Step 2 — Configure API for Live Testing

Go to `lib/core/services/api_client_platform_web.dart` and ensure `getPlatformBaseUrl` returns the **Production URL**:

```
https://ebzim-api-prod.onrender.com/api/v1/
```

We always test against live data even in development mode.

### Step 3 — Clear Port 8080

Before running, ensure port 8080 is free (orphaned Dart processes block it):

```powershell
netstat -ano | findstr :8080
taskkill /PID <PID_NUMBER> /F
```

### Step 4 — Launch the App

```bash
flutter run -d chrome --web-port 8080
```

- Use `r` for Hot Reload, `R` for Hot Restart.
- Do not close the terminal while the user is testing.

### Step 5 — Final Production Verification

```bash
flutter run -d chrome --web-port 8080 --release
```

---

## 🏗️ 1. Project Identity & Platform Overview

| Field | Value |
|---|---|
| **Association** | Ebzim Association for Culture and Citizenship (جمعية إبزيم للثقافة والمواطنة) |
| **Type** | Provincial Association — Sétif, Algeria (Law 06/12) |
| **UNESCO Status** | Distinguished Member of the UNESCO Network in Algeria |
| **Platform Language** | Trilingual: Arabic (AR), French (FR), English (EN) |
| **Frontend** | Flutter Web (Dart) |
| **Backend** | NestJS (TypeScript) — `c:\ebzim-buraux\backend\` |
| **Database** | MongoDB Atlas (via Mongoose) |
| **Media Storage** | Cloudinary |
| **Production Hosting** | Render (auto-deploy from `main` branch via `git push`) |
| **Frontend Dev Port** | **8080 (FIXED — never change this)** |
| **Backend Local Dev** | `http://localhost:3000/api/v1/` (run `npm run start:dev` inside `/backend`) |
| **Production API** | `https://ebzim-api-prod.onrender.com/api/v1/` |

### Platform Roles

The platform serves 4 audiences:

1. **Public Portal** — News, events, partnerships, institutional projects.
2. **Associative Hub** — Activity and project management with dynamic timelines.
3. **Membership Ecosystem** — Secure auth, profiles, digital ID cards.
4. **Admin Governance** — CMS control, member management, Excel exports, reports.

---

## 🗂️ 2. Backend Architecture (NestJS — `c:\ebzim-buraux\backend\`)

### All Backend Modules (`backend/src/modules/`)

| Module | Purpose |
|---|---|
| `auth` | JWT-based authentication (Login, Register, OTP, Password Reset) |
| `users` | User profiles, roles (`SUPER_ADMIN`, `ADMIN`, `AUTHORITY`, `MEMBER`) |
| `memberships` | Membership applications, approval workflow, status tracking |
| `hero` | CMS for Home & Onboarding carousel slides |
| `partners` | Institutional partner management with branding colors |
| `leadership` | Executive board member management |
| `posts` | News & institutional project posts (trilingual) |
| `events` | Event creation and management |
| `contributions` | Financial contributions linked to projects |
| `categories` | Shared category taxonomy for posts/projects |
| `media` | Cloudinary image upload service |
| `admin` | Admin dashboard stats, member management actions |
| `reports` | Excel export generation for admin |
| `settings` | Platform-level configuration |
| `institutions` | Institution records (shared `MultilingualText` schema) |
| `mail` | Email dispatch (currently simulated — needs real SMTP) |

### Key Backend Rules

- **Validation:** `ValidationPipe` with `whitelist: true` is active globally. Any field sent from Flutter that is **not declared in the DTO** will be silently stripped. Always verify DTOs when adding new fields.
- **Update Pattern:** Always use `{ $set: dto }` in `findByIdAndUpdate` to guarantee correct field-level updates in MongoDB.
- **Schema Defaults:** All optional design fields in `HeroSlide` schema have defaults (`glassColor: '#000000'`, `overlayOpacity: 0.1`).
- **Redeploy:** Backend changes go live automatically after `git push` to `main` (Render auto-deploy). Wait ~3–5 minutes for the new build.

---

## 📱 3. Frontend Architecture (Flutter Web — `c:\ebzim-buraux\lib\`)

### Key Screens (`lib/screens/`)

| Screen | Route | Notes |
|---|---|---|
| `splash_screen.dart` | `/` | Auto-login check — redirects to admin or home if session is valid |
| `language_selection_screen.dart` | `/lang` | First-run language picker |
| `onboarding_slider_screen.dart` | `/onboarding` | Intro slides (uses `HeroSlide` with `location: ONBOARDING`) |
| `login_screen.dart` | `/login` | Pre-fills last used credential |
| `register_screen.dart` | `/register` | Registration with OTP |
| `home_screen.dart` | `/home` | Main public portal with Hero carousel, stats, news, projects |
| `admin_dashboard_screen.dart` | `/admin` | Full admin control center |
| `admin_cms_manage_screen.dart` | `/admin/cms/...` | CMS CRUD for Hero, Partners, Leadership, Onboarding |
| `admin_create_news_screen.dart` | `/admin/news/create` | Trilingual news/project editor |
| `admin_create_project_screen.dart` | `/admin/project/create` | Project with milestones timeline |
| `dashboard_screen.dart` | `/dashboard` | Member personal dashboard |
| `profile_screen.dart` | `/profile` | Member profile + Digital ID Card |
| `heritage_projects_screen.dart` | `/heritage` | All institutional projects |
| `membership_flow_screen.dart` | `/membership` | Membership application flow |
| `contributions_screen.dart` | `/contributions` | Financial contributions |
| `news_screen.dart` | `/news` | News listing |
| `activities_screen.dart` | `/activities` | Events listing |

### Key Services (`lib/core/services/`)

| Service | Purpose |
|---|---|
| `api_client.dart` | Central Dio HTTP client with JWT interceptors |
| `api_client_platform_web.dart` | **Edit this to switch between Production/Local API** |
| `auth_service.dart` | Authentication logic and Riverpod providers |
| `cms_content_service.dart` | Hero slides, partners, leadership CRUD |
| `news_service.dart` | Posts and projects (with category filtering) |
| `event_service.dart` | Events CRUD |
| `member_service.dart` | Member management for admins |
| `media_service.dart` | Cloudinary upload |
| `public_stats_service.dart` | Live platform stats (member count, etc.) |
| `storage_service.dart` | Local storage (SharedPreferences) |
| `statute_service.dart` | Algerian Law 06/12 statutes |
| `web_helper_web.dart` | Web-only file download trigger |

---

## 🎨 4. Design System (The Ebzim Institutional Standard)

> [!IMPORTANT]
> All new UI components MUST follow these rules. Deviating from them is unacceptable.

- **Visual Style:** High-fidelity **Glassmorphism**. Always wrap `BackdropFilter` in `ClipRRect`.
- **Background:** Use `EbzimBackground` widget for all admin and public screens.
- **Cards:** Use `GlassCard` widget — never raw `Container` with manual glass effects.
- **Colors:**
  - Deep Obsidian: `#010A08`
  - Emerald Green: `#052011`
  - Moroccan Gold / Accent: `#D4AF37`
- **Typography (Bilingual):**
  - Arabic: `Tajawal` (headings) / `Cairo` (body)
  - French/English: `Playfair Display` (headings) / system (body)
  - Login screen association name: `Cinzel`
  - Applied via `isAr` flag in `app_theme.dart`
- **Animations:** Use `flutter_animate` — `fadeIn`, `shimmer`, `slideY`. Duration: `600ms` standard.
- **Logo:** `EbzimLogo` widget — stone-engraved style. Used in Splash, Admin Dashboard, Digital ID Card.
- **Hero Carousel Design Fields:** Each `HeroSlide` has `glassColor` (hex string, e.g. `#8B0000`) and `overlayOpacity` (double 0.0–1.0) for per-slide gradient customization.

---

## 🔐 5. Security & Auth

- **JWT Auth:** Tokens stored via `StorageService`. Intercepted automatically by `ApiClient`.
- **Roles:** `SUPER_ADMIN` > `ADMIN` > `AUTHORITY` > `MEMBER`. `SUPER_ADMIN` accounts are protected — they cannot be deleted or demoted.
- **Auto-Login:** `SplashScreen` reads the stored JWT and redirects automatically on valid sessions.
- **Credential Recall:** `LoginScreen` pre-fills last used email from `StorageService`.
- **OTP Verification:** Used for registration and password reset flows.
- **Browser Autofill:** Both Login and Register use `AutofillHints` and `AutofillGroup`.

---

## 🚨 6. Technical Taboos (NEVER Do These)

1. **NO `.withValues()`** — Always use `.withOpacity()` for colors.
2. **NO `SlideTransition` in Router** — Causes infinite loading hangs on Flutter Web.
3. **NO `import 'excel.dart'` without hiding Border** — Always: `import 'package:excel/excel.dart' hide Border;`
4. **NO Google Fonts loaded at boot over the network** — Pre-bundle or use `GoogleFonts.config.allowRuntimeFetching = false` carefully.
5. **NO raw `findByIdAndUpdate(id, dto)` in Mongoose** — Always use `findByIdAndUpdate(id, { $set: dto }, { new: true })`.
6. **NO new handover documents** — Only update THIS file.

---

## 📋 7. CMS Module — Special Notes

The CMS (`admin_cms_manage_screen.dart`) manages 4 content types via `CMSManageType`:

| Type | Schema | Backend Route |
|---|---|---|
| `hero` | `HeroSlide` | `PATCH /hero-slides/:id` |
| `onboarding` | `HeroSlide` (location: ONBOARDING) | `PATCH /hero-slides/:id` |
| `partner` | `Partner` | `PATCH /partners/:id` |
| `leadership` | `EbzimLeader` | `PATCH /leadership/:id` |

**Important CMS fixes already applied (April 2026):**

- `_initData` now correctly handles both `hero` AND `onboarding` types (previously only `hero`).
- `overlayOpacity` is parsed robustly from both `String` and `double` backend responses.
- `glassColor` hex normalization handles `#` prefix presence/absence.
- Backend `hero.service.ts` now uses `{ $set: dto }` to correctly persist `glassColor` and `overlayOpacity`.

---

## 📊 8. Data Management & Logic Synchronization (April 2026 Audit)

- **Synchronized Categories:** News and Projects now share a unified taxonomy. Categories: `ANNOUNCEMENT`, `HERITAGE`, `PROJECT`, `RESTORATION`, `CULTURAL`, `SCIENTIFIC`, `ARTISTIC`, `PARTNERSHIP`, `EVENT_REPORT`, `MEMORY`, `TOURISM`, `CHILD`.
- **Project Visibility Logic:** `heritageProjectsProvider` and the Admin Dashboard `_ProjectsTab` now share the exact same filter set (includes `PARTNERSHIP` and `EVENT_REPORT` as institutional initiatives).
- **Independent Trilingual Input:** `AdminCreateNewsScreen` and `NewsService` have been upgraded to support independent entry for Arabic, French, and English. The previous "Arabic-to-all" cloning logic has been removed. Empty fields now remain empty rather than being overwritten by Arabic fallbacks.
- **Excel Export:** Admin can export member lists to `.xlsx`. Uses the `excel` package (with `hide Border`). Data served via `WebHelper.triggerWebDownloadBytes`.
- **Financial Contributions:** Linked to projects. Payment receipts tracked.
- **Live Stats:** `publicStatsProvider` feeds the `StatsStrip` widget on both Home and Admin screens.

---

## 🛠️ 9. Deployment & Git Workflow

```
Developer Machine
       │
       │ git push origin main
       ▼
GitHub (matique2026ai-ux/ebzim-buraux)
       │
       ├──▶ Render (Backend auto-deploy — wait 3–5 min)
       │       rootDirectory: backend
       │       build: npm install && npm run build
       │       start: npm run start:prod
       │
       └──▶ Flutter Web (Manual build or dev mode on port 8080)
```

**Environment Variables on Render (set in dashboard, never commit):**

- `MONGODB_URI` — MongoDB Atlas connection string
- `JWT_SECRET` — Auth signing key
- `JWT_EXPIRES_IN` — `7d`
- `CLOUDINARY_CLOUD_NAME` / `CLOUDINARY_API_KEY` / `CLOUDINARY_API_SECRET`
- `MAIL_HOST` / `MAIL_USER` / `MAIL_PASS`

---

## 📌 10. Immediate Priorities for the Next Agent

1. **✅ [DONE] Branding Standardization:** The platform identifier has been condensed to **"EBZIM"** (إبزيم) across all UI widgets for a premium minimalist aesthetic. Formal names remain in legal docs.
2. **✅ [DONE] Model Restoration:** Missing `NewsPost` and `ProjectMilestone` models in `lib/core/models/news_post.dart` have been reconstructed and restored to the repo.
3. **✅ [DONE] SMTP Readiness:** `MailModule` is hardened. Next step: replace with institutional SMTP (SendGrid).
4. **✅ [DONE] Multi-currency Support:** DZD, EUR, and USD supported.
5. **Institutional Badges:** Verify `UserProfile` status labels and badges strictly follow the `StatuteService` hierarchy (Next Priority).

---

**Handover Status: 🔄 IN ACTIVE DEVELOPMENT — Last updated: April 22, 2026**
**Current State: App running on Chrome port 8080. Latest changes pushed to GitHub.**

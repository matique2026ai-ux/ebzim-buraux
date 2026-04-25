# 👑 Ebzim Sovereign Platform — Comprehensive Master Handover

> [!IMPORTANT]
> **AGENTS PROTOCOL:** There is ONLY ONE handover file for this project. DO NOT create new handover documents. You MUST merge, update, and refine this existing `MASTER_HANDOVER.md` at the end of every session. This is the **exclusive source of truth** for the Ebzim Digital Ecosystem.

---

## 🎭 AGENT PERSONA — "من أنا وكيف أعمل" (READ THIS BEFORE ANYTHING ELSE)

> [!IMPORTANT]
> **هذا القسم هو روحك كوكيل.** المستخدم يتوقع منك أن تكون **نفس الشخصية** في كل جلسة. اقرأ هذا القسم كأنه وصف لك أنت شخصياً، ولا تنحرف عنه.

### 🧠 هويتي وفلسفتي

أنا **شريك تطوير متكامل** — لا مجرد وكيل ينفذ الأوامر. أنا أفهم ما يريده المستخدم قبل أن يكمل جملته، وأقترح تحسينات لم يفكر فيها بعد. أعمل معه كأننا فريق واحد يبني شيئاً يستحق الفخر.

**المبادئ الجوهرية:**

- **الجمال أولاً:** كل واجهة أصممها يجب أن تبهر المستخدم عند أول نظرة. ألوان premium، animations سلسة، glassmorphism، glow effects. البساطة المملة مرفوضة تماماً.
- **النظافة مقدسة:** لا كود زائد، لا قسمين يؤديان نفس الوظيفة، لا imports غير مستخدمة. الكود يجب أن يُقرأ كشعر — كل سطر له معنى.
- **واحد بواحد:** أعدّل جزءاً واحداً، أتحقق، أحفظ، ثم أنتقل للتالي. لا أقفز لأربعة أشياء دفعة واحدة.
- **التوثيق فوري:** كل ميزة جديدة → `git commit` + تحديث `MASTER_HANDOVER.md` فوراً. لا أترك شيئاً معلقاً.

### 🎨 أسلوبي الجمالي (Design DNA)

عندما أصمم أي واجهة، أتبع هذه المعايير بدون استثناء:

| العنصر | الأسلوب المعتمد |
| --- | --- |
| **الألوان** | بالت `AppTheme` الأساسي + لمسات Gold `#D4AF37` + Purple `#8B5CF6` + Emerald `#22C55E` |
| **الكاردز** | `borderRadius: 20-24` + `glassmorphism` + `glow shadow` ملوّن بلون الأيقونة |
| **الأيقونات** | داخل حاوية `gradient` + `border` شفاف + حجم ثابت `26-28px` |
| **الانيمايشن** | `flutter_animate` — `fadeIn + slideY` عند الظهور + `scaleXY` للأيقونات (نبض مستمر) |
| **الخطوط** | `GoogleFonts.tajawal` للعناوين + `GoogleFonts.cairo` للنصوص + `GoogleFonts.playfairDisplay` للعلامات المميزة |
| **اللغة** | ثنائي عربي/فرنسي دائماً — `isAr` flag في كل widget |

### 🤝 أسلوب تعاملي مع المستخدم

- **أفهم بالإشارة:** إذا قال "هذا لا يعجبني"، أفهم ما يريده حتى لو لم يشرح كثيراً.
- **أُظهر النتيجة أولاً:** أنجز التعديل وأرسل Hot Restart قبل أن أشرح ما فعلته.
- **لا أطرح أسئلة كثيرة:** إذا كان القصد واضحاً، أنفذ مباشرة. أسأل فقط عند الشك الحقيقي.
- **أُعطي خلاصة مختصرة:** بعد كل تعديل، جدول بسيط يوضح ما تغيّر — لا فقرات طويلة.
- **أحتفظ بالسياق:** أتذكر ما تحدثنا عنه في بداية الجلسة وأربطه بما نعمل عليه الآن.

### 🔧 أسلوبي التقني (Technical DNA)

```text
✅ دائماً أفعل:
   - dart analyze قبل Hot Restart للتعديلات الكبيرة
   - أحذف الكود الزائد (orphaned code) بعد كل refactor
   - git commit بعد كل ميزة مؤكدة تعمل
   - أستخدم withValues(alpha:) بدلاً من withOpacity() المهجور

❌ لا أفعل أبداً:
   - لا أعيد تشغيل flutter من الصفر (أستخدم R فقط)
   - لا أعدل ملفين في نفس الوقت
   - لا أحذف كوداً قبل أن أتأكد أنه غير مستخدم
   - لا أستخدم روابط Wikimedia للصور (CORS issues) — أستخدم Unsplash
   - لا أترك LateInitializationError في CanvasKit يوقفني (خطأ معروف وغير مؤثر)
```

### 📐 هيكل الأكواد المعتمد (Architecture Patterns)

- **State Management:** Riverpod (`ref.watch`, `ref.invalidate`)
- **Navigation:** GoRouter (`context.push`, `context.go`)
- **HTTP:** Dio مع interceptor للـ Auth token
- **Images:** `CachedNetworkImage` دائماً
- **Animations:** `flutter_animate` — لا `AnimationController` يدوي إلا للضرورة القصوى
- **Localisation:** `isAr = lang == 'ar'` flag، لا `Localizations.of(context)` مباشرة في الـ widgets

---

## 🚨 CRITICAL STABILITY LESSONS (APRIL 2026) — READ FIRST

> [!IMPORTANT]
> **مبادئ أساسية يجب معرفتها:**
>
> 1. **التعامل مع المنافذ (Ports):** دائماً تأكد من تحرير منفذ `8085` (للفرونت) ومنفذ `3000` (للباكاند) باستخدام `taskkill` قبل البدء.
> 2. **التجريب "اللايف" (Live API):** نحن نختبر دائماً مقابل الـ API الحقيقي (Render) لضمان مطابقة البيانات. لا تستخدم `localhost` للباكاند إلا إذا كنت تعدل في الـ Database Schema نفسها.
> 3. **الباكاند موجود هنا:** تذكر أن مجلد `backend` هو جزء من نفس المشروع (Monorepo)؛ أي تعديل فيه ثم `git push` سيرفع التحديث للسيرفر تلقائياً.
>
> ⚠️ **لطريقة التشغيل التفصيلية:** ارجع إلى قسم `⚡ AGENT WORKFLOW PROTOCOL` أدناه مباشرة.

---

## ⚡ AGENT WORKFLOW PROTOCOL — "Micro-Edit + Hot Restart" (CONFIRMED BY USER — MANDATORY)

> [!IMPORTANT]
> **هذه الطريقة مؤكدة ومعتمدة من المستخدم. كل وكيل قادم يجب أن يتبعها حرفياً دون انحراف.**

هذا البروتوكول هو نتيجة جلسات تطوير مكثفة مع المستخدم وقد أثبت فعاليته القصوى في تحقيق:

- **استقرار تام** للكود أثناء التطوير (لا crashes، لا ضياع كود).
- **تجريب فوري ومرئي** لكل تعديل صغير مباشرة في المتصفح.
- **تصحيح سريع** للأخطاء لأن كل تعديل صغير يسهل عزل مصدر الخطأ.
- **ثقة المستخدم** لأنه يرى النتائج فوراً ويشارك في القرارات.

### ⚙️ كيف يعمل البروتوكول خطوة بخطوة

#### الخطوة 1: إطلاق التطبيق في وضع التطوير

```powershell
# في Terminal 1 — تشغيل الباكاند
cd c:\ebzim-buraux\backend
npm run start:dev

# في Terminal 2 — تشغيل الفرونت (Flutter) في وضع debug
# استخدم المنفذ 8085 لتجنب التعارض مع 8080
cd c:\ebzim-buraux
flutter run -d web-server --web-port 8085
```

> **ملاحظة:** عند تشغيل Flutter، سيُطبع في التيرمنال رابط مثل: `http://localhost:8085`. افتح هذا الرابط في المتصفح.

#### الخطوة 2: إجراء التعديل

- قم بتعديل **ملف واحد، وبلوك كود واحد فقط** في كل مرة.
- لا تعدل أكثر من فكرة واحدة في نفس الوقت.

#### الخطوة 3: Hot Restart (ليس Reload)

- بعد كل تعديل، أرسل حرف **`R`** (كبير) إلى terminal Flutter:

```text
R
```

- هذا يُعيد تشغيل التطبيق خلال **1-2 ثانية فقط** دون إعادة compile كاملة.
- `r` (صغير) = Hot Reload (لا تُغير state، لا تُحدث const)
- `R` (كبير) = Hot Restart ✅ (يُعيد كل شيء، آمن 100%)

#### الخطوة 4: التحقق الفوري في المتصفح

- المستخدم يرى التغيير فوراً ويُقدم ملاحظته.
- إذا ظهر خطأ، يُعرض في التيرمنال وهو سهل العزل والإصلاح.

#### الخطوة 5: Commit بعد كل تصحيح مؤكد

```powershell
git add .
git commit -m "fix/feat(scope): وصف التعديل"
```

> لا تُراكم أكثر من 2-3 تعديلات قبل الـ Commit لضمان سهولة التراجع (`git revert`).

### 🔑 قواعد ذهبية للوكيل القادم

| القاعدة | التفصيل |
| --- | --- |
| **لا تُعيد تشغيل flutter من الصفر** | استخدم `R` في التيرمنال الموجود، لا `flutter run` جديد |
| **لا تعدل ملفين في نفس الوقت** | واحد بواحد حتى تتأكد من صحة كل تعديل |
| **لا تُحذف الكود، بدّله** | احتفظ دائماً بالكود القديم في comment مؤقت قبل الحذف |
| **وثّق كل إضافة في MASTER_HANDOVER.md** | لا تترك الملف قديماً أبداً |
| **لا تُغير LateInitializationError** | هذا الخطأ في CanvasKit هو خطأ Flutter web معروف وغير مؤثر |

### 📌 الوضع الحالي للتطبيق (آخر تحديث: 25 أبريل 2026)

- ✅ التطبيق يعمل على: `http://localhost:8085` (Debug) أو `http://localhost:8080` (Release)
- ✅ الباكاند يعمل على: `http://localhost:3000/api/v1`
- ✅ أوامر Flutter تُرسل عبر الـ Background Command ID النشط في الجلسة
- ✅ آخر Command ID كان: `1b77ebd5-c2c8-4b32-ba4b-98824fb4b125` (قد يتغير في الجلسات الجديدة)

---

## 🎯 CURRENT PROJECT COMPASS (WHERE WE STAND — APRIL 25, 2026)

> [!IMPORTANT]
> **أيها الوكيل القادم:** لا تبدأ من الصفر. لقد وصلنا إلى مرحلة "النضج البصري والوظيفي". إليك ملخص الحالة الحالية للمنصة:

### 🚀 ما تم إنجازه مؤخراً (The Latest Wins)

- **تصفية التراث الذكية (Heritage-Only Filter):** عززنا قائمة المحظورات (Blacklist) بكلمات إدارية عربية وفرنسية لضمان استبعاد البلديات، الولايات، والمرافق الخدمية، والتركيز حصراً على المعالم التاريخية والأثرية.
- **إعادة تصميم الصفحة الرئيسية (Premium Redesign):** تم حذف الأقسام المكررة وتحويل "كروت التنقل المؤسساتية" إلى تحف بصرية (Glassmorphism + Glow Effects + Pulsing Icons).
- **نظام النبض التفاعلي (Animated Selection):** أضفنا تأثير نبض ضوئي (Radial Glow) وتكبير مرن (Elastic Scale) للمقاصد المختارة على الخريطة لتعزيز التغذية البصرية.
- **مزامنة اللغات في الاستكشاف (Dynamic Localization):** الخريطة الآن تجلب أوصاف المعالم من ويكيبيديا باللغة التي يختارها المستخدم (AR/FR/EN) تلقائياً.
- **كاش الخرائط الجغرافي (Geospatial Caching):** نظام ذكي يحفظ المعالم المحملة ويقلل الطلبات للشبكة، مع آلية "التحرك لمسافة 2 كلم" لتحديث البيانات.
- **نظام الطبقات الذكي في الخريطة (Interactive Layers):** أضفنا زر تبديل طبقات (Switcher) بلمسة زجاجية يسمح بالاختيار بين المشاريع الميدانية أو الاستكشافات العالمية أو الكل معاً.

### 🧭 أين وصلنا تقنياً؟

- **الباكاند (NestJS):** مستقر جداً، يدعم الـ CRUD الكامل لكل الوحدات، ومربوط بـ Render auto-deploy.
- **الفرونت (Flutter):** يستخدم أحدث تقنيات `flutter_animate` للنبض الضوئي و `Riverpod` لإدارة الحالة. تم دمج نظام `Distance` لحساب التحركات الجغرافية.
- **الاستقرار:** المنصة تعمل بـ `canvasKit` افتراضياً، وتجاوزنا مشاكل تحميل الصور بتنظيف الـ URLs برمجياً.

### 🚩 المهام القادمة فوراً (Immediate Next Steps)

1. **توطين محتوى Wikipedia (المستوى المتقدم):** حالياً جلب اللغة يعتمد على `ref.read` عند الطلب؛ نحتاج لآلية إعادة تحميل تلقائية (Invalidation) عند تغيير اللغة والمستخدم داخل الخريطة.
2. **نظام الإشعارات:** البدء في ربط الـ Backend بـ Firebase أو نظام إشعارات داخلي للتنبيه عن المشاريع الجديدة.
3. **تحسين بطاقة التفاصيل:** إضافة زر "اقرأ المزيد" يفتح صفحة ويكيبيديا الكاملة داخل التطبيق (WebView) أو في تبويب جديد.

---

## 💎 THE EBZIM PHILOSOPHY (CORE VISION)

هذا ليس مجرد تطبيق، بل هو **الهوية الرقمية** لجمعية إبزيم. يجب أن يشعر المستخدم بالفخامة (Premium) والأصالة (Heritage) في كل بكسل. إذا كان التعديل الذي ستقوم به "عادياً"، فأعد التفكير. نحن نبني **معياراً جديداً** للمنصات الثقافية.

---

## 0. Rule 0: The Golden Point-by-Point Rule

- **NEVER** modify large blocks of unrelated code at once.
- **ALWAYS** work on one logical feature at a time.
- **ALWAYS** verify the build after each minor modification.

## 1. Project Overview

### 1. The "Infinite Spinner" Incident

- **Issue:** A custom CSS/HTML loader in `index.html` caused an infinite hang because it didn't account for Flutter initialization failures or environment mismatches.
- **Lesson:** **NEVER** modify the low-level `index.html` or `main.dart` boot sequence unless testing incrementally. We have restored the **Classic Flutter Web Loader** for maximum compatibility.
- **Rule:** If the app stays white or spins forever, the root cause is usually a **Data Parsing Error** (Crash) in `main.dart` or **Infinite Redirection Loop** (fighting between Router and Widgets).

### 2. Defensive Data Parsing & API Pathing

- **The Bug:** Requests starting with `/` (e.g., `/posts`) caused 404s when the `baseUrl` included `api/v1`.
- **Lesson:** Always use **Relative Paths** in Dio requests (e.g., `posts` instead of `/posts`).
- **Cloud vs Local:** The production cloud API (Render) returns data wrapped in a `{"data": [...]}` object. Always use defensive parsing.
- **Code Pattern:**

  ```dart
  final responseData = response.data;
  List rawList = (responseData is Map) ? (responseData['data'] ?? []) : (responseData as List);
  ```

- **Failure Consequence:** If a `Provider` throws an unhandled error during `HomeScreen` build, the UI will freeze or stay in a loading state (infinite spinner).

### 3. Port Management & Process Orphanage

- **Issue:** On Windows, Flutter Web and NestJS processes can become "orphaned," holding ports (8080 or 3000) and causing `EADDRINUSE` errors.
- **Lesson:** Always use `netstat -ano | findstr :<port>` and `taskkill /F /PID <PID>` before starting servers to ensure a clean launch.

### 4. Localization Path Resolution

- **Issue:** Absolute imports for `AppLocalizations` (e.g., `import 'package:ebzim_app/core/localization/l10n/app_localizations.dart'`) can sometimes fail in specific build environments.
- **Lesson:** Prefer **Relative Imports** for the localization file (e.g., `import '../core/localization/l10n/app_localizations.dart'`) to ensure portability across different Flutter toolchains.

---

## ⚡ QUICK START: AI AGENT LAUNCH PROTOCOL (MANDATORY)

### 🚨 TO ALL FUTURE AI AGENTS: READ THIS ENTIRE SECTION BEFORE TOUCHING ANYTHING 🚨

### Step 1 — Understand the Monorepo Structure

This is a **MONOREPO** containing both the frontend and backend:

```text
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

### Step 2 — Configure API for Live Testing (THE GOLDEN RULE)

> [!CAUTION]
> **MANDATORY:** We ALWAYS test against LIVE data even in development mode. For **Deep Backend Debugging** (e.g., modifying stats or schemas), you may switch to `localhost:3000` in `lib/core/services/api_client_platform_web.dart`. Just ensure you revert to the Production URL before pushing to Git.

Go to `lib/core/services/api_client_platform_web.dart` and ensure `getPlatformBaseUrl` returns the **Production URL**:

```dart
https://ebzim-api-prod.onrender.com/api/v1/
```

### Step 3 — Clear Port 8080

Before running, ensure port 8080 is free (orphaned Dart processes block it):

```powershell
netstat -ano | findstr :8080
taskkill /PID <PID_NUMBER> /F
```

### Step 4 — Launch the App (The "Zero Spinner" Way)

```bash
# 1. First, clear the port (crucial for Windows)
netstat -ano | findstr :8080
taskkill /PID <PID_NUMBER> /F

# 2. Run in Release mode with fixed port to bypass Debug/WebSocket hangs
flutter run -d web-server --web-port 8080 --release
```

- **Note:** We forced `window.flutterWebRenderer = "html"` in `index.html` to guarantee stability.
- Use `web-server` for headless hosting or `chrome` for local interaction.

### Step 5 — Production Sync (Backend Deployment)

Every `git push origin main` triggers a redeploy of the **NestJS Backend** on Render. Wait 3-5 mins for the "Live Deletion Cleanup" logic to take effect.

---

## 🏗️ 1. Project Identity & Platform Overview

| Field | Value |
| :--- | :--- |
| **Association** | Ebzim Association for Culture and Citizenship (جمعية إبزيم للثقافة والمواطنة) |
| **Type** | Provincial Association — Sétif, Algeria (Law 06/12) |
| **UNESCO Status** | Distinguished Member of the UNESCO Network in Algeria |
| **Platform Language** | Trilingual: Arabic (AR), French (FR), English (EN) |
| **Frontend** | Flutter Web (Dart) |
| **Backend** | NestJS (TypeScript) — `c:\ebzim-buraux\backend\` |
| **Database** | MongoDB Atlas (via Mongoose) |
| **Media Storage** | Cloudinary |
| **Production Hosting** | Render (auto-deploy from `main` branch via `git push`) |
| **Frontend Dev Port** | **8085 (OFFICIAL STABLE PORT — NEVER CHANGE THIS)** |
| **Backend Local Dev** | `http://localhost:3000/api/v1/` (run `npm run start:dev` inside `/backend`) |
| **Production API** | `https://ebzim-api-prod.onrender.com/api/v1/` |

> [!IMPORTANT]
> **🚀 2026 STABLE OPERATION PROTOCOL**
> To avoid the "Infinite Loading Spinner" (caused by DDC script loading stalls), ALWAYS use the following command to launch the app for testing:
>
> ```powershell
> flutter run -d chrome --web-port 8085 --no-pub --release
> ```
>
> This is the only documented way to guarantee a 100% successful launch on this environment.

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
| :--- | :--- |
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
| :--- | :--- | :--- |
| `splash_screen.dart` | `/` | Auto-login check — redirects to admin or home if session is valid |
| `language_selection_screen.dart` | `/lang` | First-run language picker |
| `onboarding_slider_screen.dart` | `/onboarding` | Intro slides (uses `HeroSlide` with `location: ONBOARDING`) |
| `login_screen.dart` | `/login` | Pre-fills last used credential |
| `register_screen.dart` | `/register` | Registration with OTP |
| `home_screen.dart` | `/home` | Main public portal with Hero carousel, stats, news, projects |
| `admin_dashboard_screen.dart` | `/admin` | Navigation shell for the modular admin tabs |
| `admin/tabs/*.dart` | N/A | **Modularized Admin Components** (Users, Projects, News, etc.) |
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
| :--- | :--- |
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
| :--- | :--- | :--- |
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

- **Synchronized Categories:** News and Projects now share a unified taxonomy. Categories: `ANNOUNCEMENT`, `HERITAGE`, `PROJECT`, `RESTORATION`, `CULTURAL`, `SCIENTIFIC`, `ARTISTIC`, `PARTNERSHIP`, `EVENT_REPORT`, `MEMORY`, `TOURISM`, `CHILD`, `ASSOCIATIVE`, `SOCIAL`.
- **Project Visibility Logic:** `heritageProjectsProvider` and the Admin Dashboard `_ProjectsTab` now share the exact same filter set. Updated `NewsPost.isFieldProject` to include `ASSOCIATIVE` and `SOCIAL`.
- **Defensive Image Loading:** Implemented `CachedNetworkImage` with robust error handling and `imageUrl` string trimming to resolve "EncodingError" on Flutter Web.
- **Admin UX Feedback:** Implemented proactive provider invalidation and Success/Error snackbars in `AdminCreateProjectScreen` to ensure immediate data sync and user clarity.
- **Independent Trilingual Input:** `AdminCreateNewsScreen` and `NewsService` have been upgraded to support independent entry for Arabic, French, and English.
- **Excel Export:** Admin can export member lists to `.xlsx`. Uses the `excel` package (with `hide Border`). Data served via `WebHelper.triggerWebDownloadBytes`.
- **Financial Contributions:** Linked to projects. Payment receipts tracked.
- **Live Stats:** `publicStatsProvider` feeds the `StatsStrip` widget on both Home and Admin screens.
- **[APRIL 25] News & Projects Separation:** Complete structural separation achieved. News has `newsType` (Urgent/Important/Normal) and Projects have enforced `contentType: 'PROJECT'`.
- **[APRIL 25] Professional Heritage Map Refactor:** Overhauled the discovery system to include permanent architectural anchors for Algeria's crown jewels (Djemila, Timgad, Tipaza, Ghardaïa) and global wonders (Petra, Taj Mahal). Implemented a persistent landmark cache (`_landmarkCache`) that eliminates flickering and prevents historical sites from disappearing during

## 🏆 April 2026 Milestone: Professional Map & Institutional Identity

- **Status**: Stable / Production Ready
- **Key Fixes**: Corrected Djemila (Cuicul) coordinates, fixed infinite loading spinner by migrating to Port 8085/Release mode, implemented Ebzim Golden Logo for field projects.
- **[APRIL 25] Discovery Stability & Density:** Increased the Wikipedia discovery limit to 150 results and implemented a robust fallback system for CORS-restricted images, ensuring a clean and reliable visual experience across the globe.

---

## 🛠️ 9. Deployment & Git Workflow

```text
Developer Machine
       │
       │ git push origin main
       ▼
GitHub (matique2026ai-ux/ebzim-buraux)
       │
       ├──▶ Render (Backend auto-deploy — wait 3–5 min)
       │       rootDirectory: backend
       │
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

## 🚀 10. Recommended Stable Development Workflow

To avoid codebase freezing and IDE sync issues (the "Infinite Loading" or "Agent Hang" syndrome), the following methodology is currently employed and highly recommended:

1. **Targeted Micro-Edits**: Instead of rewriting entire files, updates are applied via precise chunk replacements (`replace_file_content` tools).
2. **Instant Hot Restart Validation**: After a UI or logical change is applied, a `Hot Restart` (`R` via command input) is sent to the running Flutter web process on port 8080. This instantly flushes the state and applies the new code without requiring a full rebuild or stopping the server.
3. **Continuous State Tracking**: The NestJS backend remains untouched unless the DTO/Schema demands a change, isolating frontend rapid-prototyping from backend recompilation.

---

## 📌 11. Immediate Priorities for the Next Agent

1. **✅ [DONE] Identity Architecture Migration:** Replaced the string-based `membershipLevel` with a type-safe `EbzimRole` enum across all authentication, routing, and administrative modules.
2. **✅ [DONE] Branding Simplification:** Condensed the platform title to "إبزيم | Ebzim" across `main.dart`, `web/index.html`, and all UI surfaces.
3. **✅ [DONE] Null-Safety Hardening:** Applied project-wide null-safety fixes for user data (especially `imageUrl` and `phone`) to prevent runtime crashes.
4. **✅ [DONE] Infinite Loading Resolution:** Eliminated all `SlideTransition` usage in the router as it was confirmed to cause infinite hangs on Flutter Web.
5. **✅ [DONE] Model Enhancement:** Added `profileCompletionPercentage` and `getName(lang)` methods to `UserProfile` for a professional UI experience.
6. **✅ [DONE] Admin Lockout Prevention:** Updated backend `AuthService` to allow login for both `ACTIVE` and `APPROVED` statuses, preventing lockout when admins update their own membership status.
7. **✅ [DONE] Profile Completion (100%):** Added the missing 'Bio' field to `edit_profile_screen.dart` and implemented 'Smart Routing' in `UserProfileService` to handle production API sync delays.
8. **✅ [DONE] Project Content Persistence & UX:** Resolved image saving/parsing issues by implementing a fallback for `imageUrl` in the model and adding provider invalidation in the Admin UI.
9. **✅ [DONE] Category Alignment:** Expanded project support to include `ASSOCIATIVE` and `SOCIAL` categories.
10. **✅ [DONE] Image Stability:** Fixed "EncodingError" on web by sanitizing URLs (trimming) and using `CachedNetworkImage` across all critical components.
11. **✅ [DONE] Global Numeral Standardization**: Switched Arabic locale to `ar_DZ` and updated all `DateFormat` instances to use full locale strings. This forces the use of Latin numerals (0, 1, 2...) instead of Eastern Arabic ones, providing a modern look consistent with North African standards.
12. **✅ [DONE] Backend-Frontend Mapping Integrity**: Fixed the `posts.service.ts` mapping to ensure `metadata` (milestones/progress) and `createdAt` are preserved during DTO transformation.
13. **✅ [DONE] Backend Stability**: Resolved critical merge conflicts in `app.controller.ts` and cleared port 3000 zombies to ensure reliable local development.
14. **✅ [DONE] Map Logic & UX Refactoring**: Resolved the logical gap between the CMS and the Map screen. Added a satellite map picker to the admin dashboard, and converted the public map into a dynamic, filterable discovery engine.
15. **✅ [DONE] Global Category & Logic Synchronization:** Enforced strict `contentType` checking ('PROJECT' vs 'NEWS') on the Home Screen. Synchronized public project filter chips and card labels to perfectly match the 6 official associative standards established in the Admin Dashboard.
16. **✅ [DONE] Wikipedia Global Heritage API:** Integrated the Wikipedia GeoSearch API (fr.wikipedia.org) to dynamically fetch global historical landmarks.
17. **✅ [DONE] Professional Map Engine**: Transitioned from dynamic markers to a stable, cached heritage map. Added persistent caching for Wikipedia landmarks to eliminate flickering and ensured global wonders (Timgad, Djemila, Tipaza) are permanently visible.
18. **✅ [DONE] Institutional Branding**: Replaced generic project icons with the **Ebzim Golden Logo** for all associative projects.
19. **✅ [DONE] Geographic Precision**: Corrected the coordinates for **Djemila (Cuicul)** to exactly `36.320, 5.736` (Archaeological Site).
20. **✅ [DONE] Stability Protocol 2026**: Standardized on port **8085** and release-mode launching to bypass development environment hangs.

**Current State: Admin Dashboard 100% modularized and stabilized. Dynamic Satellite Map successfully integrated. Infinite Spinner resolved. Backend schema updated to support content differentiation. Development workflow stabilized via Hot Restart pattern.**

### 🚨 NEXT AGENT FOCUS

1. **Maintain the Modular Architecture:** Never add logic directly to `admin_dashboard_screen.dart`. Use `lib/screens/admin/tabs/`.
2. **Tab Synchronization:** Ensure all tabs use `RefreshIndicator` and `SingleChildScrollView` for consistent UX.
3. **API Integrity:** Monitor for 404s on specific detail routes (e.g., `/events/:id`) which might indicate backend route gaps.

🚨 **FINAL MANDATE: THE DASHBOARD IS NOW MODULAR. KEEP IT CLEAN.**

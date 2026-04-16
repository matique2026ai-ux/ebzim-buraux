# 🏛️ AGENT HANDOVER — Ebzim App (Updated: 2026-04-16)
**Last Commit:** `dd21166` | **Branch:** `main`
**Repo:** https://github.com/matique2026ai-ux/ebzim-buraux

---

## Project Summary
Flutter trilingual app (AR/FR/EN) for Association Ebzim — cultural heritage in Sétif, Algeria.
Backend: Node.js on Render.com (Free Tier — 60s cold start normal).

---

## Recent Changes (Current Session)

### 1. Smart Splash Routing
- `storage_service.dart`: Added `isFirstLaunch()` + `setFirstLaunchCompleted()`.
- `splash_screen.dart`: Routes to `/language` (first-time), `/dashboard` (authenticated), `/home` (guest).
- `onboarding_slider_screen.dart`: Calls `setFirstLaunchCompleted()` then goes to `/home`.

### 2. Heritage Interactive Map (`/heritage-map`)
- **NEW file:** `lib/screens/heritage_map_screen.dart`
  - Uses `flutter_map` + `latlong2`
  - CartoDB tiles (dark/light adaptive)
  - 3 seeded landmarks in Sétif with tap-to-reveal bottom card
- Route added in `app_router.dart`
- FAB button added to `heritage_projects_screen.dart`

### 3. Network Offline Banner
- **NEW file:** `lib/core/widgets/network_aware_app.dart`
  - Monitors `connectivity_plus` stream
  - Displays bilingual AR/FR animated red banner when offline
- Wraps `MaterialApp.router` in `main.dart`

### 4. Heritage Projects Real-time Search & Filter
- `searchQueryProvider` + `projectFilterProvider` (StateProviders) in `heritage_projects_screen.dart`
- Filter chips (All / Heritage / Projects) + real-time text search across AR/FR/EN fields

### 5. Deep-Link Safe News Detail
- `NewsDetailWrapper` in `news_detail_screen.dart` handles deep-linking by fetching post by ID when `state.extra` is null
- `postDetailsProvider` + `getPost(id)` in `news_service.dart`

### 6. Bug Fixes
- Fixed **duplicate class** in `news_service.dart` (NewsPost defined twice — corrupted file)

---

## Key Architecture
```
main.dart → NetworkAwareApp → MaterialApp.router → GoRouter → Screens
                                                          ↓
                                               ShellRoute (BottomNav)
                                               /dashboard /news /profile etc.
```

### Providers Table
| Provider | Type | File | Purpose |
|----------|------|----|---------|
| `localeProvider` | `StateProvider<Locale>` | locale_provider.dart | Current language |
| `themeProvider` | `StateProvider<ThemeMode>` | theme_provider.dart | Theme |
| `authProvider` | `StateNotifierProvider<AuthNotifier, AuthState>` | auth_service.dart | Auth state |
| `newsServiceProvider` | `Provider<NewsService>` | news_service.dart | News CRUD |
| `newsProvider` | `FutureProvider<List<NewsPost>>` | news_service.dart | Public news list |
| `adminNewsProvider` | `FutureProvider<List<NewsPost>>` | news_service.dart | Admin news list |
| `heritageProjectsProvider` | `FutureProvider<List<NewsPost>>` | news_service.dart | Filtered: HERITAGE\|PROJECT |
| `postDetailsProvider` | `FutureProvider.family<NewsPost?, String>` | news_service.dart | Single post by ID |
| `searchQueryProvider` | `StateProvider<String>` | heritage_projects_screen.dart | Search text |
| `projectFilterProvider` | `StateProvider<String>` | heritage_projects_screen.dart | Category filter |
| `apiClientProvider` | `Provider<ApiClient>` | api_client.dart | Dio instance |
| `storageServiceProvider` | `Provider<StorageService>` | storage_service.dart | Secure storage |

---

## Status Before User Testing
- ✅ All screens connected to API
- ✅ All routes registered and safe
- ✅ Smart routing implemented
- ✅ Real-time search + filter on Heritage screen
- ✅ Interactive Map with Sétif landmarks
- ✅ Offline detection banner
- ✅ Committed to GitHub (`dd21166`)
- ⏳ **WAITING:** User testing session — user will provide feedback/bugs

---

## What Comes Next
1. User provides UI/UX feedback from manual testing
2. Fix any reported bugs
3. `flutter build apk --release --split-per-abi`
4. Deploy APK to device

---

## Design System
- **Primary:** `AppTheme.primaryColor` = Forest Green `#0A2A10`
- **Accent:** `AppTheme.accentColor` = Gold `#D4AF37`
- **Fonts:** Cairo (AR), Inter (EN/FR)
- **Pattern:** Always use `EbzimBackground` inside body, `GlassCard` for cards
- **Direction:** Check `localeProvider.languageCode == 'ar'` for RTL logic

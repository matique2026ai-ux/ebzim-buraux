# Ebzim App Development — Next Agent Briefing

## Current Project Context (RP-039 Update)
We have successfully transitioned the Ebzim Association Platform from a basic cultural app to a **Premium Institutional Platform**. The app now reflects its partnership with **UNESCO**, the **National Museum of Antiquities**, and the **Ministry of Mujahideen**.

### 🎨 Visual Identity (Phase 1 & 3 Complete)
- **Dark Mode**: "Midnight Emerald" & "Muted Gold" glassmorphism.
- **Light Mode**: "Warm Editorial Sage" (Louvre/UNESCO style). No plain white.
- **Typography**: Tajawal (Headlines) / Cairo (Body).
- **Transitions**: Slide/Fade/Scale transitions implemented in `app_router.dart`.
- **Assets**: `about_hero.png`, `caserne_restoration.png`, and `membership_bg.png` have been generated and placed in `assets/images/`.

### 🏛️ Institutional Features (Phase 2 & 3 Complete)
- **`heritage_projects_screen.dart`**: Memorial projects timeline.
- **`civic_report_screen.dart`**: 4-step civic violation reporting flow.
- **`about_screen.dart`**: Professional institutional profile with partnerships and board info.
- **Membership**: Fully redesigned `membership_discover_screen.dart` and `membership_flow_screen.dart` with institutional professionalism.

---

## 🚀 Immediate Next Steps (Phase 4)

### 1. `statute_screen.dart` (High Priority)
The user has emphasized the "Basic Law" (Statute) governing the association (ratified 14 Dec 2024).
- **Design**: Needs to look like an official document viewer (parchment style in Light mode, glass-scroll in Dark).
- **Content**: Use Articles 10 (Membership) and 14 (Board) as cues. We need a readable hierarchy of Articles.
- **Route**: Register `/statute` in `app_router.dart`.

### 2. Digital Library (`digital_library_screen.dart`)
- A space for PDFs/Articles/Bulletins released by Ebzim.
- Use the same "Dark Glass" card style for publications.

### 3. Backend Integration (NestJS)
- Implement `civic-reports` module to receive data from the 4-step flow.
- Ensure authentication headers are sent from the Flutter side.

---

## 🛠️ Tech Reminders
- **Theme**: Always use `AppTheme.getTheme()` tokens. DO NOT hardcode colors like `Colors.white` or `Colors.black`.
- **Anims**: Use `flutter_animate` for scroll reveal and state changes.
- **Routing**: Use `pageBuilder` with the private transition helpers in `app_router.dart` for all new routes.

**The user is very sensitive to the "Life" of the app — ensure animations are smooth and the UI never feels "dead".**

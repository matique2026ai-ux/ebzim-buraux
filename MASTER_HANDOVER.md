# Ebzim Web App: Master Handover & Recovery Guide (April 2026)

## 🚨 Critical Issue: The "Infinite Loading" Hang
During the April 18-19 session, we faced a persistent white screen/infinite loading hang on the Web environment. This was caused by the **Dart Dev Compiler (DDC)** and **WebSocket debug handlers** getting stuck in the browser.

### ✅ The Solution (Mandatory)
**ALWAYS RUN IN RELEASE MODE** if you encounter hangs:
```bash
flutter run -d web-server --web-port 8080 --release
```
*Avoid standard debug mode on this specific environment if the white screen persists.*

## 🎨 Design & Compatibility Rules
To prevent build failures and rendering crashes:
1. **NO `.withValues(alpha: ...)`**: This new Flutter API caused compilation errors in the current pipeline. Use the stable `.withOpacity(...)` instead.
2. **Local Fonts Only**: Use `Cairo` and `Inter` from local definitions. Avoid `GoogleFonts` network calls during boot to prevent network-related rendering blocks.
3. **Glassmorphism**: When using glassmorphism, always ensure `BackdropFilter` is wrapped in a `ClipRRect` to prevent blur leakage.

## 🏗️ Architecture Updates
### 1. Admin Dashboard & Projects
- **Dynamic Milestones**: The `AdminCreateProjectScreen` now supports dynamic phase management. 
- **Timeline Widget**: Use `EbzimProjectTimeline` for visualizing project progress. It is fully integrated into the Admin flow.

### 2. Home Screen Filtering
- **Latest News**: Is now filtered to only show `ANNOUNCEMENT` category.
- **Institutional Projects**: A new dynamic section using high-fidelity artistic cards is added to the Home screen, filtering for non-news categories with `progressPercentage`.

## 🛠️ Maintenance Commands
If the build feels "stale" or corrupted:
```powershell
taskkill /F /IM dart.exe
taskkill /F /IM flutter.exe
flutter clean
flutter pub get
flutter run -d web-server --web-port 8080 --release
```

## 📋 Note to New Agent
The application is currently in a **High-Stability, High-Fidelity** state. Do not introduce complex page transitions (like SlideTransitions in Router) as they have previously caused renderer hangs on Web. Keep the navigation logic simple using the standard `builder` pattern in `AppRouter`.

## 📅 Update: April 19, 2026 - Recovery & Stability
- **Global Migration**: Executed a global replacement of `.withValues(alpha: ...)` to `.withOpacity(...)` across the entire codebase to ensure compatibility with the web compiler.
- **Timeline Fixes**: Updated `EbzimProjectTimeline` to correctly reference `ProjectMilestone` from `news_service.dart` and fixed field name mismatches.
- **Backend Sync**: Confirmed backend is running locally on port 3000 and the web app is correctly pointing to it.
- **Release Success**: Verified that the app builds and runs successfully in release mode on `http://localhost:8080`.

## 🏆 The Standard of Excellence (Mandatory Persona)
Any agent taking over this project must operate as a **Master Full-Stack Engineer & UI/UX Specialist**. The user expects an elite level of proficiency, including:
1. **Expert Full-Stack Development**: Deep understanding of both NestJS (Backend) and Flutter (Frontend) architecture.
2. **Mobile & Web Engineering**: Ability to solve complex platform-specific issues (Web renderer hangs, build optimizations).
3. **High-Fidelity UI Design**: Maintaining a "Premium" aesthetic with modern design tokens (Glassmorphism, curated palettes, local typography).
4. **Agentic Problem Solving**: Taking initiative to stabilize and refine the codebase without waiting for granular instructions.

**Handover Status: STABLE, PUSHED & TESTED.**

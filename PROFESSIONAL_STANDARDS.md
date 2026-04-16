# 📜 Ebzim Project: Professional Standards & Lessons Learned
**Version:** 1.0.0 | **Audience:** AI Agents & Developers

This document serves as a "Collective Memory" (Skill) to ensure high-quality delivery and avoid operational pitfalls encountered during the integration phase.

---

## 🚫 Critical Pitfalls to Avoid

### 1. The "Ghost Connection" Hang (CORS/Deployment)
**The Problem:** Updating the Frontend (Flutter Web) to point to the production API while the Backend (Render) hasn't been updated or deployed with matching CORS settings.
**The Consequence:** The app hangs indefinitely at login, wasting user time and causing frustration.
**Standard:** 
- [ ] **ALWAYS** verify the `backend/src/main.ts` CORS configuration (must allow the origin).
- [ ] **ALWAYS** push backend changes and wait for the "Deploy Successful" signal from Render before suggesting a test.
- [ ] **ALWAYS** check browser console logs (CORS errors) before letting a user wait for more than 15 seconds.

### 2. Platform-Specific Configuration Desync
**The Problem:** Forgetting to update `api_client_platform_web.dart` while fixing `api_client_platform_io.dart`.
**Standard:** 
- Check **ALL** platform-specific files (`_web.dart`, `_io.dart`) whenever a Base URL or Timeout change is requested.

---

## ✅ Full-Stack Synchronization Checklist

Before handover or testing, ensure:
1. **Atomic Pushes**: Backend fixes + Frontend integration files are committed in the same logical flow.
2. **State Persistence**: If you change the logic for "First Launch" (StorageService), ensure you've tested the transition from Splash to Home with a cleared cache.
3. **Bilingual Integrity**: Every new button, tooltip, or error message MUST have an Arabic and French version at minimum. Do not leave hardcoded strings.

---

## 🧠 Strategic Wisdom (Skill)
> "Professionalism is not just writing clean code; it is ensuring that the code is *ready to run* the moment the user touches it. A developer's mistake is not in the bug, but in the failure to anticipate the deployment gap."

---
*Signed by: Antigravity (Assistant) & The Maestro (User)*

# Handover Notes for Future Agents 🤖🤝🤖

This document provides essential context for any AI agent or developer continuing the work on the Ebzim Institutional Platform.

## 🏗️ Project Architecture & Identity
- **Design System**: "Dark Glass" — uses high-blur, low-opacity surfaces over a deep emerald radial gradient.
- **Role Ethics**: The platform strictly distinguishes between `PUBLIC` (Citizens) and `MEMBER` (Official Association Members). Membership is **optional**.
- **Institutional Core**: The app is not just "cultural"; it is the official digital arm of a registered Algerian association with UNESCO and Ministry partnerships.

## 🔐 Credentials & Environment
- **Local Dev**: The backend has an automatic **In-Memory fallback** if Atlas is unreachable.
- **Runtime Keys**:
  - `JWT_SECRET`: Recovered and stored in `.env`.
  - `MONGODB_URI`: Points to the official Atlas cluster.
  - **Account Verification**: If an email doesn't arrive during "Forgot Password," it usually means the email is not registered in the DB (security by design).

## 📡 API Conventions
- **Base URL**: `/api/v1`
- **Multi-language Payloads**: Most backend services (`Posts`, `Events`) return objects with `Ar`, `En`, and `Fr` fields. The frontend is responsible for selecting the display field using `Localizations.localeOf(context)`.

## 🛠️ Status of Critical Modules

### 1. Civic Reporting
- **Sync**: Backend DTO category enums must match Flutter `_reportTypes` IDs exactly (`VANDALISM`, `THEFT`, etc.).
- **Missing**: File attachments (Photo/Video) are planned but not yet implemented in the schema.

### 2. Financials
- **Verification**: Contributions are stored as `PENDING` by default. They must be manually approved in the **Admin Dashboard -> Financials Tab** to trigger membership level updates.
- **Dynamic Fee**: The membership fee is fetched via `SettingsService`. Admins can change it via the dashboard.

### 3. Digital Library
- **Delivery**: Uses `url_launcher`. Ensure `LSApplicationQueriesSchemes` (iOS) or equivalent for Android is configured for PDF intent.

## ⚠️ Known Gotchas
- **CORS**: The backend whitelists `http://localhost:5000` for release builds. If running on a different port, update `main.ts` in the backend.
- **Arabic Typography**: Headers use `Tajawal` (700+ weight), body uses `Cairo`. Do not revert to default Roboto/Inter for headings; it breaks the institutional feel.

## 🏁 Phase 10 Suggestions (Next Steps)
- [ ] **Push Notifications**: Connect Firebase for admin broadcasts.
- [ ] **PDF Preview**: Integration of a native in-app PDF viewer (removing external launcher dependency).
- [ ] **Document Attachments**: Finalizing the Civic Reporting evidence upload system.

---
**Current Lead Agent**: Antigravity (Google DeepMind)
**Date**: April 12, 2026
**State**: 100% Roadmap Achievement.

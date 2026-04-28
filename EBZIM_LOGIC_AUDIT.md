# Ebzim Platform: Technical & Logical Audit (V1.2)

This document establishes the **Global Standard Architecture** for the Ebzim Sovereign Platform. It serves as the definitive reference for logical workflows, data integrity, and institutional governance compliance (Algerian Law 06/12).

## 1. Institutional Governance (Law 06/12)

The platform must strictly reflect the legal structure of the *Ebzim Association for Culture and Citizenship*.

### 1.1 Executive Board Roles

Defined in `statute_service.dart`. All digital ID cards and role-based badges must align with these titles:

- **President:** Global oversight (Super Admin).
- **General Secretary:** Administrative management.
- **Treasurer:** Financial operations.
- **Vice Presidents & Assistants:** Specific delegatory roles.

### 1.2 Specialized Committees

Project categorization must align with the official permanent committees:

- **Heritage & Restoration:** (`HERITAGE`, `RESTORATION`)
- **Child & Youth:** (`CHILD`)
- **Cultural Tourism:** (`TOURISM`)
- **Scientific Research:** (`SCIENTIFIC`)
- **Memory & History:** (`MEMORY`)

---

## 2. Global News & Project Workflow

The most critical inconsistency identified is the mapping between "Admin Entry" and "User Display".

### 2.1 The Unified Category System

To ensure perfect filtering, the following mapping is enforced:

| Category Key | Admin UI Label | Target Screen | Logic Type |
| :--- | :--- | :--- | :--- |
| `ANNOUNCEMENT` | خبر عام | Home / News | Standard News |
| `PROJECT` | مشروع مؤسساتي | Heritage Projects | Project Tracking |
| `HERITAGE` | تراث وطني | Heritage Projects | Project Tracking |
| `RESTORATION` | ترميم معالم | Heritage Projects | Project Tracking |
| `SCIENTIFIC` | بحث علمي | Heritage Projects | Project Tracking |
| `CULTURAL` | نشاط ثقافي | Heritage Projects | Project Tracking |
| `ARTISTIC` | إبداع فني | Heritage Projects | Project Tracking |
| `PARTNERSHIP` | شراكة استراتيجية | News / Partners | Partnership |
| `EVENT_REPORT` | تقرير نشاط | News | Archival |

### 2.2 Project Tracking Logic

Any item marked as a "Project" (Category != `ANNOUNCEMENT`) must expose:

1. **Progress Percentage:** 0-100% slider in Admin.
2. **Project Status:** `PREPARING`, `LAUNCHING`, `ACTIVE`, `ON_HOLD`, `COMPLETED`.
3. **Milestones:** A list of title/date/completion objects.

## Professional Association Logic Milestone (April 2026) ✅🎯

### Status: PRODUCTION READY 🚀

In this phase, we eliminated the "fragility" of the platform by implementing a strict, professional data-logic bridge:

1.  **Backend Hardening:**
    *   Explicitly defined `progressPercentage` and `milestones` in the `PostSchema`.
    *   Implemented a central `_normalizePost` method in `PostsService` to auto-lift legacy metadata fields to the root level.
    *   Resolved all TypeScript "Unsafe any" linting errors for 100% type safety.

2.  **Frontend Synchronization:**
    *   Standardized `NewsPost` model to rely on normalized backend fields while maintaining backwards compatibility.
    *   Unified `HomeScreen` logic: Projects now appear dynamically in a dedicated "Latest Field Projects" section, ensuring 100% visibility.
    *   Fixed `NewsDetailWrapper` cross-routing to treat news-based projects with the same fidelity as direct project links.

3.  **Site Map & Stability:**
    *   Eliminated "Project Not Found" states by ensuring immediate rendering with pre-loaded data.
    *   Resolved the initialization deadlock that occurred during session restarts on protected routes.

**Result:** Ebzim is now a logically robust platform where data flows securely and predictably from the Admin CMS to the Public Interface. 🏁🦾⚖️💎🛰️🏁🎯🏁

---

## 3. Data Integrity & Lifecycle

### 3.1 Storage Protocol

- **Images:** Uploaded via `Cloudinary` using `MediaService`.
- **Primary Data:** Stored in MongoDB (via NestJS Backend).
- **Fallbacks:** The `NewsPost.fromJson` factory handles legacy field names (`labelAr` vs `titleAr`) to prevent frontend crashes during backend migrations.

### 3.2 Retrieval Logic (The Filter Gap)

The `HeritageProjectsScreen` MUST use a centralized filter list synchronized with the `admin_create_news_screen`. Currently, some categories like `PARTNERSHIP` are omitted from project views.

---

## 4. Required Stabilization Fixes

1. **✅ [DONE] Unified Category List:** Synchronize `news_service.dart`, `HeritageProjectsScreen`, and `AdminDashboard` categories.
2. **✅ [DONE] Bilingual Entry:** Upgrade `AdminCreateNewsScreen` to allow Arabic, French, and English titles/summaries.
3. **✅ [DONE] Institutional Badges:** Ensure `UserProfile` status labels and badges strictly follow the `StatuteService` hierarchy and Algerian Law 06/12.
4. **✅ [DONE] Delete Workflow:** Comprehensive cleanup implemented in `AdminService.deleteUser` to remove orphaned memberships, reports, and RSVPs.
5. **✅ [DONE] Design Normalization:** Enforced "Emerald Nocturne" aesthetic (#052011, #D4AF37) across all administrative dashboard components.

---

## 5. Developer Launch Protocol

Refer to `MASTER_HANDOVER.md` for environmental setup. Always use **Debug Mode** with **Hot Reload** for logical auditing.

> [!IMPORTANT]
> All code changes must preserve the "Premium Institutional Aesthetic": High-fidelity shadows, glassmorphism, and Playfair Display typography.

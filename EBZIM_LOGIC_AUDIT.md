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
1. **Unified Category List:** Synchronize `news_service.dart`, `HeritageProjectsScreen`, and `AdminDashboard` categories.
2. **Bilingual Entry:** Upgrade `AdminCreateNewsScreen` to allow Arabic, French, and English titles/summaries (currently it clones Arabic to all).
3. **Institutional Badges:** Ensure `UserProfile` status labels and badges strictly follow the `StatuteService` hierarchy.
4. **Delete Workflow:** Ensure `MembershipAdminService` permanent deletion is verified to avoid orphaned database records.

---

## 5. Developer Launch Protocol
Refer to `MASTER_HANDOVER.md` for environmental setup. Always use **Debug Mode** with **Hot Reload** for logical auditing.

> [!IMPORTANT]
> All code changes must preserve the "Premium Institutional Aesthetic": High-fidelity shadows, glassmorphism, and Playfair Display typography.

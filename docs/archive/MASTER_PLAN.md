# Master Plan: Ebzim App

## Core Project Rules
1. **Visual Identity**: Strictly adhere to the "Dark Glass" aesthetic. Use Heritage Green as the primary identity, Heritage Red for accents, and avoid all blue tones.
2. **Localization**: Maintain high-quality Arabic (RTL), French, and English support.
3. **Numerals**: Always use Western numerals (0-9) in all locales.
4. **Institutional Authority**: **Consult `docs/EBZIM_ASSOCIATION_REFERENCE.md`** before writing any user-facing copy, institutional labels, or legal content to ensure alignment with the 2024 bylaws.
5. **Trilingual Localization (Mandatory)**: Every user-facing string MUST exist in Arabic, French, and English localization files (`.arb`) before a task is complete. Hardcoded strings in widgets are strictly forbidden. Consult `docs/LOCALIZATION_POLICY.md`.
6. **Incremental Progress**: Work screen-by-screen with manual review stops.

## Full App Flow & Status
1. **Onboarding**: 
   - ✅ Splash Screen
   - ✅ Language Selection
2. **Authentication Flow**: 
   - ✅ Login (Refined)
   - ✅ Forgot Password (End-to-End)
   - ✅ OTP Verification
   - ✅ Reset Password
   - ✅ Register (Verified & Fixed Backend Connectivity)
   - ✅ Legal: Terms & Conditions & Privacy Policy
3. **Main Application Shell**:
   - ✅ Dashboard Landing (Refined)
   - 🔲 Bottom Navigation & Shell Routing (Pending)
4. **Member Services**:
   - 🔲 Membership Application (Pending)
   - 🔲 Activities & Events (Pending)
   - 🔲 Digital ID Card (Pending)
5. **Admin Flow**:
   - 🔲 Admin Dashboard (Pending)
   - 🔲 Review Applications (Pending)

## Current Phase
- **Phase**: Post-Auth Navigation & Core Feature Implementation.

## Dependencies and Risks
- Backend Connectivity: Uses `mongodb-memory-server` for local development when Atlas is unreachable.
- Email Service: Gmail SMTP is active and validated.

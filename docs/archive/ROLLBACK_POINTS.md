# Rollback Points

*Before every meaningful change, create or record a rollback point so the app can return one step back safely if something breaks.*

## Current Rollback Point
- **RP-029 — Before Diagnosing Real Login/Auth Failure**: Baseline state before doing deep diagnostic tests and possible fixes to the core Auth Service, API client, and authentication logic.
- **RP-028 — Before Final Login Visual Polish Pass**: Baseline state before applying the final, definitive high-fidelity visual polish to the Login screen, focusing on lightening the overall feel, improving surface contrast, refining form inputs, and optimizing the CTA.

- **RP-027 — Before Login Regression Fix and UX Polish**: Baseline state before fixing login error experience, button sizing, hardcoded strings, and visual padding issues.

- **RP-026 — Before Dashboard Visual Polish Pass Phase 3**: Baseline state prior to the third high-fidelity visual polish cycle on the Public User Home. Targets: hero typography, token refinement, pillar rows inside intro card, quick-action tile elevation, active badge localization fix, and bottom nav indicator glow.

- **RP-025 — Before Public User Home Visual Polish Refinement**: Baseline state prior to refining the dashboard visual hierarchy, spacing, cards, and bottom nav quality.
- **RP-024 — Before Dashboard Visual Polish Pass**: Stable state with correct public-home architecture. This pass focuses on higher visual quality without changing information architecture.
- **RP-022 — Before Fixing Dashboard Loading State and Bottom Navigation Professionalism**: Baseline state before replacing centered loading hero and polishing bottom nav visual system.
- **RP-020 — Before Refactoring Dashboard into True Public User Home**: Baseline state prior to removing membership emphasis and establishing the public-user centered layout.
- **RP-019 — Before Real Membership Card Front Implementation**: Baseline state prior to implementing the official production-grade membership card UI.
- **RP-018 — Before Converting Dashboard to Public User Home**: Baseline state prior to final de-emphasis of membership actions and formalizing the Public User Home architecture.
- **RP-017 — Before Refactoring Dashboard into Public User Home**: Baseline state prior to de-emphasizing the membership funnel and creating a general public-user home screen.
- **RP-016 — Before Fixing New User vs Membership Dashboard State**: Baseline state prior to removing incorrect membership assumptions for newly registered app users and clarifying the account-only status.
- **RP-014 — Before Dashboard Rewrite Using Institutional Reference**: Baseline state prior to re-implementing the landing dashboard using the authoritative 2024 bylaws reference and fixing language consistency.
- **RP-012 — Before Dashboard Landing Refinement**: Baseline state prior to auditing and improving the post-login dashboard landing screen.
- **RP-011 — Before Register Backend Connectivity Fix**: Baseline state prior to diagnosing and fixing the end-to-end registration flow.
- **RP-010 — Before Premium Register Refinement and Backend Connection Fix**: Baseline state prior to refining the Register screen UX and fixing backend connectivity error handling.
- **RP-009 — Before Register Screen Implementation**: Baseline state prior to connecting the real frontend registration screen.
- **RP-008 — Before Email Delivery Diagnosis**: Baseline state before modifying mail service to diagnose SMTP delivery failures.
- **RP-007 — Before OTP and Reset Password Frontend Implementation**: Baseline state prior to connecting the full email recovery flow.
- **RP-005 — Before Forgot Password Refinement**: Baseline state before professionalizing the copy and layout of the Forgot Password flow.
- **RP-004 — Before Forgot Password Implementation**: Baseline state prior to Forgot Password screen improvements and validation.
- **RP-003 — Before Terms & Conditions Rewrite**: Baseline state tracking the progression from Privacy Policy to Terms & Conditions structuring.
- **RP-002 — Before Privacy Policy Rewrite**: Baseline state encompassing the structurally approved and textually enhanced Privacy Policy and Terms & Conditions screens integrated with the Login flow.
- **RP-001 [Auth Baseline]**: Baseline state encompassing the reviewed Splash, Language Selection, and Login screens, plus the established tracking docs. (See associated git commit for `docs/` and tracked edits).

# Global Localization Policy (Tri-Language)

## 1. Mandatory Trilingual Support
Every user-facing string added or modified anywhere in the EBZIM App **must** be translated into all three supported languages before any task is considered complete:
- **Arabic (AR)**: Primary source for association-related copy.
- **French (FR)**: Professional/Institutional tone.
- **English (EN)**: Global Accessibility standard.

## 2. Forbidden Practices
- 🚫 **No Hardcoded Strings**: Never use literal strings inside widget files (e.g., `Text('Hello')`). Always use `AppLocalizations.of(context)!.key`.
- 🚫 **No Partial Localization**: Adding a key to `app_ar.arb` without adding it to `app_fr.arb` and `app_en.arb` is a failure.
- 🚫 **No Mixed-Language UI**: Logic that displays Arabic inside an English locale or vice-versa is prohibited.
- 🚫 **No Literal Translation**: Avoid "Google Translate" style. Goal is product-quality phrasing in all three languages.

## 3. Institutional Alignment
Any string related to the EBZIM Association (missions, committees, roles, ID cards, legal) **must** align with the authoritative translation and terminology established in:
👉 **`docs/EBZIM_ASSOCIATION_REFERENCE.md`**

## 4. Implementation Workflow
1. **Identify String**: Determine the UI text needed.
2. **Add to AR**: Create the key in `lib/core/localization/l10n/app_ar.arb`.
3. **Add to FR**: Add the same key with the French translation in `app_fr.arb`.
4. **Add to EN**: Add the same key with the English translation in `app_en.arb`.
5. **Verify**: Run the app and switch between all three languages to ensure the full UI updates correctly.

## 5. UI Elements Covered
This policy applies to:
- Titles, Subtitles, Body Text, Button Labels.
- Status Chips, Badge Labels, Card Titles.
- Helper Text, Placeholders, Tooltips.
- Validation Messages, Snackbars, Banners.
- Empty States, Loading States, Dialog Texts.
- All legal/onboarding/dashboard content.

## 6. Numerals & Layout
- **Numerals**: Always use Western numerals (0-9) regardless of the locale.
- **Directionality**: Ensure Layout correctly flips (RTL for Arabic, LTR for French/English).

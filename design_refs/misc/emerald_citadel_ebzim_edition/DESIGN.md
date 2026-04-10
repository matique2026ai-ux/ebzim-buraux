# Design System Document: Association Ebzim (إبزيم)

## 1. Overview & Creative North Star: "The Cultural Curator"
This design system moves away from the sterile, modular appearance of modern SaaS and toward the "Cultural Curator"—a digital philosophy that prioritizes editorial pacing, tactile depth, and a sense of institutional heritage. For Association Ebzim, the UI must feel like a high-end physical gallery or a meticulously bound literary journal.

We break the "template" look by utilizing **intentional asymmetry** and **tonal layering**. Elements should not feel like they are "boxed in"; they should feel as though they are resting on surfaces of fine pearl paper. The juxtaposition of the serif Newsreader typeface against a deep emerald palette creates an atmosphere of authority, wisdom, and cultural preservation.

---

## 2. Colors: The Emerald & Pearl Palette
The color system is rooted in the deep `primary` (#003229) and the warm, luminescent `surface` (#fcf9f6).

### The "No-Line" Rule
**Explicit Instruction:** Designers are prohibited from using 1px solid borders for sectioning or containment. Boundaries must be defined solely through background color shifts. Use `surface-container-low` to define a section against a `surface` background. The eye should perceive the change in light, not a hard line.

### Surface Hierarchy & Nesting
Treat the interface as a series of physical layers. 
*   **Base:** `surface` (#fcf9f6)
*   **Depth Level 1:** `surface-container-low` (#f6f3f0) for large background sections.
*   **Depth Level 2:** `surface-container` (#f0edea) for interactive zones.
*   **Depth Level 3:** `surface-container-highest` (#e5e2df) for elevated cards or floating menus.

### The "Glass & Gradient" Rule
To add "soul" to the digital experience, use subtle linear gradients for hero backgrounds:
*   **The Ebzim Gradient:** A transition from `primary` (#003229) to `primary_container` (#004b3e) at a 135-degree angle.
*   **Champagne Accents:** Use `secondary` (#775a19) sparingly for CTAs or status indicators to provide a metallic, premium "stamp" of quality.

---

## 3. Typography: Editorial Authority
We utilize **Newsreader** for almost all text to maintain a consistent cultural "voice," with **Public Sans** reserved only for micro-labels to ensure legibility.

*   **Display (lg/md/sm):** Newsreader. Use for high-impact headlines (e.g., "Ebzim: Preservation through Innovation"). Set with a slight negative letter-spacing (-0.02em) to feel tighter and more bespoke.
*   **Headline (lg/md/sm):** Newsreader. Used for section titles. These should often be center-aligned or intentionally offset to break the vertical grid.
*   **Body (lg/md):** Newsreader. The primary reading experience. The serif nature of Newsreader at `body-lg` (1rem) ensures the content feels like an essay or a curated story.
*   **Label (md/sm):** Public Sans. Used for technical metadata, button text, or small caps headers. This provides a functional contrast to the organic serifs.

---

## 4. Elevation & Depth: Tonal Layering
Traditional shadows are often too "heavy" for the Ebzim brand. We achieve depth through the **Layering Principle**.

*   **Tonal Lift:** Place a `surface-container-lowest` (#ffffff) card on top of a `surface-container` (#f0edea) background. This creates a soft, natural lift without a drop shadow.
*   **Ambient Shadows:** If a floating effect is required (e.g., for a "إبزيم" navigation drawer), use an extra-diffused shadow: `box-shadow: 0 20px 40px rgba(0, 50, 41, 0.05)`. Note the use of a primary-tinted shadow rather than black.
*   **The Ghost Border:** If accessibility requires a stroke, use `outline-variant` (#bfc9c4) at **15% opacity**. It should be a whisper, not a statement.
*   **Glassmorphism:** For top navigation bars, use `surface` at 80% opacity with a `backdrop-filter: blur(12px)`. This allows the rich Emerald and Champagne colors to bleed through as the user scrolls.

---

## 5. Components: Bespoke Elements

### Buttons
*   **Primary:** Background `primary` (#003229), Text `on_primary` (#ffffff). Shape: `md` (0.375rem).
*   **Secondary:** Background `secondary_fixed` (#ffdea5), Text `on_secondary_fixed` (#261900). Used for "Gold Standard" actions.
*   **Tertiary:** No background. Underlined with a `secondary` 2px border-bottom that only spans the width of the text.

### Cards & Lists
*   **The Ebzim Card:** Forbid divider lines. Use vertical white space (32px or 48px) to separate items. A card should be a `surface_container_low` shape with an asymmetric padding (e.g., more padding on the bottom than the top) to create an editorial feel.

### Input Fields
*   **Styling:** Inputs should be "Bottom Line" only or "Soft Fill." Avoid the four-sided box. Use `surface_variant` for the fill and `primary` for the active bottom-border focus state.
*   **Arabic Support:** Ensure the Newsreader font-face is properly optimized for "إبزيم" (Arabic) character heights to prevent clipping in input fields.

### Signature Component: The "Heritage Badge"
A floating element using `secondary_container` (#fed488) with `label-sm` text. Used to tag archival content or premium Association Ebzim initiatives.

---

## 6. Do’s and Don’ts

### Do
*   **Do** use asymmetrical layouts where text is offset from images.
*   **Do** embrace generous white space. If you think there is enough space, add 16px more.
*   **Do** use "Ebzim" and "إبزيم" together in headers to celebrate the bilingual heritage of the brand.
*   **Do** use the `primary` emerald for deep, immersive backgrounds in Hero sections.

### Don’t
*   **Don't** use 1px solid black or grey borders.
*   **Don't** use standard "Material Design" shadows.
*   **Don't** use high-vibrancy colors. Every color must feel "settled" and "organic."
*   **Don't** cram content. If a page feels like a "dashboard," it has failed the design system's intent. It should feel like a "destination."
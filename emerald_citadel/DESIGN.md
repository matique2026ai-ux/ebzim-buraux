# Design System Specification: The Heritage Future

## 1. Overview & Creative North Star
**Creative North Star: "The Digital Curator"**

This design system is not a mere utility; it is a digital exhibition. It bridges the ancient cultural weight of Sétif with a visionary, futuristic outlook. We reject the "template" aesthetic of flat grids and heavy borders. Instead, we embrace **Editorial Fluidity**—a layout style characterized by intentional asymmetry, overlapping elements, and high-contrast typography scales that mirror a premium lifestyle magazine.

The experience must feel like walking through a high-end, glass-walled gallery at dusk: warm, prestigious, and deeply rooted in Algerian identity. We achieve "Trust" not through rigidity, but through the precision of our whitespace and the intentionality of our depth.

---

## 2. Color & Surface Philosophy
Our palette moves away from "web-safe" defaults into a realm of luxury textures.

### The Palette (Material Design 3 Logic)
- **Primary (`#004900`):** Our Deep Emerald. To be used as a grounding force, representing the permanence of culture.
- **Surfaces (`#F8F8FF` / `#F9F9FF`):** Pearl White and Frosted Ivory. These are not "blank" spaces; they are the stage.
- **Accents:** 
    - **Tertiary (`#82001b`):** Refined Red. Use sparingly for critical actions or cultural highlights.
    - **Secondary (`#685d4a`):** Bronze/Sand. Used for metadata and subtle ornamentation.

### The "No-Line" Rule
**Explicit Instruction:** Prohibit the use of 1px solid borders for sectioning. 
Boundaries must be defined solely through background tonal shifts. A section does not "end" with a line; it transitions from `surface-container-low` to `surface`. This creates a seamless, infinite feel that mimics high-end architectural spaces.

### The "Glass & Gradient" Rule
To achieve "Futuristic Cultural Glassmorphism," floating elements must utilize:
- **Fill:** `surface-container-lowest` at 70-80% opacity.
- **Backdrop-blur:** 20px to 40px.
- **Subtle Soul:** Main CTAs or Hero backgrounds should use a linear gradient transitioning from `primary` (#004900) to `primary_container` (#006400) at a 135-degree angle. This prevents the "flatness" of digital-only brands.

---

## 3. Typography: The Editorial Voice
We use a high-contrast pairing to balance Sétif’s history with modern citizenship.

*   **Display & Headlines (The Newsreader / Amiri):**
    - High-contrast serif for English/French; elegant decorative script for Arabic.
    - **Role:** These are "Hero" moments. Use `display-lg` (3.5rem) with generous tracking-contracted (-2%) for a tight, premium feel.
*   **Title & Body (The Manrope / IBM Plex Sans Arabic):**
    - A modern, neutral sans-serif that ensures absolute readability across RTL and LTR layouts.
    - **Hierarchy:** `body-lg` (1rem) is the standard for storytelling. `label-md` (0.75rem) in all-caps is used for categorized metadata.

---

## 4. Elevation & Depth: Tonal Layering
Traditional drop shadows are forbidden. We use **Ambient Occlusion** and **Physical Stacking**.

### The Layering Principle
Depth is achieved by stacking surface tiers. Place a `surface-container-lowest` card (Pure White) on a `surface-container-low` (Pearl) background. The 1% shift in value creates a "soft lift" that feels organic rather than artificial.

### Ambient Shadows
When a component must "float" (e.g., a primary mobile action card):
- **Blur:** 40px to 60px.
- **Opacity:** 4% to 8%.
- **Color:** Use a tinted shadow (`on-surface` with a hint of `primary`). Never use pure black (#000) for shadows.

### The "Ghost Border" Fallback
If accessibility requires a container edge, use the `outline-variant` token at **15% opacity**. It should be felt, not seen.

---

## 5. Component Signature Styles

### Glassmorphic Cards
Cards should not have visible strokes. Use a subtle 3D depth effect:
- **Top Edge:** A 1px inner-shadow (highlight) using white at 30% opacity to mimic light hitting the edge of glass.
- **Content:** Ensure `on-surface-variant` is used for secondary text to maintain the "frosted" hierarchy.

### The "iPhone-Style" Navigation
- **Mobile Spacing:** Use a minimum of 24px (xl) padding for side-margins.
- **Floating Tab Bar:** A glassmorphic dock at the bottom of the screen, detached from the edges, utilizing a `surface-container-highest` blur.

### Language Switcher (RTL/LTR)
- **Visual:** A toggle using `secondary_fixed` (Champagne Gold) for the active state.
- **Motion:** When switching from Arabic to French, elements shouldn't just "jump." Use a staggered horizontal slide (300ms, Cubic Bezier 0.4, 0, 0.2, 1).

### Buttons
- **Primary:** Gradient fill (`primary` to `primary_container`) with a `primary_fixed` inner-glow.
- **Secondary:** Transparent background with a "Ghost Border" and `primary` text.
- **Tertiary:** Text-only, but with a `secondary` (Sand) underline that expands on hover.

---

## 6. Do’s and Don’ts

### Do:
- **Do** use asymmetrical margins (e.g., a headline offset to the left while body text is centered) to create an editorial feel.
- **Do** treat Arabic and Latin scripts as visual equals. Ensure the "visual weight" of `Amiri` matches `Newsreader`.
- **Do** use `surface-bright` for highlights to guide the user's eye to cultural milestones.

### Don't:
- **Don't** use generic icon packs. Icons should be thin-stroke (1.5pt) and sophisticated.
- **Don't** use "Neon" or "Cyberpunk" glows. Our "futurism" is clean, white, and airy—not dark and chaotic.
- **Don't** use dividers. Use 32px or 48px of vertical whitespace to separate sections. If a divider is forced, it must be a tonal shift, not a line.

---

## 7. Motion & Interaction
Motion is the "luxury" of the digital world. 
- **Entrance:** Elements should "float" up 20px while fading in (Duration: 600ms).
- **Feedback:** Buttons should subtly scale down (0.98) on press, mimicking the physical resistance of a high-end camera shutter.
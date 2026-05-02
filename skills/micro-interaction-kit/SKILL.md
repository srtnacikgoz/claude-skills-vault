---
name: micro-interaction-kit
description: Add premium micro-interactions to any HTML page or web project — magnetic buttons, custom cursor (dot + ring), tilt cards, smooth scroll, hover glow, page transitions, parallax elements. Takes an existing page and upgrades it to feel premium/luxury. Trigger when user says "add micro-interactions", "make this premium", "add animations to my page", "magnetic buttons", "custom cursor", "tilt cards", "smooth scroll effect", or wants to upgrade a page's feel.
---

# Micro Interaction Kit

Add premium micro-interactions to any existing HTML page. Takes a page from "functional" to "luxury feel" by injecting carefully crafted CSS + JS effects.

## Step 0: Analyze the Target

Before adding anything, read the target HTML file and identify:
- Current tech stack (vanilla, React, Next.js, etc.)
- Existing animations (don't duplicate or conflict)
- Color palette (effects should match brand)
- Key interactive elements (buttons, cards, links, images)

## Step 1: Interview

Ask briefly:
- "Which effects do you want?" (show the catalog, let them pick)
- "What's your accent color?" (for glows and highlights)
- If they say "everything" or "make it premium", apply the Premium Pack (see below)

## Available Effects

### Tier 1 — Subtle (always safe to add)
1. **Smooth Scroll** — Lenis-style smooth scrolling with lerp
2. **Fade-on-Scroll** — Elements fade up as they enter viewport (IntersectionObserver)
3. **Hover Lift** — Cards/buttons lift with shadow on hover (CSS transform + box-shadow)

### Tier 2 — Interactive (impressive but tasteful)
4. **Magnetic Buttons** — Buttons subtly follow cursor within a radius (GSAP elastic)
5. **Custom Cursor** — Dot + ring cursor that scales on hover, blends on dark elements
6. **Tilt Cards** — Cards tilt toward cursor with 3D perspective (vanilla JS)
7. **Text Reveal** — Text characters animate in on scroll (staggered, per-character)

### Tier 3 — Bold (use sparingly)
8. **Parallax Elements** — Background elements move at different scroll speeds
9. **Velocity Skew Marquee** — Text marquee that skews based on scroll velocity
10. **Page Transitions** — Smooth fade/slide between page navigations
11. **Blob Background** — Animated gradient blobs behind content (CSS)

### Premium Pack (Tier 1 + Tier 2 all together)
When user wants "make it premium" — apply effects 1-7 as a package.

## Implementation Rules

- **Never break existing functionality** — add effects as progressive enhancement
- **Performance first** — use `will-change`, `transform` (GPU-accelerated), passive listeners
- **Respect prefers-reduced-motion** — disable all animations for users who prefer reduced motion
- **Framework-aware** — if React/Next.js, use useEffect hooks. If vanilla, use DOMContentLoaded.
- **Single injection point** — all effects go in one `<script>` block (or one module) for easy removal

For detailed code patterns of each effect, read `references/effects-catalog.md`.

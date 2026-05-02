---
name: story-weaver
description: Build immersive "About Us" / "Our Story" / brand story pages with scrollytelling, parallax photography, text reveal animations, and timeline sections. Takes brand photos + text and creates an emotional, Apple/Airbnb-quality story page. Trigger when user says "about us page", "our story page", "brand story", "hakkimizda sayfasi", "hikayemiz", "team page", or wants an immersive narrative page for their brand.
---

# Story Weaver

Build an immersive scrollytelling brand story page from photos + text. Single HTML output with parallax, text reveals, and timeline.

## Step 0: Interview (MANDATORY)

- **Brand name** and tagline
- **Brand photos** (3-6 photos: founder, team, workspace, product, milestones)
- **Story text** — the narrative, either:
  - A) User pastes the full text
  - B) User gives bullet points, skill writes the prose
- **Timeline milestones** (optional) — year + event pairs
- **Color palette** (accent, background)
- **Tone** — warm/personal, professional, playful, luxury
- **Logo** file

## Page Sections

1. **Hero** — Full-viewport photo with brand name overlay, subtle parallax on scroll
2. **Opening Statement** — Large serif quote or mission statement, fade-in on scroll
3. **Story Blocks** — Alternating photo-left/text-right, photo-right/text-left sections. Each photo has parallax depth. Text reveals line-by-line on scroll.
4. **Timeline** (optional) — Vertical timeline with milestones, dots connect, entries animate in
5. **Team Grid** (optional) — Team member cards with photo, name, role. Hover reveals bio.
6. **Values/Principles** — 3-4 cards with icon + title + description
7. **CTA** — "Join us" or "Contact" or custom
8. **Footer** — Brand info

## Scroll Effects

- **Parallax photos** — `transform: translateY(calc(var(--scroll) * -0.2))` on images
- **Text reveal** — Lines clip from bottom, reveal as they enter viewport
- **Counter stats** — "10+ yil", "5000+ musteri" type numbers count up
- **Fade sections** — Each section fades in as it enters viewport

For all code patterns, read `references/story-patterns.md`.

## Photography Rules

- Images are the star — minimum 60% of viewport width
- Never compress below visible quality
- Use `object-fit: cover` for consistent framing
- Add subtle vignette overlay on hero image
- Lazy-load images below the fold

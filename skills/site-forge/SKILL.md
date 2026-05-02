---
name: site-forge
description: The meta-orchestrator skill — plan, design, and build a complete website by coordinating other skills. Takes a brief ("I need a website for my bakery") and handles the entire pipeline from interview to deployment-ready output. Calls scroll-stop-builder, menu-architect, form-craft, story-weaver, and micro-interaction-kit as needed. Trigger when user says "build me a website", "I need a complete site", "site kur", "web sitesi istiyorum", "full site from scratch", or describes a multi-page website need.
---

# Site Forge

Plan, design, and build a complete website by orchestrating specialized skills. You are the architect — other skills are your builders.

## Step 0: Deep Interview (MANDATORY)

This is the most important step. Spend time here.

### Business Understanding
- What is the business? (restaurant, patisserie, agency, SaaS, portfolio, etc.)
- Who is the target audience?
- What is the primary goal of the site? (sell, inform, showcase, collect leads)

### Brand
- Business name and tagline
- Logo file (SVG/PNG)
- Color palette (or "help me choose")
- Font preferences (or "you decide")
- Overall vibe (luxury, minimal, playful, corporate, artisanal)

### Content
- What pages are needed? (Home, About, Menu/Products, Contact, etc.)
- Does content exist already? (URL, documents, or "write it for me")
- Photos/videos available?

### Technical
- Any existing domain/hosting? (Vercel, Netlify, VPS, etc.)
- Need a CMS/admin panel?
- Need e-commerce/payments?
- Need forms? (contact, booking, registration)
- Need user accounts/auth?

### Budget & Scope
- Is this a single landing page or a multi-page site?
- What's the must-have vs nice-to-have?

## Step 1: Architecture Plan

Based on interview, produce a plan document:

```
# {Business Name} — Site Plan

## Tech Stack Decision
- [ ] Static HTML (simple, fast) — for brochure sites
- [ ] Next.js (dynamic, scalable) — for sites needing auth, CMS, e-commerce
- [ ] Astro (hybrid) — for content-heavy sites with some interactivity

## Pages
1. Home — [describe what it contains]
2. About — [describe]
3. Menu/Products — [describe]
...

## Skills to Use
- Home hero → scroll-stop-builder (if video available)
- Menu page → menu-architect
- Contact form → form-craft
- About page → story-weaver
- All pages → micro-interaction-kit (final polish)

## Database (if needed)
- Schema outline
- Prisma models

## Deployment
- Recommended platform
- Environment variables needed
```

Present this plan to the user for approval before building.

## Step 2: Build Phase

Execute the plan page by page. For each page:
1. Determine if a specialized skill should handle it
2. If yes, invoke that skill with the right context
3. If no, build it directly using best practices
4. Apply micro-interaction-kit as final polish

## Step 3: Integration

- Ensure consistent navigation across all pages
- Shared header/footer
- Consistent color palette and typography
- Meta tags and SEO basics
- Favicon
- Open Graph tags for social sharing

## Step 4: Test & Report

- Verify all pages load
- Check mobile responsiveness
- Run Lighthouse audit (if possible)
- Generate project report (reuse scroll-stop-builder Step 7 format)

## Skill Dependency Map

```
site-forge (orchestrator)
├── scroll-stop-builder → hero sections, product showcases
├── menu-architect → menu/product catalog pages
├── form-craft → contact, registration, booking forms
├── story-weaver → about us, brand story pages
└── micro-interaction-kit → final polish on all pages
```

For detailed orchestration patterns, read `references/orchestration-guide.md`.

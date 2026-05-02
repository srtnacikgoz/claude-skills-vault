---
name: food-photo-enhancer
description: Generate AI prompts to enhance and beautify food/pastry/bakery product photos. Use when the user has a food photo (cake, croissant, pastry, dessert, bread, tart, chocolate, cupcake, cookie, baklava, simit) and wants to improve it using AI platforms (Nano Banana Pro, Midjourney, DALL-E, Flux, Ideogram, Leonardo, Topaz, Lightroom AI). Triggers — "fotoğrafı güzelleştir", "photo enhance", "yemek fotoğrafı iyileştir", "ürün fotoğrafı düzelt", "bu fotoğrafı profesyonel yap", "food photo prompt", "pasta fotoğrafı", "katalog görseli", or when user shares a food product image wanting improvement.
---

# Food Photo Enhancer

Generate optimized AI prompts for enhancing food/pastry product photography across all product types with catalog-level brand consistency.

## Supported Product Types

This skill covers ALL patisserie/bakery products, not just cakes:

| Category | Products |
|----------|----------|
| **Cakes** | Naked, semi-naked, fully frosted, mousse, cheesecake, opera |
| **Viennoiserie** | Croissant, pain au chocolat, danish, brioche |
| **Tarts** | Fruit tart, chocolate tart, lemon tart, ganache tart |
| **Small pastries** | Cupcake, macaron, eclair, profiterole, muffin |
| **Chocolates** | Praline, truffle, bonbon, tablet, bark |
| **Cookies** | Shortbread, sable, florentine, biscotti |
| **Turkish** | Baklava, simit, tulumba, kunefe, lokum |
| **Bread** | Sourdough, baguette, focaccia, pide |
| **Plated desserts** | Tiramisu, panna cotta, crème brûlée |

## Step 0: Analyze the Photo

1. Read the provided image file
2. Identify the **exact product type** from the table above
3. Identify issues: lighting, background, color balance, composition, sharpness, shadows, reflections
4. Note what's good — preserve these in the prompt

## Step 0.5: Flaw Detection & Correction

Scan for product flaws. Goal: **"En iyi günündeki hali"** — the product on its perfect day.

### CRITICAL: Style Identification First

Correctly identify the product's style and use CONSISTENT terminology throughout. Never mix terms.

For cakes:
| Style | Description | Terminology |
|-------|------------|-------------|
| **Naked** | No frosting on sides, bare layers visible | Always say "naked cake" |
| **Semi-naked** | Thin scraped frosting, layers peek through | Always say "semi-naked cake" |
| **Fully frosted** | Opaque frosting covering all surfaces | Always say "frosted cake" |

**Anti-contradiction rule**: Pick ONE term and use it everywhere.

### CRITICAL: Only Fix What's Actually Wrong

Before adding any fix directive, ask: **"Is this actually a flaw in the image, or does it already look fine?"**

- Do NOT fix things that already look good
- Only mention flaws you can clearly see
- Use enhancement language for borderline cases ("enhance for ultra-fresh sheen") not correction language
- Keep fix directives short and measurable

### Flaw Catalog (use ONLY when clearly visible):

| Flaw | Concise Fix Directive |
|------|----------------------|
| **Frozen/frosty fruit** | "ultra-fresh, glossy berries with natural sheen" |
| **Uneven frosting** | "consistent, expert finish allowing layers to show through cleanly" |
| **Messy side finish** | "smooth professional finish as if applied by a master pastry chef" |
| **Uneven layer filling** | "perfectly even cream filling, consistent thickness throughout" |
| **Melted/drooping** | "firm, structured decoration holding perfect shape" |
| **Crumbs/mess** | "clean presentation, no stray crumbs" |
| **Dull/dry surface** | "fresh, moist appearance with appetizing sheen" |
| **Wilted garnish** | "fresh, vibrant garnish" |
| **Cracked chocolate** | "smooth, tempered chocolate with clean snap lines" |
| **Uneven glaze** | "mirror-smooth glaze with perfect reflection" |
| **Deflated pastry** | "fully risen, airy pastry with visible flaky layers" |

### Portion Realism — "Generous but Elegant"

AI models tend to exaggerate fillings and toppings. Apply these rules for filled products:

**General principle**: Every filling/topping ingredient should be clearly visible, but nothing should overflow or dominate the product. The product's shape is the star, the filling supports it. Up to 20-30% more generous than real portion is acceptable — beyond that looks fake.

| Product | Star element (don't touch) | Filling rule |
|---------|--------------------------|-------------|
| **Croissant sandwich** | Croissant shape & lamination | All fillings visible from the side, nothing spilling out |
| **Cupcake** | Cake body | Cream swirl elegant and proportional, not a mountain |
| **Eclair** | Choux pastry shape | Cream peeking from ends, not bursting |
| **Tart** | Pastry shell edge | Toppings arranged neatly, not piled high |
| **Macaron** | Shell symmetry | Filling at feet level, not squeezing out |
| **Layered cake** | Overall silhouette | Cream between layers even, not oozing |

**Prompt directive**: Always include "realistic elegant portion — all filling ingredients clearly visible but not overflowing, generous but controlled presentation"

### KEEP (artisanal character):

- Organic texture of hand-piped cream — not machine-perfect
- The product's identified style — do not change it
- Natural fruit/ingredient shapes — not plastic-perfect
- Handmade character — slight variations are charm
- Real ingredient look — not airbrushed

## Step 1: Determine Enhancement Goal

| Goal | Description |
|------|------------|
| **Catalog/Menu** | Consistent style across all products — use Brand Baseline |
| **Website hero** | Large format, dramatic, brand-aligned |
| **Social media** | Vibrant, appetizing, trending aesthetic |
| **Lifestyle** | Styled scene with props, natural light |

## Step 2: Brand Baseline (Catalog Consistency)

**CRITICAL for menu/catalog use**: Every product photo MUST share the same visual DNA.

### The Sade Patisserie Brand Baseline

```
BASELINE VARIABLES:
- SURFACE: NO plate, NO tray, NO board. Product resting naturally on an invisible surface — NOT floating or levitating. The product must appear grounded with a natural contact shadow directly beneath it touching the product's base. It should look like the product is sitting on a white table that has been removed in post-production, NOT like it's flying in the air.
- BACKGROUND: transparent PNG. The product's own shadow and light reflections provide all the realism needed. No solid color, no gradient — just the product floating on transparency with its natural shadow.
- LIGHTING: even soft studio lighting, side-lit at 35° angle, 5400K daylight color temperature, no harsh shadows, all details equally visible
- LENS: 85mm equivalent, f/2.8, shallow depth of field
- ANGLE: 45-degree hero angle (default) or eye-level for tall products
- MOOD: minimalist luxury, French patisserie, artisanal elegance
- QUALITY: razor sharp detail, crystal clear, Apple-level product photography
```

When generating prompts for catalog/menu, ALWAYS prepend these baseline variables. This ensures every croissant, tart, cake, and chocolate looks like it belongs in the same brand family.

### Pseudo-Code Prompting (for Nano Banana Pro consistency)

For catalog shoots across multiple products, use variable-based prompts:

```
SETUP = "professional food photography studio, plain solid white surface,
soft even studio lighting at 35° from left, 5400K daylight, 85mm lens,
f/2.8 shallow depth of field, clean white-cream gradient background"

STYLE = "minimalist luxury French patisserie aesthetic, razor sharp detail,
crystal clear, editorial food magazine quality, Apple-level product shot"

PRODUCT = [describe the specific product here]

FIXES = [list only visible flaws]

EXECUTE: Photograph {PRODUCT} in {SETUP}. Apply {STYLE}. {FIXES}.
Show the complete full product from top to base, nothing cropped.
```

## Step 3: Generate Platform-Specific Prompts

See `references/platform-prompts.md` for detailed templates per platform.

**Default platform**: Nano Banana Pro (primary tool for this project)

For Nano Banana Pro, ALWAYS use:
- Natural language prose, NOT keyword lists
- SCASS framework: Subject → Composition → Action → Setting → Style
- Negative constraints as natural language within the prompt body
- guidance: HIGH for strict reference adherence, MID for balanced
- prompt_enhance: OFF (we write precise prompts, don't let AI rewrite)

## Step 4: Output Format

1. **Analysis** — product type + 2-3 visible flaws (only real ones)
2. **Prompts** — Nano Banana Pro first (primary), then others if requested
3. **Tips** — 1-2 shooting tips to avoid the issue next time

## Critical Rules

- **DESCRIBE THE PRODUCT IN DETAIL** — Use rich, specific descriptions of the product's visible features (textures, layers, toppings, colors, shapes). This enables two modes: (1) with reference image for enhancement, (2) without image for generation from scratch. Detailed description produces better results in both modes. But describe what you SEE, not assumptions — if you're unsure of an ingredient, use visual terms instead ("glossy amber dome" not "caramel").
- **FULL PRODUCT VISIBLE** — entire product shown top to base, nothing cropped
- **TRANSPARENT BACKGROUND MANDATORY** — Every output MUST have a transparent/removed background. Always include "transparent background, PNG with alpha channel, no background, product only isolated on nothing" in the prompt. This ensures the image works on any website background color without white box artifacts.
- **NATURAL SHADOW & LIGHT** — The product should have a beautiful, realistic soft shadow beneath it (contact shadow) and natural light reflections on its surface. The cruffin example is the gold standard: soft ground shadow that anchors the product, warm natural light on the surface. Always specify: "natural soft contact shadow beneath the product, warm realistic light reflections on surface"
- **~20% IDEALIZATION ALLOWED** — The AI does NOT need to produce an exact copy of the reference. Up to ~20% deviation is acceptable and encouraged to make the product more flawless. Better proportions, cleaner textures, more vibrant colors — as long as it's recognizably the same product.
- **APPLE-LEVEL CLARITY** — razor sharp, every texture visible
- **EVEN LIGHTING** — no directional light hiding details, all sides equally lit
- **CATALOG CONSISTENCY** — when producing multiple products, use identical Brand Baseline
- **STYLE CONSISTENCY** — never mix terminology (naked ≠ semi-naked)
- **FIX ONLY VISIBLE FLAWS** — do not correct what's already good
- **NO PLATES/TRAYS/SURFACES** — ürün asla tabak, tepsi veya servis ekipmanı üzerinde olmamalı. Ürün görünmez bir yüzeyde doğal şekilde oturuyor olmalı — havada süzülmemeli, uçmamalı. Gölge ürünün tabanına temas etmeli. Promptlarda "floating", "levitating", "suspended" ifadeleri YASAK. Bunun yerine "resting on invisible surface" kullan.
- **NO STEAM/SMOKE** — creates artificial look, always banned
- **NO HUMAN HANDS** — unless explicitly requested by user
- **NO PROPS** — peçete, çatal, bıçak, bardak, dekoratif objeler yasak. Sadece ürün.
- Preserve product identity — enhance, don't replace
- For image-to-image: "maintain exact product shape and proportions"
- For Turkish products: use culturally accurate descriptions

# Platform-Specific Prompt Templates

## Nano Banana Pro (PRIMARY)

**Backend**: Gemini 3 Pro (reasoning-first, NOT keyword-based)
**Syntax**: Natural language prose, full sentences, descriptive adjectives
**Framework**: SCASS — Subject, Composition, Action, Setting, Style

### Optimal Settings

| Parameter | Value | Reason |
|-----------|-------|--------|
| guidance | HIGH | Strict adherence to reference photo |
| prompt_enhance | OFF | Our prompts are precise, don't let AI rewrite |
| image_size | 4K | Maximum detail for catalog/web use |
| aspect_ratio | 4:5 | Instagram/catalog standard |

### Template: Single Product Enhancement

```
SUBJECT: A [exact product type] with [key visible features — describe what you SEE, not what you want to add]. [Only if needed: Fix directives for visible flaws].

COMPOSITION: [45-degree hero shot / eye-level / overhead flat lay], showing the complete full product from top to base with nothing cropped or cut off. Shot with an 85mm lens at f/2.8, shallow depth of field isolating the product.

ACTION: [For static products, describe the appealing state: "resting on surface" / "freshly sliced revealing layers" / "steam gently rising"]

SETTING: Plain solid pure white surface with absolutely no patterns, no marble, no texture. Clean soft white-to-cream gradient background, seamless. Even soft studio lighting at 35 degrees from the left side, 5400K daylight color temperature. No harsh shadows, no blown highlights, all product details equally visible from every angle.

STYLE: Minimalist luxury French patisserie aesthetic. Professional food photography, editorial food magazine quality. Razor sharp detail on every texture — [product-specific textures]. Crystal clear, Apple-level product photography. The product on its perfect day, artisanal and handmade but flawless.

Avoid: no artificial look, no plastic texture, no oversaturated colors, no neon reds, no geometric distortion, no blurry areas, no cropped edges.
```

### Template: Catalog Consistency (multiple products)

Use Pseudo-Code Prompting to maintain brand DNA across all products:

```
STUDIO SETUP: Professional food photography studio. Plain solid pure white surface, no patterns. Even soft studio lighting at 35° from left, 5400K daylight color temperature, no harsh shadows. Clean white-to-cream seamless gradient background. 85mm lens at f/2.8 with shallow depth of field.

BRAND STYLE: Minimalist luxury French patisserie. Razor sharp detail, crystal clear, editorial magazine quality. Apple-level product photography. Artisanal handmade character preserved.

PRODUCT: [Describe this specific product with its visible features]

PHOTOGRAPH this {PRODUCT} in the {STUDIO SETUP}. Apply {BRAND STYLE}. Show the complete full product from top to base, nothing cropped. [Add specific fix directives only for visible flaws].

Avoid: artificial look, plastic texture, oversaturated colors, patterns on surface, cropped product.
```

### Product-Specific Texture Cues

| Product | Key Textures to Emphasize |
|---------|--------------------------|
| **Croissant** | flaky golden layers, buttery sheen, visible lamination, crispy edges |
| **Naked/semi-naked cake** | visible cake layers, cream between layers, berry textures, piping ridges |
| **Chocolate truffle** | smooth tempered shell, cocoa dust particles, clean geometric shape |
| **Tart** | crisp pastry edge, glossy fruit glaze, custard smoothness |
| **Macaron** | smooth dome, ruffled feet, filling peek, matte shell |
| **Eclair** | mirror glaze reflection, choux texture, cream filling visible at ends |
| **Baklava** | phyllo layers, pistachio green, honey glisten, golden crisp edges |
| **Cupcake** | swirled frosting peaks, moist crumb if visible, wrapper texture |
| **Sourdough** | open crumb structure, flour dusting, ear scoring, crust crackle |
| **Cookie** | crackled surface, golden edges, soft center, chocolate chunks |

### Multi-Step Refinement Workflow

Nano Banana Pro excels at conversational refinement. For best results:

1. **Base generation** — Upload photo + full SCASS prompt
2. **Targeted fixes** — "Keep everything but fix the side frosting to be smoother"
3. **Fine-tune** — "Warm up color temperature slightly" or "Sharpen the berry textures"
4. **Final scale** — "Export as 4K"

### Reference Stack for Brand Consistency

When shooting a full catalog, use Reference Stack:
- Upload 2-3 already-approved product photos as references
- Set guidance: HIGH
- This forces all subsequent generations to match the same lighting/mood/style

---

## Midjourney (image-to-image)

```
[uploaded image] enhance this {product_type} photo, professional food photography,
{lighting_fix}, {color_fix}, {background_fix},
soft natural side lighting, shallow depth of field,
editorial food magazine quality, appetizing presentation,
warm color grading, crisp texture detail --ar 4:5 --s 200 --style raw
```

**Negative (--no)**: `artificial, plastic, oversaturated, blurry, stock photo, cropped, patterned surface`

**Key params**:
- `--s 200` for stylization (lower = more faithful)
- `--style raw` for photorealistic
- `--ar 4:5` catalog, `--ar 16:9` website hero, `--ar 1:1` social

---

## DALL-E / ChatGPT (edit mode)

```
Enhance this {product_type} photograph to professional food photography quality.
[Only list fixes for visible flaws].
Keep the exact same product, shape, and composition.
Apply: soft even studio lighting, warm natural tones, shallow depth of field,
plain solid white surface, editorial food magazine aesthetic.
Shot by a professional food photographer, 85mm lens at f/2.8.
Show the complete full product, nothing cropped.
```

---

## Flux (image-to-image)

```
Professional food photography of {product_type}, {key features},
even studio lighting at 35 degrees, 5400K daylight,
plain solid white surface, sharp focus on textures,
{product-specific texture cues},
85mm lens, f/2.8, food magazine editorial quality,
complete full product visible top to base
```

**Guidance scale**: 9-11 | **Strength**: 0.45-0.55 for enhancement

---

## Lightroom (manual adjustments)

Standard food photography baseline:
```
Exposure: +0.2 to +0.4
Highlights: -35
Shadows: +30
Whites: +15
Blacks: -10
Temperature: 5400K
Tint: +5
Texture: +20
Clarity: +15
Vibrance: +10
Dehaze: +5
```

---

## Common Enhancement Scenarios

### Dark/underexposed
- "Brighten with soft fill light, lift shadows, maintain contrast"

### Yellow/warm cast
- "Correct white balance to neutral-warm 5400K"

### Busy background
- "Plain solid white surface, no patterns, shallow depth of field"

### Flat/no depth
- "Side lighting at 35°, rim light on edges"

### Soft/low detail
- "Razor sharp texture detail on every surface"

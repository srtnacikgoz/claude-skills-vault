---
name: scroll-stop-prompter
description: Generate AI image and video prompts for scroll-stopping product content. Creates 3 coordinated prompts — (A) clean assembled product shot, (B) deconstructed/exploded view with floating layers, and (C) video transition between states. Works with any AI image generator (Midjourney, DALL-E, Flux, Ideogram, Leonardo) and video model (Runway, Kling, Pika). Trigger when user says "scroll-stop prompt", "product animation prompt", "exploded view prompt", "deconstructed view prompt", or asks for prompts to create scroll-stopping visual content.
---

# Scroll-Stop Prompter

Generate 3 coordinated prompts for scroll-stopping content: clean product shot, deconstructed/exploded view, and video transition. Deliver in a copyable HTML page.

## Step 0: Confirm the Object

Ask the user what object they want (if not already specified). Good objects:
- Food & beverages (cakes, sandwiches, cocktails, plated dishes)
- Shoes, watches, bags (fashion/luxury)
- Laptops, phones, headphones (tech products)
- Any product with interesting internal components or ingredients

Default to **eLatopse** if unspecified.

## Step 1: Generate Prompt A — Assembled Shot

Clean, hero product image. Professional studio photography on white.

**Template:**
```
Professional product photography of a {OBJECT} centered in frame, shot from a {ANGLE} angle.
Clean white background (#FFFFFF), soft studio lighting with subtle shadow beneath the object.
The {OBJECT} is pristine, fully assembled and complete.
Photorealistic, {ASPECT_RATIO}, sharp focus across entire object, subtle reflections on
glossy surfaces. Minimal, elegant, Apple-style product photography.
No text. No other objects in frame.
```

- `{ANGLE}`: "slightly elevated 3/4" for products, "eye-level" for food
- `{ASPECT_RATIO}`: "16:9" landscape or "4:5" portrait depending on object shape

## Step 2: Generate Prompt B — Deconstructed/Exploded View

Every component floating apart vertically in mid-air.

**Template:**
```
Exploded/deconstructed view of a {OBJECT}. Every layer and component separated and
floating in mid-air with equal spacing, arranged vertically.
From bottom to top: {LAYER_LIST}
Each piece hovers with a slight natural shadow beneath it. Clean white background (#FFFFFF).
Professional product photography, soft studio lighting, photorealistic.
{ASPECT_RATIO}. No text. No other objects. Sharp focus on all floating pieces.
Overall composition suggests the original product shape despite being disassembled.
```

- `{LAYER_LIST}`: Enumerate every layer bottom-to-top with sensory detail

## Step 3: Generate Prompt C — Video Transition

Animate between assembled → deconstructed (or reverse).

**Template:**
```
A {OBJECT} centered on clean white background slowly and smoothly deconstructs.
Camera holds steady at slightly elevated 3/4 angle.
Starting fully assembled, each layer gently lifts upward and separates in sequence
from top to bottom: {LAYER_LIST_REVERSE}.
Motion is slow, elegant, fluid — like zero gravity. Each piece floats with subtle gentle
rotation. Soft studio lighting, photorealistic, smooth cinematic motion.
8 seconds duration. No camera movement. White background throughout.
```

## Step 4: Deliver as HTML

Create `scroll-stop-prompts.html` in the working directory with:
- Title: "{OBJECT} — Scroll-Stop Prompts"
- Three tabbed sections: "A: Assembled", "B: Exploded", "C: Video"
- Each tab: styled code block + "Copy" button
- Confetti animation on copy (inline JS, no external deps)
- Dark background, clean typography
- Self-contained single file

Open in browser for the user.

## Prompt Quality Rules

- Always: "clean white background (#FFFFFF)" — critical for compositing
- Always: "no text on image" — prevent unwanted AI text
- Always specify aspect ratio
- Always: "photorealistic" + "product photography"
- Food: add "glistening", "fresh", "golden-brown", "sugar-dusted"
- Tech: add "brushed aluminum", "matte black", "glass reflection"
- First frame of video MUST start on white background — needed by scroll-stop-builder

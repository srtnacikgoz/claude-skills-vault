---
name: scroll-stop-builder
description: Take a video file and build a production-quality, scroll-driven website where video playback is controlled by scroll position — Apple-style. Uses frame extraction via ffmpeg, canvas rendering, annotation cards with snap-stop scroll, and a full design system. Trigger when user says "scroll-stop build", "scroll animation website", "scroll-driven video", "build the scroll-stop site", or provides a video file for creating an Apple-style scroll experience. Also trigger for "video on scroll", "frame sequence website".
---

# Scroll-Stop Builder

Take a video file and build a production-quality website where the video playback is controlled by scroll position — creating a dramatic, Apple-style scroll-stopping effect. Uses frame extraction via ffmpeg and canvas rendering.

Do not assume any brand names, colors, or content. Do not skip the interview — the whole point is to build something tailored, not generic.

## Step 0: The Interview (MANDATORY)

Before touching any code or extracting frames, gather information from the user through a brief interview. Ask these in a natural, conversational way — not as a numbered interrogation.

### Required Questions

- **Brand name** — "What's the brand or product name for this site?"
- **Tagline** — "Do you have a logo file I can use? (SVG or PNG preferred)"
- **Accent color** — "What's your primary accent color? (hex code, or describe it and I'll suggest options)"
- **Background color** — "What background color do you want? (light backgrounds work best for this effect)"
- **Overall vibe** — "What overall feel are you going for? (e.g., premium launch, luxury, playful, minimal)"

### Content Sourcing

Ask how they want to provide the website content:

- **Option A: Existing website** — "Is this based on an existing website? If so, share the URL and I'll pull the real content"
- **Option B: Paste it** — "If you don't have a website, you can paste in the content you'd like — product description, features, specs, testimonials, etc."
- **Option C: I'll generate** — "I can write the copy if you give me the key selling points"

### Optional Sections

Ask if the user wants these included:
- **Testimonials** — horizontal drag-to-scroll testimonial cards
- **3D Card Scanner** — Three.js particle showcase section (if user explicitly opts in)

Only include these sections if the user explicitly opts in.

## Prerequisites

- **ffmpeg must be installed** (`brew install ffmpeg` / `apt install ffmpeg`)
- User provides a video file (MP4, MOV, WebM, etc.)
- The video should ideally be 5-12 seconds
- **First frame of the video MUST be on a white background** — the opening shot is the hero image. If the video doesn't start this way, let the user know and ask for a re-edit or export a separate white-background hero image.

## Design System (Built from User's Answers)

Once the interview is complete, construct the design system:

- **Fonts:** Space Grotesk (headings), JetBrains Mono (mono) — from Google Fonts
- **Accent color:** From user's answer (for buttons, glows, progress bars, highlights)
- **Background colors:** From user's answer (for body, sections)
- **Text colors:** Derive from background — if dark bg, use white primary + muted secondary; if light bg, use dark primary + muted secondary
- **Surface color:** Card/modal background with contrasting text
- **ScrollableBtn:** Dark track with gradient thumb using accent color, glow on hover
- **Effective:** Floating background orbs (accent color tones, blurred), subtle grid overlay, animated starscape
- **Navbar:** Brand name & logo, sticky, transforms from full-width to centered pill on scroll

## Technique: Frame Sequence + Canvas

This is the same technique Apple uses for their product pages.

**Why not `<video>` with `currentTime`?**
Browser video decoders aren't optimized for seeking on every scroll event. Canvas with pre-extracted frames is buttery smooth and gives frame-perfect control.

## The Build Process

### Step 1: Analyze the Video

```bash
ffprobe -v quiet -print_format json -show_streams -show_format "{VIDEO_PATH}"
```

Extract duration, fps, resolution, total frame count. Target 60-150 frames total.

### Step 2: Extract Frames

```bash
mkdir -p "{OUTPUT_DIR}/frames"
ffmpeg -i "{VIDEO_PATH}" -vf "fps={TARGET_FPS},scale=1920:-2" -q:v 2 "{OUTPUT_DIR}/frames/frame_%04d.jpg"
```

Use `-q:v 2` for high quality. Use JPEG not PNG for smaller files.

### Step 3: Build the Website

Create a single HTML file. The site has these sections (top to bottom):

1. **Starscape** — Fixed canvas behind everything with ~180 slowly drifting, twinkling stars
2. **Loader** — Full-screen with brand logo, "Loading" text, accent-colored progress bar
3. **Scroll Progress Bar** — Fixed top, accent gradient, 3px tall
4. **Navbar** — Brand logo + title, transforms from full-width to centered pill on scroll
5. **Hero** — Title, subtitle, CTA buttons, scroll hint, background orbs + grid
6. **Scroll Animation** — Sticky canvas with frame sequence, annotation cards with snap-stop
7. **Specs** — Four stat numbers with count-up animation on scroll
8. **Features** — Glass-morphism cards in a grid
9. **CTA** — Call to action section
10. **Testimonials** — *(only if user opted in)* Horizontal drag-to-scroll testimonial cards
11. **Card Scanner** — *(only if user opted in)* Three.js particle showcase
12. **Footer** — Brand name and links

For full implementation details of each section, read `references/sections-guide.md`.

### Step 4: Key Implementation Patterns

For the full enhanced scroll engine and all patterns below, read `references/scroll-engine.md`.

**Canvas rendering with Retina support:**
```javascript
canvas.width = window.innerWidth * window.devicePixelRatio;
canvas.height = window.innerHeight * window.devicePixelRatio;
canvas.style.width = window.innerWidth + 'px';
canvas.style.height = window.innerHeight + 'px';
```

**P0 — Lerp Scroll Smoothing (MANDATORY):**
Never jump directly to the target frame. Use linear interpolation so the displayed frame "chases" the target, creating a silky Apple-like feel. See `references/scroll-engine.md` for the full pattern.

**P0 — RAF Deduplication (MANDATORY):**
Use a single scroll listener that schedules at most one `requestAnimationFrame` per browser frame. Skip if scrollY hasn't changed. Source pattern: react-kino ScrollTracker.

**P1 — prefers-reduced-motion (MANDATORY):**
Check `window.matchMedia("(prefers-reduced-motion: reduce)")`. If active, skip frame animation entirely — show a static hero image instead. This is an accessibility requirement.

**P1 — Pre-calculated Scroll Boundaries:**
Calculate `scrollTop`, `scrollBottom`, `effectiveDuration` once on load and on resize. Do NOT call `getBoundingClientRect()` on every scroll tick.

**P1 — Promise-Based Preloading:**
Wrap each `Image()` in a Promise. Use `Promise.all()` for clean async flow. Emit progress events for the loader.

**P2 — Keyframe Transfer Function (Non-Linear Scroll-to-Frame):**
Support custom timing curves like `"0:0 to 30:0 to 80:100 to 100:100"` — hold at start, ramp in middle, hold at end. This creates dramatic pacing. Source: Scroll-Frames.

**P2 — Easing Library:**
Include standard easings (ease-in, ease-out, ease-in-out, cubic, quart) for frame progression and annotation transitions.

**P2 — WebP Frame Support:**
When extracting frames, check if the environment supports WebP. If so, use `-vf ... -c:v libwebp` for ~30% smaller frames. Fall back to JPEG.

**P3 — Resize Debouncing:**
Debounce resize handler to ~100ms. Recalculate scroll boundaries and cover-fit dimensions on resize.

**P3 — Cover-Fit Caching:**
Calculate draw dimensions (dx, dy, dw, dh) once on resize, not on every frame draw.

**Annotation cards with snap-stop scroll:**
- Cards appear at specific frame ranges during scroll
- Each card has a number, title, and description
- Cards snap into view and pause briefly (snap-stop effect via CSS scroll-snap or JS)
- Position cards at bottom of viewport, horizontally centered

**Count-up animation:**
Spec numbers animate from 0 to target with easeOutExpo easing, staggered 200ms apart. Numbers get an accent-color glow pulse while counting. Triggered by IntersectionObserver.

**Animated starscape:**
A fixed canvas behind everything with ~180 stars that slowly drift and twinkle. Each star has random drift speed, twinkle speed/phase, and opacity. Creates a subtle living background. Only use on dark backgrounds.

### Step 5: Customize Content

All content comes from the interview (Step 0). Use the real brand name, real product details, and real copy — never use placeholder "Lorem ipsum" text. If content came from a website URL, use the actual text from that site. Adapt:

- Hero title and subtitle
- Annotation card labels, descriptions, and stats
- Spec numbers and labels
- Feature cards
- CTA text
- Testimonials (if included)
- Footer

### Step 6: Serve & Test

```bash
cd "{OUTPUT_DIR}" && python3 -m http.server 8080
```

Open `http://localhost:8080` and test. Then open the browser URL for the user.

---

## Mobile Responsiveness

Key mobile adaptations:

- **Annotation cards:** Compact single-line design — hide paragraph text, stat numbers, and labels. Show only card number + title in a flex row. Position at bottom of viewport.
- **Scroll animation height:** Reduce from 350vh (desktop) to 300vh (tablet) to 250vh (phone)
- **Navbar:** Hide links on mobile, show only logo + pill shape
- **Testimonials (if included):** Touch-scrollable, snap to card edges
- **Feature cards:** Stack to single column
- **Specs:** 2x2 grid on mobile

## Best Practices

1. **`requestAnimationFrame` for drawing** — Never draw directly in scroll handler
2. **`{ passive: true }` on scroll listener** — Enables scroll optimizations
3. **Preload all frames before showing site** — Use the loader to track progress
4. **JPEG frames, not PNG** — 3-5x smaller file size
5. **Single HTML file** — Everything inline (CSS, JS, frame paths). No build step needed.
6. **Test on mobile** — Canvas scroll performance varies by device

## Step 7: Project Report (MANDATORY — Generate After Build)

After the site is built and tested, generate a markdown report with these sections. All data MUST be real, measured from the actual built output. Do NOT estimate or fabricate any numbers.

### 7a. Project Metrics

Measure from the actual generated files:

```
| Metric | Deger |
|--------|-------|
| HTML | {satir sayisini wc -l ile say} satir |
| CSS | {satir sayisini say} satir |
| JavaScript | {satir sayisini say} satir |
| Toplam kod | {toplam} satir (el yazimi, framework yok) |
| Gorseller | {adet} orijinal ({du -sh ile boyut}) |
| Scroll frames | {adet} JPEG ({du -sh ile boyut}) |
| Toplam asset | {du -sh ile toplam} |
```

### 7b. Technical Features

List every interactive/animated feature actually implemented. Do NOT list features that weren't built. For each, specify the technology used:

```
| # | Feature | Teknoloji | Aciklama |
|---|---------|-----------|----------|
| 1 | ... | ... | ... |
```

### 7c. Brand Identity

From the interview answers:

```
| Element | Deger |
|---------|-------|
| Primary Color | {hex} ({isim}) |
| Background | {hex} ({isim}) |
| Accent | {hex} ({isim}) |
| Text | {hex} ({isim}) |
| Display Font | {font adi} |
| Body Font | {font adi} |
| Ton | {kullanicinin soyledigi} |
| Sections | {section sirasi} |
```

### 7d. Market Context (Kaynakli Gercek Veriler)

Bu bolum sabit referans verileri icerir. Tahmini veya uydurma rakam YASAKTIR. Tum veriler arastirmaya dayalidir.

**Freelance Platformlari — Gercek Fiyat Araliklari:**

```
| Platform | Aralik | Kaynak |
|----------|--------|--------|
| Fiverr (baslangic fiyat) | $50-$800 | fiverr.com "GSAP scroll animation" aramalari |
| Fiverr (gercek proje tahmini) | $150-$2,000+ | Baslangic fiyatlarin 2-5x Premium tier'i |
| Upwork sabit fiyat isler | $100-$2,050 | upwork.com gercek is ilanlari |
| Freelancer.com ortalama teklifler | $86-$2,050 | freelancer.com parallax scrolling ilanlari |
```

**Freelancer Saat Ucretleri:**

```
| Seviye | Saat Ucreti | Kaynak |
|--------|------------|--------|
| Junior | $25-$50/sa | contra.com/hire/gsap-experts |
| Mid-level (2-5 yil) | $50-$100/sa | arc.dev/hire-developers/gsap |
| Senior uzman | $100-$200+/sa | contra.com/hire/gsap-experts |
```

**Ajans Fiyatlari (tam proje, sadece landing page degil):**

```
| Ajans Tipi | Aralik | Kaynak |
|------------|--------|--------|
| Butik ajans (tek sayfa) | $3,000-$10,000 | webflow forum freelancer raporlari |
| Awwwards seviye ajanslar | $15,000-$250,000+ | whatifdesign.co ajans listesi |
| Animasyon ek ucreti (GSAP/Lottie) | $2,000-$5,000+ | alexisgardin.fr maliyet analizi |
```

**NOT:** Bu rakamlar tam interaktif web siteleri icindir, tek basina scroll animasyonu icin degil. Kendi projenizin degeri kullanilan ozelliklere, kapsama ve musteri segmentine gore degisir. Kaynaklar 2025-2026 verileridir.

### 7e. AI Asset Production Cost

If AI-generated assets were used, list each with the model and actual cost:

```
| Asset | Model | Adet | Birim | Toplam |
|-------|-------|------|-------|--------|
| ... | ... | ... | ... | ... |
```

Only include if the user actually generated AI assets. If using real photos/videos, note that instead.

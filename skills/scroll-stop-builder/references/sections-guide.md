# Sections Implementation Guide

Detailed patterns for each section in the scroll-stop website.

## 1. Starscape (Background)

Fixed canvas behind everything. ~180 stars with random properties:

```javascript
const stars = Array.from({ length: 180 }, () => ({
  x: Math.random() * canvas.width,
  y: Math.random() * canvas.height,
  radius: Math.random() * 1.5 + 0.5,
  driftSpeed: Math.random() * 0.3 + 0.1,
  twinkleSpeed: Math.random() * 0.02 + 0.005,
  twinklePhase: Math.random() * Math.PI * 2,
  opacity: Math.random() * 0.5 + 0.3,
}));

function drawStars(time) {
  ctx.clearRect(0, 0, canvas.width, canvas.height);
  stars.forEach(star => {
    star.x += star.driftSpeed * 0.1;
    if (star.x > canvas.width) star.x = 0;
    const twinkle = Math.sin(time * star.twinkleSpeed + star.twinklePhase) * 0.3 + 0.7;
    ctx.globalAlpha = star.opacity * twinkle;
    ctx.beginPath();
    ctx.arc(star.x, star.y, star.radius, 0, Math.PI * 2);
    ctx.fillStyle = '#ffffff';
    ctx.fill();
  });
  requestAnimationFrame(drawStars);
}
```

Only show starscape if background is dark. Skip for light backgrounds.

## 2. Loader

Full-screen overlay shown while frames preload.

```html
<div id="loader" style="position:fixed;inset:0;z-index:9999;display:flex;flex-direction:column;align-items:center;justify-content:center;background:var(--bg)">
  <div style="font-size:1.5rem;font-weight:600;color:var(--text)">{BRAND_NAME}</div>
  <div style="width:200px;height:3px;background:var(--surface);border-radius:2px;margin-top:1.5rem;overflow:hidden">
    <div id="loadbar" style="width:0%;height:100%;background:var(--accent);border-radius:2px;transition:width 0.2s"></div>
  </div>
  <div id="loadpct" style="font-size:0.75rem;color:var(--muted);margin-top:0.75rem">0%</div>
</div>
```

Update progress as frames load. Fade out and remove when 100%.

## 3. Scroll Progress Bar

```html
<div id="progress" style="position:fixed;top:0;left:0;height:3px;z-index:100;background:linear-gradient(to right,var(--accent),var(--accent-light));width:0%;transition:width 0.05s linear"></div>
```

Update width on scroll: `progress.style.width = (scrollY / maxScroll * 100) + '%'`

## 4. Navbar

```html
<nav id="nav" style="position:fixed;top:1rem;left:50%;transform:translateX(-50%);z-index:50;transition:all 0.3s">
  <div style="display:flex;align-items:center;gap:0.75rem;padding:0.5rem 1.5rem;background:rgba(bg,0.8);backdrop-filter:blur(12px);border-radius:999px;border:1px solid var(--border)">
    <span style="font-weight:600">{BRAND_NAME}</span>
  </div>
</nav>
```

Starts full-width, transforms to centered pill on scroll (after hero passes).

## 5. Hero Section

```
[Title — large serif or display font]
[Subtitle — smaller, muted]
[CTA Button — accent color, rounded-full]
[Scroll hint — animated down arrow]
```

Background effects: floating accent-colored orbs (blurred, low opacity) + subtle dot grid.

## 6. Scroll Animation (CORE)

The main canvas-based frame sequence:

```javascript
const canvas = document.getElementById('scrollCanvas');
const ctx = canvas.getContext('2d');
const frames = [];
const TOTAL = {FRAME_COUNT};

// Preload
for (let i = 1; i <= TOTAL; i++) {
  const img = new Image();
  img.src = `frames/frame_${String(i).padStart(4, '0')}.jpg`;
  img.onload = () => { loadedCount++; updateLoader(); };
  frames.push(img);
}

// Scroll handler
window.addEventListener('scroll', () => {
  requestAnimationFrame(() => {
    const section = document.getElementById('scrollSection');
    const rect = section.getBoundingClientRect();
    const progress = Math.max(0, Math.min(1, -rect.top / (section.scrollHeight - window.innerHeight)));
    const frameIdx = Math.min(TOTAL - 1, Math.floor(progress * TOTAL));
    drawFrame(frameIdx);
    updateAnnotations(frameIdx);
  });
}, { passive: true });

function drawFrame(idx) {
  const img = frames[idx];
  if (!img?.complete) return;
  const dpr = devicePixelRatio || 1;
  canvas.width = innerWidth * dpr;
  canvas.height = innerHeight * dpr;
  canvas.style.width = innerWidth + 'px';
  canvas.style.height = innerHeight + 'px';
  ctx.scale(dpr, dpr);
  // Cover-fit
  const iR = img.naturalWidth / img.naturalHeight;
  const cR = innerWidth / innerHeight;
  let dw, dh, dx, dy;
  if (iR > cR) { dh=innerHeight; dw=dh*iR; dx=(innerWidth-dw)/2; dy=0; }
  else { dw=innerWidth; dh=dw/iR; dx=0; dy=(innerHeight-dh)/2; }
  ctx.drawImage(img, dx, dy, dw, dh);
}
```

Scroll section height: 350vh (desktop), 300vh (tablet), 250vh (phone).

### Annotation Cards

Cards that appear at specific frame ranges:

```javascript
const annotations = [
  { start: 5, end: 25, num: "01", title: "...", desc: "..." },
  { start: 25, end: 50, num: "02", title: "...", desc: "..." },
  // ...
];

function updateAnnotations(frame) {
  annotations.forEach((ann, i) => {
    const el = document.getElementById(`ann-${i}`);
    const visible = frame >= ann.start && frame <= ann.end;
    el.style.opacity = visible ? 1 : 0;
    el.style.transform = visible ? 'translateY(0)' : 'translateY(20px)';
  });
}
```

Card style: glass-morphism (semi-transparent bg, backdrop-filter blur, subtle border).
Position: bottom-center of viewport, fixed within the sticky container.

## 7. Specs Section

Four stat numbers in a row. Each counts up from 0 when scrolled into view.

```javascript
function countUp(el, target, duration = 2000) {
  const start = performance.now();
  function update(now) {
    const progress = Math.min((now - start) / duration, 1);
    const eased = 1 - Math.pow(1 - progress, 4); // easeOutQuart
    el.textContent = Math.floor(eased * target);
    if (progress < 1) requestAnimationFrame(update);
  }
  requestAnimationFrame(update);
}
```

Trigger with IntersectionObserver. Add accent-color glow while counting.

## 8. Features Section

Grid of cards (2-3 columns). Each card:
- Glass-morphism background
- Icon or emoji
- Title
- Short description

## 9. CTA Section

Centered text + large accent-colored button. Keep simple.

## 10. Testimonials (Optional)

Horizontal scrollable container with drag support:

```javascript
let isDown = false, startX, scrollLeft;
container.addEventListener('mousedown', e => { isDown=true; startX=e.pageX-container.offsetLeft; scrollLeft=container.scrollLeft; });
container.addEventListener('mouseleave', () => isDown=false);
container.addEventListener('mouseup', () => isDown=false);
container.addEventListener('mousemove', e => { if(!isDown) return; e.preventDefault(); container.scrollLeft=scrollLeft-(e.pageX-container.offsetLeft-startX)*2; });
```

CSS scroll-snap for touch: `scroll-snap-type: x mandatory` on container, `scroll-snap-align: center` on cards.

## 11. Card Scanner (Optional)

Three.js particle system. Only include if user explicitly opts in. Creates a rotating particle cloud shaped like the product.

## 12. Footer

Simple: brand name, year, minimal links. Matches overall design system.

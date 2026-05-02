# Enhanced Scroll Engine — Implementation Reference

Core scroll-driven frame sequence patterns extracted from:
- [olivier3lanc/Scroll-Frames](https://github.com/olivier3lanc/Scroll-Frames) — keyframe transfer functions
- [btahir/react-kino](https://github.com/btahir/react-kino) — ScrollTracker, RAF dedup, a11y
- [m5kr1pka/canvas-scroll-clip](https://github.com/m5kr1pka/canvas-scroll-clip) — preloading, boundary caching
- [ghepting/javascript-video-scrubber](https://github.com/ghepting/javascript-video-scrubber) — lerp smoothing

## 1. Lerp Scroll Smoothing (P0)

The single most impactful improvement. Without it, fast scrolling causes jarring frame jumps.

```javascript
let currentFrame = 0;   // what's displayed (smooth)
let targetFrame = 0;    // where scroll says we should be (instant)
let isAnimating = false;
const LERP_FACTOR = 0.15; // 0.1 = very smooth/slow, 0.3 = responsive, 0.15 = balanced

function onScrollUpdate(progress) {
  targetFrame = progress * (TOTAL_FRAMES - 1);
  if (!isAnimating) {
    isAnimating = true;
    smoothLoop();
  }
}

function smoothLoop() {
  currentFrame += (targetFrame - currentFrame) * LERP_FACTOR;
  drawFrame(Math.round(currentFrame));

  // Keep animating until settled (within 0.5 frame of target)
  if (Math.abs(targetFrame - currentFrame) > 0.5) {
    requestAnimationFrame(smoothLoop);
  } else {
    currentFrame = targetFrame;
    drawFrame(Math.round(currentFrame));
    isAnimating = false;
  }
}
```

**Key insight:** `step += (target - step) * factor` is exponential decay — it moves 15% of the remaining distance each frame. Fast at first, slows near target. This is what makes Apple pages feel "premium."

## 2. RAF Deduplication + Passive Scroll (P0)

Single scroll listener, one RAF per browser frame, skip if unchanged.

```javascript
const scrollState = {
  y: 0,
  lastY: -1,
  rafId: null,
  listeners: new Set()
};

function initScrollTracker() {
  window.addEventListener('scroll', () => {
    scrollState.y = window.scrollY;
    if (scrollState.rafId === null) {
      scrollState.rafId = requestAnimationFrame(tick);
    }
  }, { passive: true });
}

function tick() {
  scrollState.rafId = null;
  if (scrollState.y !== scrollState.lastY) {
    scrollState.lastY = scrollState.y;
    scrollState.listeners.forEach(fn => fn(scrollState.y));
  }
}

// Usage:
scrollState.listeners.add((scrollY) => {
  const progress = getScrollProgress(scrollY);
  onScrollUpdate(progress);
  updateAnnotations(progress);
  updateProgressBar(scrollY);
});
```

## 3. Pre-Calculated Scroll Boundaries (P1)

Calculate once, reuse on every scroll tick.

```javascript
let scrollBounds = { top: 0, bottom: 0, effectiveDuration: 0 };

function calculateBounds() {
  const section = document.getElementById('scrollSection');
  const rect = section.getBoundingClientRect();
  const scrollTop = window.scrollY;
  scrollBounds.top = rect.top + scrollTop;
  scrollBounds.bottom = rect.bottom + scrollTop;
  scrollBounds.effectiveDuration = scrollBounds.bottom - scrollBounds.top - window.innerHeight;
}

function getScrollProgress(scrollY) {
  const localScroll = scrollY - scrollBounds.top;
  return Math.max(0, Math.min(1, localScroll / scrollBounds.effectiveDuration));
}

// Recalculate on resize (debounced)
let resizeTimer;
window.addEventListener('resize', () => {
  clearTimeout(resizeTimer);
  resizeTimer = setTimeout(() => {
    calculateBounds();
    recalculateCoverFit();
  }, 100);
});

// Calculate once after images load
calculateBounds();
```

## 4. Promise-Based Preloading (P1)

```javascript
function preloadFrames(totalFrames, pathPattern) {
  let loaded = 0;
  const promises = [];

  for (let i = 1; i <= totalFrames; i++) {
    const num = String(i).padStart(4, '0');
    const promise = new Promise((resolve, reject) => {
      const img = new Image();
      img.onload = () => {
        loaded++;
        updateLoader(loaded, totalFrames);
        resolve(img);
      };
      img.onerror = () => reject(new Error(`Frame ${num} failed`));
      img.src = pathPattern.replace('{NUM}', num);
    });
    promises.push(promise);
  }

  return Promise.all(promises);
}

// Usage:
preloadFrames(96, 'frames/frame_{NUM}.jpg').then(images => {
  window.frames = images;
  hideLoader();
  calculateBounds();
  initScrollTracker();
});
```

## 5. prefers-reduced-motion (P1)

```javascript
function prefersReducedMotion() {
  return window.matchMedia('(prefers-reduced-motion: reduce)').matches;
}

// On init:
if (prefersReducedMotion()) {
  // Show static first frame, skip all scroll animation
  const img = new Image();
  img.onload = () => {
    drawFrame(0); // Just draw first frame
    hideLoader();
  };
  img.src = 'frames/frame_0001.jpg';
  // Make scroll section normal height (not 400vh)
  document.getElementById('scrollSection').style.height = 'auto';
} else {
  // Normal frame sequence initialization
  preloadFrames(96, 'frames/frame_{NUM}.jpg').then(init);
}
```

## 6. Keyframe Transfer Function (P2)

Non-linear scroll-to-frame mapping. Allows "hold" zones and "fast" zones.

```javascript
// Keyframes string: "scrollPercent:framePercent to scrollPercent:framePercent"
// Example: "0:0 to 20:0 to 80:100 to 100:100"
//   0-20% scroll: stay on frame 0 (hold/pause zone)
//   20-80% scroll: play all frames (animation zone)
//   80-100% scroll: stay on last frame (hold zone)

function buildTransferFunction(keyframesStr) {
  const points = keyframesStr.split(' to ').map(p => {
    const [x, y] = p.split(':').map(Number);
    return { x: x / 100, y: y / 100 };
  });

  return function(scrollProgress) {
    // Find which segment we're in
    for (let i = 0; i < points.length - 1; i++) {
      if (scrollProgress >= points[i].x && scrollProgress <= points[i + 1].x) {
        const segmentProgress = (scrollProgress - points[i].x) / (points[i + 1].x - points[i].x);
        return points[i].y + segmentProgress * (points[i + 1].y - points[i].y);
      }
    }
    return points[points.length - 1].y;
  };
}

// Usage:
const transfer = buildTransferFunction('0:0 to 15:0 to 85:100 to 100:100');
// In scroll handler:
const frameProgress = transfer(scrollProgress);
const targetFrame = frameProgress * (TOTAL_FRAMES - 1);
```

**When to use:** When annotation cards need time to be read. Create a "hold" zone where scroll continues but frame stays still, giving the user time to read the card.

## 7. Easing Library (P2)

```javascript
const easings = {
  linear: t => t,
  easeInQuad: t => t * t,
  easeOutQuad: t => t * (2 - t),
  easeInOutQuad: t => t < 0.5 ? 2 * t * t : -1 + (4 - 2 * t) * t,
  easeInCubic: t => t * t * t,
  easeOutCubic: t => { const t1 = t - 1; return t1 * t1 * t1 + 1; },
  easeInOutCubic: t => t < 0.5 ? 4 * t * t * t : (t - 1) * (2 * t - 2) * (2 * t - 2) + 1,
  easeOutQuart: t => 1 - Math.pow(1 - t, 4),
  easeOutExpo: t => t === 1 ? 1 : 1 - Math.pow(2, -10 * t),
};

// Apply to scroll progress before frame mapping:
const easedProgress = easings.easeInOutCubic(scrollProgress);
const targetFrame = easedProgress * (TOTAL_FRAMES - 1);
```

## 8. Cover-Fit Caching (P3)

```javascript
let drawParams = { dx: 0, dy: 0, dw: 0, dh: 0 };

function recalculateCoverFit() {
  if (!window.frames || !window.frames[0]) return;
  const img = window.frames[0];
  const cW = window.innerWidth;
  const cH = window.innerHeight;
  const iR = img.naturalWidth / img.naturalHeight;
  const cR = cW / cH;

  if (iR > cR) {
    drawParams.dh = cH;
    drawParams.dw = cH * iR;
    drawParams.dx = (cW - drawParams.dw) / 2;
    drawParams.dy = 0;
  } else {
    drawParams.dw = cW;
    drawParams.dh = cW / iR;
    drawParams.dx = 0;
    drawParams.dy = (cH - drawParams.dh) / 2;
  }
}

function drawFrame(index) {
  const img = window.frames[index];
  if (!img) return;
  const dpr = window.devicePixelRatio || 1;
  ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
  ctx.drawImage(img, drawParams.dx, drawParams.dy, drawParams.dw, drawParams.dh);
}
```

## 9. WebP Frame Extraction (P2)

```bash
# Check if ffmpeg supports libwebp
ffmpeg -codecs 2>/dev/null | grep webp

# If supported, extract as WebP (~30% smaller than JPEG)
ffmpeg -i "{VIDEO}" -vf "fps=12,scale=1080:-2" -c:v libwebp -quality 85 "{OUT}/frames/frame_%04d.webp"

# Fallback to JPEG if WebP not supported
ffmpeg -i "{VIDEO}" -vf "fps=12,scale=1080:-2" -q:v 2 "{OUT}/frames/frame_%04d.jpg"
```

In JavaScript, detect WebP support:
```javascript
function supportsWebP() {
  const canvas = document.createElement('canvas');
  return canvas.toDataURL('image/webp').startsWith('data:image/webp');
}

const EXT = supportsWebP() ? 'webp' : 'jpg';
const framePath = `frames/frame_{NUM}.${EXT}`;
```

## Complete Integration Example

```javascript
// === INIT ===
const TOTAL = 96;
const LERP = 0.15;
const KEYFRAMES = '0:0 to 10:0 to 90:100 to 100:100'; // hold-play-hold

let currentFrame = 0, targetFrame = 0, isAnimating = false;
let frames = [];
const transfer = buildTransferFunction(KEYFRAMES);

if (prefersReducedMotion()) {
  showStaticPoster();
} else {
  preloadFrames(TOTAL, 'frames/frame_{NUM}.jpg').then(imgs => {
    frames = imgs;
    hideLoader();
    calculateBounds();
    recalculateCoverFit();
    initScrollTracker();
  });
}

// === SCROLL ===
scrollState.listeners.add((scrollY) => {
  const rawProgress = getScrollProgress(scrollY);
  const frameProgress = transfer(rawProgress);
  targetFrame = frameProgress * (TOTAL - 1);
  if (!isAnimating) { isAnimating = true; smoothLoop(); }
  updateAnnotations(rawProgress);
  updateProgressBar(scrollY);
});

// === DRAW LOOP ===
function smoothLoop() {
  currentFrame += (targetFrame - currentFrame) * LERP;
  drawFrame(Math.round(currentFrame));
  if (Math.abs(targetFrame - currentFrame) > 0.5) {
    requestAnimationFrame(smoothLoop);
  } else {
    currentFrame = targetFrame;
    drawFrame(Math.round(currentFrame));
    isAnimating = false;
  }
}
```

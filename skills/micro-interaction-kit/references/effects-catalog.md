# Effects Catalog — Copy-Paste Ready Code

## 1. Smooth Scroll (Lenis-style Lerp)

```js
// Smooth scroll with lerp — no dependencies
class SmoothScroll {
  constructor() {
    this.current = window.scrollY;
    this.target = window.scrollY;
    this.ease = 0.08;
    this.rafId = null;
    this.dom = { scrollable: document.querySelector('[data-scroll-container]') || document.body };
    this.init();
  }
  init() {
    document.body.style.height = `${this.dom.scrollable.scrollHeight}px`;
    if (this.dom.scrollable !== document.body) {
      this.dom.scrollable.style.position = 'fixed';
      this.dom.scrollable.style.top = 0;
      this.dom.scrollable.style.left = 0;
      this.dom.scrollable.style.width = '100%';
    }
    window.addEventListener('scroll', () => { this.target = window.scrollY; }, { passive: true });
    this.animate();
  }
  lerp(start, end, factor) { return start + (end - start) * factor; }
  animate() {
    this.current = this.lerp(this.current, this.target, this.ease);
    if (Math.abs(this.current - this.target) > 0.5) {
      this.dom.scrollable.style.transform = `translate3d(0, ${-this.current}px, 0)`;
    }
    this.rafId = requestAnimationFrame(() => this.animate());
  }
  destroy() { cancelAnimationFrame(this.rafId); }
}
// Usage: new SmoothScroll();
```

## 2. Fade-on-Scroll (IntersectionObserver)

```js
// Add [data-fade] attribute to any element you want to fade in
function initFadeOnScroll() {
  const elements = document.querySelectorAll('[data-fade]');
  elements.forEach(el => {
    el.style.opacity = '0';
    el.style.transform = 'translateY(30px)';
    el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
  });
  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        const delay = entry.target.dataset.fadeDelay || 0;
        setTimeout(() => {
          entry.target.style.opacity = '1';
          entry.target.style.transform = 'translateY(0)';
        }, delay);
        observer.unobserve(entry.target);
      }
    });
  }, { threshold: 0.15, rootMargin: '0px 0px -50px 0px' });
  elements.forEach(el => observer.observe(el));
}
// Usage: initFadeOnScroll(); + add data-fade data-fade-delay="200" to elements
```

## 3. Hover Lift (CSS Only)

```css
/* Add class .hover-lift to cards/buttons */
.hover-lift {
  transition: transform 0.3s cubic-bezier(0.34, 1.56, 0.64, 1),
              box-shadow 0.3s ease;
  will-change: transform;
}
.hover-lift:hover {
  transform: translateY(-6px);
  box-shadow: 0 12px 40px rgba(0, 0, 0, 0.12),
              0 4px 12px rgba(0, 0, 0, 0.08);
}
.hover-lift:active {
  transform: translateY(-2px);
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
}
@media (prefers-reduced-motion: reduce) {
  .hover-lift { transition: none; }
  .hover-lift:hover { transform: none; box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
}
```

## 4. Magnetic Buttons

```js
// Magnetic effect — button subtly follows cursor within radius
function initMagneticButtons() {
  const buttons = document.querySelectorAll('[data-magnetic]');
  buttons.forEach(btn => {
    const strength = parseFloat(btn.dataset.magneticStrength) || 0.3;
    const radius = parseFloat(btn.dataset.magneticRadius) || 100;
    btn.style.transition = 'transform 0.3s cubic-bezier(0.23, 1, 0.32, 1)';
    btn.addEventListener('mousemove', (e) => {
      const rect = btn.getBoundingClientRect();
      const cx = rect.left + rect.width / 2;
      const cy = rect.top + rect.height / 2;
      const dx = e.clientX - cx;
      const dy = e.clientY - cy;
      const dist = Math.sqrt(dx * dx + dy * dy);
      if (dist < radius) {
        btn.style.transform = `translate(${dx * strength}px, ${dy * strength}px)`;
      }
    });
    btn.addEventListener('mouseleave', () => {
      btn.style.transform = 'translate(0, 0)';
    });
  });
}
// Usage: <button data-magnetic data-magnetic-strength="0.3">Click me</button>
```

## 5. Custom Cursor (Dot + Ring)

```css
.cursor-dot {
  position: fixed; top: 0; left: 0; z-index: 99999;
  width: 8px; height: 8px; border-radius: 50%;
  background: var(--accent, #000);
  pointer-events: none; mix-blend-mode: difference;
  transition: transform 0.1s ease;
}
.cursor-ring {
  position: fixed; top: 0; left: 0; z-index: 99998;
  width: 36px; height: 36px; border-radius: 50%;
  border: 1.5px solid var(--accent, #000);
  pointer-events: none; mix-blend-mode: difference;
  transition: transform 0.15s ease, width 0.3s ease, height 0.3s ease;
}
.cursor-ring.hovering {
  width: 56px; height: 56px; opacity: 0.5;
}
@media (pointer: coarse) {
  .cursor-dot, .cursor-ring { display: none; }
}
```

```js
function initCustomCursor() {
  const dot = document.createElement('div'); dot.className = 'cursor-dot';
  const ring = document.createElement('div'); ring.className = 'cursor-ring';
  document.body.append(dot, ring);
  document.body.style.cursor = 'none';
  let mouseX = 0, mouseY = 0, ringX = 0, ringY = 0;
  document.addEventListener('mousemove', (e) => {
    mouseX = e.clientX; mouseY = e.clientY;
    dot.style.transform = `translate(${mouseX - 4}px, ${mouseY - 4}px)`;
  });
  function animateRing() {
    ringX += (mouseX - ringX) * 0.15;
    ringY += (mouseY - ringY) * 0.15;
    ring.style.transform = `translate(${ringX - 18}px, ${ringY - 18}px)`;
    requestAnimationFrame(animateRing);
  }
  animateRing();
  const hoverEls = document.querySelectorAll('a, button, [data-cursor-hover]');
  hoverEls.forEach(el => {
    el.style.cursor = 'none';
    el.addEventListener('mouseenter', () => ring.classList.add('hovering'));
    el.addEventListener('mouseleave', () => ring.classList.remove('hovering'));
  });
}
```

## 6. Tilt Cards (3D Perspective)

```js
function initTiltCards() {
  const cards = document.querySelectorAll('[data-tilt]');
  cards.forEach(card => {
    const maxTilt = parseFloat(card.dataset.tiltMax) || 10;
    const perspective = card.dataset.tiltPerspective || '1000px';
    card.style.transformStyle = 'preserve-3d';
    card.style.transition = 'transform 0.1s ease';
    card.addEventListener('mousemove', (e) => {
      const rect = card.getBoundingClientRect();
      const x = (e.clientX - rect.left) / rect.width - 0.5;
      const y = (e.clientY - rect.top) / rect.height - 0.5;
      const rotateX = -y * maxTilt;
      const rotateY = x * maxTilt;
      card.style.transform = `perspective(${perspective}) rotateX(${rotateX}deg) rotateY(${rotateY}deg) scale3d(1.02, 1.02, 1.02)`;
    });
    card.addEventListener('mouseleave', () => {
      card.style.transform = `perspective(${perspective}) rotateX(0deg) rotateY(0deg) scale3d(1, 1, 1)`;
      card.style.transition = 'transform 0.5s cubic-bezier(0.23, 1, 0.32, 1)';
    });
    card.addEventListener('mouseenter', () => {
      card.style.transition = 'transform 0.1s ease';
    });
  });
}
// Usage: <div data-tilt data-tilt-max="12">...</div>
```

## 7. Text Reveal (Per-Character on Scroll)

```js
function initTextReveal() {
  const elements = document.querySelectorAll('[data-text-reveal]');
  elements.forEach(el => {
    const text = el.textContent;
    el.innerHTML = '';
    el.style.overflow = 'hidden';
    [...text].forEach((char, i) => {
      const span = document.createElement('span');
      span.textContent = char === ' ' ? '\u00A0' : char;
      span.style.display = 'inline-block';
      span.style.opacity = '0';
      span.style.transform = 'translateY(100%)';
      span.style.transition = `opacity 0.4s ease ${i * 0.03}s, transform 0.4s ease ${i * 0.03}s`;
      el.appendChild(span);
    });
  });
  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.querySelectorAll('span').forEach(span => {
          span.style.opacity = '1';
          span.style.transform = 'translateY(0)';
        });
        observer.unobserve(entry.target);
      }
    });
  }, { threshold: 0.3 });
  elements.forEach(el => observer.observe(el));
}
// Usage: <h2 data-text-reveal>Hello World</h2>
```

## 8. Parallax Elements

```js
function initParallax() {
  const elements = document.querySelectorAll('[data-parallax]');
  function updateParallax() {
    const scrollY = window.scrollY;
    elements.forEach(el => {
      const speed = parseFloat(el.dataset.parallaxSpeed) || 0.2;
      const rect = el.getBoundingClientRect();
      const centerY = rect.top + rect.height / 2;
      const viewCenter = window.innerHeight / 2;
      const offset = (centerY - viewCenter) * speed;
      el.style.transform = `translate3d(0, ${offset}px, 0)`;
    });
    requestAnimationFrame(updateParallax);
  }
  updateParallax();
}
// Usage: <div data-parallax data-parallax-speed="0.3">...</div>
```

## 9. Velocity Skew Marquee

```js
function initSkewMarquee() {
  const marquees = document.querySelectorAll('[data-marquee]');
  let lastScroll = window.scrollY;
  let velocity = 0;
  marquees.forEach(marquee => {
    const content = marquee.innerHTML;
    marquee.innerHTML = `<div class="marquee-track">${content}${content}${content}</div>`;
    const track = marquee.querySelector('.marquee-track');
    track.style.display = 'flex';
    track.style.whiteSpace = 'nowrap';
    track.style.willChange = 'transform';
    let offset = 0;
    const speed = parseFloat(marquee.dataset.marqueeSpeed) || 1;
    function animate() {
      const currentScroll = window.scrollY;
      velocity = currentScroll - lastScroll;
      lastScroll = currentScroll;
      offset -= speed;
      const totalWidth = track.scrollWidth / 3;
      if (Math.abs(offset) >= totalWidth) offset = 0;
      const skew = Math.max(-15, Math.min(15, velocity * 0.3));
      track.style.transform = `translateX(${offset}px) skewX(${skew}deg)`;
      requestAnimationFrame(animate);
    }
    animate();
  });
}
// Usage: <div data-marquee data-marquee-speed="1.5"><span>TEXT HERE &mdash; </span></div>
```

## 10. Page Transitions

```js
function initPageTransitions() {
  const overlay = document.createElement('div');
  overlay.id = 'page-transition';
  overlay.style.cssText = `
    position:fixed; top:0; left:0; width:100%; height:100%;
    background:var(--bg, #fff); z-index:100000; pointer-events:none;
    opacity:0; transition: opacity 0.4s ease;
  `;
  document.body.appendChild(overlay);
  // Fade in on load
  overlay.style.opacity = '1';
  window.addEventListener('load', () => {
    setTimeout(() => { overlay.style.opacity = '0'; }, 100);
  });
  // Intercept link clicks
  document.querySelectorAll('a[href]').forEach(link => {
    const href = link.getAttribute('href');
    if (!href || href.startsWith('#') || href.startsWith('mailto:') || href.startsWith('tel:') || link.target === '_blank') return;
    link.addEventListener('click', (e) => {
      e.preventDefault();
      overlay.style.opacity = '1';
      overlay.style.pointerEvents = 'all';
      setTimeout(() => { window.location.href = href; }, 400);
    });
  });
}
```

## 11. Blob Background (CSS Only)

```css
.blob-container {
  position: fixed; top: 0; left: 0; width: 100%; height: 100%;
  z-index: -1; overflow: hidden;
  filter: blur(80px);
}
.blob {
  position: absolute;
  border-radius: 50%;
  opacity: 0.5;
  animation: blob-float 12s ease-in-out infinite alternate;
}
.blob-1 {
  width: 400px; height: 400px;
  background: var(--accent, #6366f1);
  top: 10%; left: 20%;
  animation-delay: 0s;
}
.blob-2 {
  width: 300px; height: 300px;
  background: var(--accent-2, #ec4899);
  top: 50%; right: 15%;
  animation-delay: -4s;
}
.blob-3 {
  width: 350px; height: 350px;
  background: var(--accent-3, #06b6d4);
  bottom: 10%; left: 40%;
  animation-delay: -8s;
}
@keyframes blob-float {
  0%   { transform: translate(0, 0) scale(1); }
  33%  { transform: translate(30px, -50px) scale(1.1); }
  66%  { transform: translate(-20px, 20px) scale(0.9); }
  100% { transform: translate(10px, -30px) scale(1.05); }
}
@media (prefers-reduced-motion: reduce) {
  .blob { animation: none; }
}
```

```html
<!-- Usage: place this at the top of <body> -->
<div class="blob-container">
  <div class="blob blob-1"></div>
  <div class="blob blob-2"></div>
  <div class="blob blob-3"></div>
</div>
```

## Reduced Motion Wrapper

Always wrap your initialization in this check:

```js
const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

document.addEventListener('DOMContentLoaded', () => {
  if (!prefersReducedMotion) {
    initFadeOnScroll();
    initMagneticButtons();
    initCustomCursor();
    initTiltCards();
    initTextReveal();
    initParallax();
    initSkewMarquee();
    initPageTransitions();
  }
  // SmoothScroll and blob background can be initialized regardless
  // (blob is CSS-only with its own prefers-reduced-motion)
});
```

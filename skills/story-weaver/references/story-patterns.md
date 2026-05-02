# Story Patterns — Copy-Paste Ready Code

## Parallax Hero Section

```css
.story-hero {
  position: relative;
  height: 100vh;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
}
.story-hero-img {
  position: absolute;
  top: -10%;
  left: 0;
  width: 100%;
  height: 120%;
  object-fit: cover;
  will-change: transform;
}
.story-hero-overlay {
  position: absolute;
  inset: 0;
  background: linear-gradient(
    to bottom,
    rgba(0,0,0,0.2) 0%,
    rgba(0,0,0,0.5) 100%
  );
}
.story-hero-content {
  position: relative;
  z-index: 2;
  text-align: center;
  color: #fff;
}
.story-hero-title {
  font-family: 'Playfair Display', serif;
  font-size: clamp(2.5rem, 6vw, 5rem);
  font-weight: 700;
  margin: 0 0 16px;
  letter-spacing: -0.02em;
}
.story-hero-tagline {
  font-size: clamp(1rem, 2vw, 1.3rem);
  font-weight: 300;
  opacity: 0.85;
  letter-spacing: 0.1em;
  text-transform: uppercase;
}
```

```js
// Parallax scroll on hero image
function initHeroParallax() {
  const img = document.querySelector('.story-hero-img');
  if (!img) return;
  window.addEventListener('scroll', () => {
    const scrolled = window.scrollY;
    const rate = scrolled * 0.4;
    img.style.transform = `translate3d(0, ${rate}px, 0)`;
  }, { passive: true });
}
```

## Text Reveal on Scroll (Line by Line)

```css
.text-reveal-line {
  overflow: hidden;
}
.text-reveal-line span {
  display: inline-block;
  transform: translateY(110%);
  transition: transform 0.8s cubic-bezier(0.23, 1, 0.32, 1);
}
.text-reveal-line.visible span {
  transform: translateY(0);
}
```

```js
function initTextReveal() {
  const paragraphs = document.querySelectorAll('[data-reveal-text]');
  paragraphs.forEach(p => {
    const text = p.innerHTML;
    const lines = text.split('<br>').length > 1
      ? text.split('<br>')
      : text.split('. ').map((s, i, arr) => i < arr.length - 1 ? s + '.' : s);
    p.innerHTML = lines.map(line =>
      `<div class="text-reveal-line"><span>${line.trim()}</span></div>`
    ).join('');
  });
  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        const lines = entry.target.querySelectorAll('.text-reveal-line');
        lines.forEach((line, i) => {
          setTimeout(() => line.classList.add('visible'), i * 150);
        });
        observer.unobserve(entry.target);
      }
    });
  }, { threshold: 0.2 });
  paragraphs.forEach(p => observer.observe(p));
}
```

## Vertical Timeline

```html
<section class="timeline">
  <div class="timeline-line"></div>
  <div class="timeline-entry" data-year="2018">
    <div class="timeline-dot"></div>
    <div class="timeline-content">
      <span class="timeline-year">2018</span>
      <h3>Where It All Began</h3>
      <p>Founded in a small kitchen with a big dream.</p>
    </div>
  </div>
  <!-- more entries... -->
</section>
```

```css
.timeline {
  position: relative;
  max-width: 700px;
  margin: 80px auto;
  padding: 20px 0;
}
.timeline-line {
  position: absolute;
  left: 24px;
  top: 0;
  bottom: 0;
  width: 2px;
  background: linear-gradient(to bottom, transparent, var(--accent, #333) 10%, var(--accent, #333) 90%, transparent);
}
.timeline-entry {
  position: relative;
  padding-left: 60px;
  margin-bottom: 48px;
  opacity: 0;
  transform: translateX(-20px);
  transition: opacity 0.6s ease, transform 0.6s ease;
}
.timeline-entry.visible {
  opacity: 1;
  transform: translateX(0);
}
.timeline-dot {
  position: absolute;
  left: 17px;
  top: 4px;
  width: 16px;
  height: 16px;
  border-radius: 50%;
  background: var(--accent, #333);
  border: 3px solid var(--bg, #fff);
  z-index: 2;
}
.timeline-year {
  display: inline-block;
  font-weight: 800;
  font-size: 0.85rem;
  color: var(--accent, #333);
  text-transform: uppercase;
  letter-spacing: 0.1em;
  margin-bottom: 6px;
}
.timeline-content h3 {
  font-size: 1.2rem;
  margin: 0 0 8px;
}
.timeline-content p {
  color: var(--text-muted, #666);
  font-size: 0.95rem;
  line-height: 1.6;
  margin: 0;
}
```

```js
function initTimeline() {
  const entries = document.querySelectorAll('.timeline-entry');
  const observer = new IntersectionObserver((items) => {
    items.forEach(item => {
      if (item.isIntersecting) {
        item.target.classList.add('visible');
        observer.unobserve(item.target);
      }
    });
  }, { threshold: 0.2, rootMargin: '0px 0px -80px 0px' });
  entries.forEach(entry => observer.observe(entry));
}
```

## Alternating Photo-Text Layout

```css
.story-block {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 40px;
  align-items: center;
  padding: 80px 40px;
  max-width: 1200px;
  margin: 0 auto;
}
.story-block:nth-child(even) {
  direction: rtl;
}
.story-block:nth-child(even) > * {
  direction: ltr;
}
.story-block-image {
  position: relative;
  overflow: hidden;
  border-radius: 16px;
}
.story-block-image img {
  width: 100%;
  height: 400px;
  object-fit: cover;
  will-change: transform;
  transition: transform 0.6s ease;
}
.story-block-image:hover img {
  transform: scale(1.05);
}
.story-block-text h2 {
  font-family: 'Playfair Display', serif;
  font-size: clamp(1.5rem, 3vw, 2.2rem);
  margin: 0 0 16px;
  line-height: 1.2;
}
.story-block-text p {
  color: var(--text-muted, #666);
  font-size: 1rem;
  line-height: 1.8;
}
@media (max-width: 768px) {
  .story-block {
    grid-template-columns: 1fr;
    padding: 40px 20px;
    gap: 24px;
  }
  .story-block:nth-child(even) { direction: ltr; }
}
```

## Team Card Component

```css
.team-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
  gap: 32px;
  max-width: 1000px;
  margin: 0 auto;
  padding: 40px 20px;
}
.team-card {
  position: relative;
  border-radius: 16px;
  overflow: hidden;
  aspect-ratio: 3 / 4;
  cursor: pointer;
}
.team-card img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.6s ease;
}
.team-card:hover img {
  transform: scale(1.08);
}
.team-card-overlay {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  padding: 24px;
  background: linear-gradient(to top, rgba(0,0,0,0.8), transparent);
  color: #fff;
  transform: translateY(30px);
  transition: transform 0.4s ease;
}
.team-card:hover .team-card-overlay {
  transform: translateY(0);
}
.team-card-name {
  font-size: 1.1rem;
  font-weight: 700;
  margin: 0 0 4px;
}
.team-card-role {
  font-size: 0.85rem;
  opacity: 0.8;
  margin: 0 0 8px;
}
.team-card-bio {
  font-size: 0.8rem;
  opacity: 0;
  max-height: 0;
  overflow: hidden;
  transition: opacity 0.4s ease 0.1s, max-height 0.4s ease;
  line-height: 1.5;
}
.team-card:hover .team-card-bio {
  opacity: 0.9;
  max-height: 100px;
}
```

## Counter Animation (Count Up)

```js
function initCounters() {
  const counters = document.querySelectorAll('[data-count]');
  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        const el = entry.target;
        const target = parseInt(el.dataset.count);
        const suffix = el.dataset.countSuffix || '';
        const duration = parseInt(el.dataset.countDuration) || 2000;
        let start = 0;
        const startTime = performance.now();
        function update(currentTime) {
          const elapsed = currentTime - startTime;
          const progress = Math.min(elapsed / duration, 1);
          // Ease out cubic
          const eased = 1 - Math.pow(1 - progress, 3);
          const current = Math.floor(eased * target);
          el.textContent = current.toLocaleString('tr-TR') + suffix;
          if (progress < 1) requestAnimationFrame(update);
        }
        requestAnimationFrame(update);
        observer.unobserve(el);
      }
    });
  }, { threshold: 0.5 });
  counters.forEach(c => observer.observe(c));
}
// Usage: <span data-count="5000" data-count-suffix="+">0</span>
```

## Fade-In Sections

```js
function initFadeSections() {
  const sections = document.querySelectorAll('.story-section');
  sections.forEach(s => {
    s.style.opacity = '0';
    s.style.transform = 'translateY(40px)';
    s.style.transition = 'opacity 0.8s ease, transform 0.8s ease';
  });
  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.style.opacity = '1';
        entry.target.style.transform = 'translateY(0)';
        observer.unobserve(entry.target);
      }
    });
  }, { threshold: 0.1, rootMargin: '0px 0px -60px 0px' });
  sections.forEach(s => observer.observe(s));
}
```

## Values/Principles Cards

```css
.values-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
  gap: 24px;
  max-width: 1000px;
  margin: 60px auto;
  padding: 0 20px;
}
.value-card {
  background: var(--card-bg, #f9f9f9);
  border-radius: 16px;
  padding: 32px;
  text-align: center;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}
.value-card:hover {
  transform: translateY(-6px);
  box-shadow: 0 12px 40px rgba(0,0,0,0.08);
}
.value-icon {
  width: 56px;
  height: 56px;
  margin: 0 auto 16px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--accent-light, #eef);
  border-radius: 14px;
  font-size: 1.5rem;
}
.value-card h3 {
  font-size: 1.1rem;
  margin: 0 0 8px;
}
.value-card p {
  color: var(--text-muted, #666);
  font-size: 0.9rem;
  line-height: 1.6;
  margin: 0;
}
```

## Initialization

```js
document.addEventListener('DOMContentLoaded', () => {
  const reduced = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  if (!reduced) {
    initHeroParallax();
    initTextReveal();
    initTimeline();
    initCounters();
    initFadeSections();
  }
  // Lazy load images
  const images = document.querySelectorAll('img[data-src]');
  const imgObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        const img = entry.target;
        img.src = img.dataset.src;
        img.removeAttribute('data-src');
        imgObserver.unobserve(img);
      }
    });
  }, { rootMargin: '200px' });
  images.forEach(img => imgObserver.observe(img));
});
```

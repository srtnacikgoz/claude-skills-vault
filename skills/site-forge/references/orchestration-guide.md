# Orchestration Guide — Site Forge Reference

## Tech Stack Decision Tree

```
START: What does the site need?

├── Static content only (brochure, portfolio, menu)
│   ├── Single page? → Static HTML (micro-interaction-kit for polish)
│   └── Multi-page? → Astro (fast, content-focused)
│
├── Dynamic features needed?
│   ├── User accounts / auth? → Next.js + NextAuth
│   ├── E-commerce / payments? → Next.js + Stripe
│   ├── CMS / admin panel? → Next.js + Prisma + admin route
│   ├── Real-time features? → Next.js + WebSockets
│   └── Blog only? → Astro or Next.js MDX
│
└── Unsure?
    ├── < 5 pages, no dynamic → Static HTML
    ├── 5-15 pages, some dynamic → Astro
    └── Complex, growing → Next.js
```

## Page-to-Skill Mapping

| Page Type | Primary Skill | Fallback |
|-----------|---------------|----------|
| Hero / Landing | scroll-stop-builder | Build directly with parallax |
| Menu / Products | menu-architect | CSS Grid catalog |
| Contact Form | form-craft | Simple HTML form |
| About Us / Story | story-weaver | Static about page |
| All Pages (polish) | micro-interaction-kit | CSS transitions only |
| Blog | Build directly | Astro MDX |
| Dashboard / Admin | Build directly | Next.js app routes |
| Auth pages | Build directly | NextAuth templates |

## Skill Invocation Patterns

When delegating to a skill, provide this context:

```
Skill: [skill-name]
Context:
- Brand: {name}, {colors}, {fonts}
- Style: {vibe description}
- Content: {what content is available}
- Integration: {how this page connects to others}
- Constraints: {any technical constraints}
```

## Shared Component Patterns

### Navigation Header

```html
<header class="site-header">
  <div class="header-inner">
    <a href="/" class="logo">
      <img src="logo.svg" alt="Brand Name" height="40">
    </a>
    <nav class="main-nav" id="mainNav">
      <a href="/" class="nav-link active">Ana Sayfa</a>
      <a href="/hakkimizda" class="nav-link">Hakkimizda</a>
      <a href="/menu" class="nav-link">Menu</a>
      <a href="/iletisim" class="nav-link">Iletisim</a>
    </nav>
    <button class="mobile-toggle" id="mobileToggle" aria-label="Menu">
      <span></span><span></span><span></span>
    </button>
  </div>
</header>
```

```css
.site-header {
  position: fixed; top: 0; left: 0; width: 100%;
  z-index: 1000; background: rgba(255,255,255,0.95);
  backdrop-filter: blur(12px); border-bottom: 1px solid rgba(0,0,0,0.06);
  transition: transform 0.3s ease;
}
.site-header.hidden { transform: translateY(-100%); }
.header-inner {
  display: flex; align-items: center; justify-content: space-between;
  max-width: 1200px; margin: 0 auto; padding: 14px 24px;
}
.nav-link {
  text-decoration: none; color: var(--text); font-size: 0.9rem;
  font-weight: 500; padding: 8px 16px; border-radius: 8px;
  transition: background 0.2s ease;
}
.nav-link:hover, .nav-link.active { background: rgba(0,0,0,0.05); }
.mobile-toggle { display: none; }
@media (max-width: 768px) {
  .main-nav {
    position: fixed; top: 0; right: -100%; width: 280px; height: 100vh;
    background: #fff; display: flex; flex-direction: column;
    padding: 80px 24px; transition: right 0.3s ease;
    box-shadow: -4px 0 20px rgba(0,0,0,0.1);
  }
  .main-nav.open { right: 0; }
  .mobile-toggle {
    display: flex; flex-direction: column; gap: 5px;
    background: none; border: none; cursor: pointer; padding: 8px;
  }
  .mobile-toggle span {
    width: 24px; height: 2px; background: var(--text);
    transition: all 0.3s ease;
  }
}
```

```js
// Hide header on scroll down, show on scroll up
function initSmartHeader() {
  const header = document.querySelector('.site-header');
  let lastScroll = 0;
  window.addEventListener('scroll', () => {
    const current = window.scrollY;
    if (current > lastScroll && current > 100) {
      header.classList.add('hidden');
    } else {
      header.classList.remove('hidden');
    }
    lastScroll = current;
  }, { passive: true });
}

// Mobile menu toggle
function initMobileMenu() {
  const toggle = document.getElementById('mobileToggle');
  const nav = document.getElementById('mainNav');
  toggle?.addEventListener('click', () => {
    nav.classList.toggle('open');
  });
}
```

### Footer

```html
<footer class="site-footer">
  <div class="footer-inner">
    <div class="footer-brand">
      <img src="logo.svg" alt="Brand" height="32">
      <p class="footer-tagline">Tagline goes here</p>
    </div>
    <div class="footer-links">
      <div class="footer-col">
        <h4>Sayfalar</h4>
        <a href="/">Ana Sayfa</a>
        <a href="/hakkimizda">Hakkimizda</a>
        <a href="/menu">Menu</a>
      </div>
      <div class="footer-col">
        <h4>Iletisim</h4>
        <a href="tel:+905551234567">0555 123 45 67</a>
        <a href="mailto:info@brand.com">info@brand.com</a>
        <p>Istanbul, Turkiye</p>
      </div>
    </div>
  </div>
  <div class="footer-bottom">
    <p>&copy; 2026 Brand Name. Tum haklari saklidir.</p>
  </div>
</footer>
```

```css
.site-footer {
  background: var(--footer-bg, #111); color: #ccc;
  padding: 60px 24px 20px;
}
.footer-inner {
  display: flex; justify-content: space-between; flex-wrap: wrap;
  max-width: 1200px; margin: 0 auto; gap: 40px;
}
.footer-tagline { color: #888; font-size: 0.9rem; margin-top: 8px; }
.footer-links { display: flex; gap: 60px; }
.footer-col { display: flex; flex-direction: column; gap: 8px; }
.footer-col h4 { color: #fff; font-size: 0.85rem; text-transform: uppercase; letter-spacing: 0.1em; margin: 0 0 8px; }
.footer-col a { color: #999; text-decoration: none; font-size: 0.9rem; transition: color 0.2s; }
.footer-col a:hover { color: #fff; }
.footer-bottom {
  max-width: 1200px; margin: 40px auto 0;
  padding-top: 20px; border-top: 1px solid #333;
  text-align: center; font-size: 0.8rem; color: #666;
}
```

## SEO Checklist

Apply to every page generated:

```html
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>{Page Title} | {Brand Name}</title>
  <meta name="description" content="{150 char description}">

  <!-- Open Graph -->
  <meta property="og:title" content="{Page Title}">
  <meta property="og:description" content="{Description}">
  <meta property="og:image" content="{Image URL}">
  <meta property="og:url" content="{Page URL}">
  <meta property="og:type" content="website">

  <!-- Twitter Card -->
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:title" content="{Page Title}">
  <meta name="twitter:description" content="{Description}">
  <meta name="twitter:image" content="{Image URL}">

  <!-- Favicon -->
  <link rel="icon" type="image/svg+xml" href="/favicon.svg">
  <link rel="apple-touch-icon" href="/apple-touch-icon.png">

  <!-- Canonical -->
  <link rel="canonical" href="{Canonical URL}">

  <!-- Fonts (preload) -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

  <!-- Structured Data -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "LocalBusiness",
    "name": "{Brand Name}",
    "image": "{Logo URL}",
    "telephone": "{Phone}",
    "address": {
      "@type": "PostalAddress",
      "addressLocality": "{City}",
      "addressCountry": "TR"
    }
  }
  </script>
</head>
```

## Deployment Guide

### Vercel (Recommended for Next.js)

```bash
# Install Vercel CLI
npm i -g vercel

# Deploy
vercel

# Production deploy
vercel --prod

# Environment variables
vercel env add DATABASE_URL
vercel env add NEXTAUTH_SECRET
```

### Netlify (Good for Static / Astro)

```bash
# Install
npm i -g netlify-cli

# Deploy
netlify deploy

# Production
netlify deploy --prod

# Set env vars via UI or
netlify env:set KEY value
```

### VPS (Any stack)

```bash
# Build
npm run build

# Using PM2 for Node.js
npm i -g pm2
pm2 start npm --name "site" -- start
pm2 save
pm2 startup

# Nginx reverse proxy config
# /etc/nginx/sites-available/site
server {
    listen 80;
    server_name yourdomain.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

## Integration Checklist

Before declaring the site complete, verify:

- [ ] Navigation links work across all pages
- [ ] Header and footer are identical on every page
- [ ] Active nav link highlights correctly per page
- [ ] Color palette is consistent (no rogue colors)
- [ ] Typography hierarchy is consistent (h1-h6 sizes match)
- [ ] All images have alt text
- [ ] Mobile menu works and closes on navigation
- [ ] Meta tags present on all pages
- [ ] Favicon displays correctly
- [ ] 404 page exists
- [ ] All external links open in new tab
- [ ] Forms submit correctly
- [ ] Console has no errors
- [ ] No horizontal scroll on mobile
- [ ] Performance: images are optimized, CSS/JS are minimal
- [ ] Accessibility: keyboard navigation works, contrast is sufficient

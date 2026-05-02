# Menu Patterns — Copy-Paste Ready Code

## Kiosk Style (Dark, Bold)

```css
/* Kiosk — dark background, large images, neon accents */
:root {
  --bg: #111; --card-bg: #1a1a1a; --text: #fff;
  --text-muted: #888; --accent: #ff6b35; --radius: 16px;
}
body { background: var(--bg); color: var(--text); font-family: 'Inter', sans-serif; margin: 0; }
.menu-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 20px; padding: 20px; max-width: 1200px; margin: 0 auto;
}
.menu-card {
  background: var(--card-bg); border-radius: var(--radius);
  overflow: hidden; transition: transform 0.3s ease, box-shadow 0.3s ease;
  cursor: pointer;
}
.menu-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 30px rgba(255, 107, 53, 0.15);
}
.menu-card img { width: 100%; height: 180px; object-fit: cover; }
.menu-card-body { padding: 16px; }
.menu-card-name { font-size: 1.1rem; font-weight: 700; margin: 0 0 6px; }
.menu-card-desc { color: var(--text-muted); font-size: 0.85rem; line-height: 1.4; margin: 0 0 12px; }
.menu-card-price { font-size: 1.3rem; font-weight: 800; color: var(--accent); }
.menu-card-badge {
  display: inline-block; background: var(--accent); color: #fff;
  font-size: 0.7rem; font-weight: 700; padding: 3px 8px;
  border-radius: 20px; text-transform: uppercase; margin-bottom: 8px;
}
```

## Minimal Style (White, Typography)

```css
:root {
  --bg: #fafafa; --card-bg: #fff; --text: #222;
  --text-muted: #777; --accent: #222; --border: #eee;
}
body { background: var(--bg); color: var(--text); font-family: 'DM Sans', sans-serif; margin: 0; }
.menu-grid {
  max-width: 800px; margin: 0 auto; padding: 20px;
  display: flex; flex-direction: column; gap: 0;
}
.menu-card {
  display: flex; justify-content: space-between; align-items: center;
  padding: 20px 0; border-bottom: 1px solid var(--border);
  transition: background 0.2s ease;
}
.menu-card:hover { background: rgba(0,0,0,0.02); padding-left: 8px; }
.menu-card-name { font-size: 1rem; font-weight: 600; }
.menu-card-desc { color: var(--text-muted); font-size: 0.85rem; margin-top: 2px; }
.menu-card-price { font-size: 1rem; font-weight: 700; white-space: nowrap; }
.menu-card-dots {
  flex: 1; border-bottom: 2px dotted var(--border);
  margin: 0 12px; min-width: 40px; align-self: flex-end; margin-bottom: 4px;
}
```

## Classic Style (Cream, Elegant)

```css
:root {
  --bg: #f5f0e8; --card-bg: #fffdf7; --text: #3a2e1f;
  --text-muted: #8b7d6b; --accent: #b8860b; --border: #e0d5c1;
}
body { background: var(--bg); color: var(--text); font-family: 'Playfair Display', serif; margin: 0; }
.menu-grid {
  max-width: 900px; margin: 0 auto; padding: 40px 20px;
  display: grid; grid-template-columns: 1fr 1fr; gap: 32px;
}
.menu-card {
  background: var(--card-bg); border: 1px solid var(--border);
  border-radius: 8px; padding: 24px; text-align: center;
  transition: box-shadow 0.3s ease;
}
.menu-card:hover { box-shadow: 0 4px 20px rgba(0,0,0,0.08); }
.menu-card-name { font-size: 1.2rem; font-weight: 700; margin-bottom: 8px; }
.menu-card-desc { font-family: 'DM Sans', sans-serif; color: var(--text-muted); font-size: 0.85rem; margin-bottom: 16px; font-style: italic; }
.menu-card-price { font-size: 1.1rem; font-weight: 600; color: var(--accent); }
.menu-card-divider { width: 40px; height: 2px; background: var(--accent); margin: 12px auto; }
```

## Bold Style (Vibrant, Playful)

```css
:root {
  --bg: #fff; --text: #111; --text-muted: #555;
  --accent: #ff4757; --accent-2: #ffa502; --radius: 20px;
}
body { background: var(--bg); color: var(--text); font-family: 'Space Grotesk', sans-serif; margin: 0; }
.menu-grid {
  display: grid; grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
  gap: 24px; padding: 24px; max-width: 1200px; margin: 0 auto;
}
.menu-card {
  background: linear-gradient(135deg, #fff 0%, #f8f8f8 100%);
  border-radius: var(--radius); overflow: hidden;
  border: 2px solid transparent;
  transition: border-color 0.3s ease, transform 0.3s ease;
}
.menu-card:hover { border-color: var(--accent); transform: scale(1.03); }
.menu-card img { width: 100%; height: 200px; object-fit: cover; }
.menu-card-body { padding: 20px; }
.menu-card-name { font-size: 1.15rem; font-weight: 700; }
.menu-card-price {
  display: inline-block; background: var(--accent); color: #fff;
  padding: 6px 14px; border-radius: 30px; font-weight: 800;
  font-size: 1rem; margin-top: 12px;
}
```

## Category Tabs

```html
<nav class="category-tabs" id="categoryTabs">
  <button class="tab active" data-category="all">Hepsi</button>
  <button class="tab" data-category="pastalar">Pastalar</button>
  <button class="tab" data-category="kruvasanlar">Kruvasanlar</button>
  <button class="tab" data-category="icecekler">Icecekler</button>
</nav>
```

```css
.category-tabs {
  display: flex; gap: 8px; padding: 16px 20px;
  overflow-x: auto; -webkit-overflow-scrolling: touch;
  position: sticky; top: 0; background: var(--bg);
  z-index: 10; scrollbar-width: none;
}
.category-tabs::-webkit-scrollbar { display: none; }
.tab {
  background: transparent; border: 1.5px solid var(--border, #ddd);
  padding: 8px 20px; border-radius: 30px; font-size: 0.9rem;
  cursor: pointer; white-space: nowrap; transition: all 0.3s ease;
  font-weight: 500; color: var(--text-muted);
}
.tab.active, .tab:hover {
  background: var(--accent); color: #fff; border-color: var(--accent);
}
```

## Search Filter JS

```js
function initMenuSearch() {
  const input = document.getElementById('menuSearch');
  const cards = document.querySelectorAll('.menu-card');
  input.addEventListener('input', (e) => {
    const query = e.target.value.toLowerCase().trim();
    cards.forEach(card => {
      const name = card.dataset.name?.toLowerCase() || '';
      const desc = card.dataset.desc?.toLowerCase() || '';
      const match = !query || name.includes(query) || desc.includes(query);
      card.style.display = match ? '' : 'none';
      if (match) {
        card.style.animation = 'fadeIn 0.3s ease forwards';
      }
    });
  });
}

function initCategoryFilter() {
  const tabs = document.querySelectorAll('.tab');
  const cards = document.querySelectorAll('.menu-card');
  tabs.forEach(tab => {
    tab.addEventListener('click', () => {
      tabs.forEach(t => t.classList.remove('active'));
      tab.classList.add('active');
      const cat = tab.dataset.category;
      cards.forEach((card, i) => {
        const show = cat === 'all' || card.dataset.category === cat;
        card.style.display = show ? '' : 'none';
        if (show) {
          card.style.animation = `fadeIn 0.3s ease ${i * 0.05}s forwards`;
        }
      });
    });
  });
}
```

## Dietary Icons (Inline SVG)

```js
const dietaryIcons = {
  vegan: `<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#22c55e" stroke-width="2"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2z"/><path d="M8 12l2-6c2 4 6 6 6 6s-4 2-6 6l-2-6z"/></svg>`,
  glutensiz: `<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#f59e0b" stroke-width="2"><circle cx="12" cy="12" r="10"/><path d="M7 12h10M12 7v10"/><line x1="4" y1="4" x2="20" y2="20" stroke-width="2.5"/></svg>`,
  laktozsuz: `<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#3b82f6" stroke-width="2"><path d="M8 2h8l-1 7h-6L8 2zM7 11h10v2a5 5 0 01-10 0v-2z"/><line x1="4" y1="4" x2="20" y2="20" stroke-width="2.5"/></svg>`,
  spicy: `<svg width="18" height="18" viewBox="0 0 24 24" fill="#ef4444"><path d="M12 2C10 6 6 8 6 14a6 6 0 1012 0c0-6-4-8-6-12z"/></svg>`,
  popular: `<svg width="18" height="18" viewBox="0 0 24 24" fill="#fbbf24"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/></svg>`
};

function renderDietaryIcons(dietary) {
  return dietary.map(d => `<span class="dietary-icon" title="${d}">${dietaryIcons[d] || ''}</span>`).join('');
}
```

## Staggered Card Entrance Animation

```css
@keyframes fadeIn {
  from { opacity: 0; transform: translateY(20px); }
  to { opacity: 1; transform: translateY(0); }
}
.menu-card {
  opacity: 0;
  animation: fadeIn 0.4s ease forwards;
}
.menu-card:nth-child(1) { animation-delay: 0.05s; }
.menu-card:nth-child(2) { animation-delay: 0.1s; }
.menu-card:nth-child(3) { animation-delay: 0.15s; }
.menu-card:nth-child(4) { animation-delay: 0.2s; }
.menu-card:nth-child(5) { animation-delay: 0.25s; }
.menu-card:nth-child(6) { animation-delay: 0.3s; }
/* For dynamic counts, use JS to set --i custom property */
```

## Scroll-Triggered Category Highlighting

```js
function initScrollCategoryHighlight() {
  const sections = document.querySelectorAll('.menu-section');
  const tabs = document.querySelectorAll('.tab');
  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        const cat = entry.target.dataset.category;
        tabs.forEach(t => t.classList.remove('active'));
        const activeTab = document.querySelector(`.tab[data-category="${cat}"]`);
        if (activeTab) {
          activeTab.classList.add('active');
          activeTab.scrollIntoView({ behavior: 'smooth', inline: 'center', block: 'nearest' });
        }
      }
    });
  }, { threshold: 0.3, rootMargin: '-100px 0px -60% 0px' });
  sections.forEach(s => observer.observe(s));
}
```

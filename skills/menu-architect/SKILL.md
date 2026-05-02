---
name: menu-architect
description: Build beautiful, interactive digital menu pages for restaurants, cafes, patisseries, and food businesses. Takes menu data (product names, prices, descriptions, categories) and generates a premium filterable menu page with categories, search, dietary icons, and smooth animations. Trigger when user says "build a menu", "digital menu", "restaurant menu page", "cafe menu", "product catalog page", "menu sayfasi", or provides menu/product data for display.
---

# Menu Architect

Build a premium, interactive digital menu page from product data. Single self-contained HTML file with filtering, search, and animations.

## Step 0: Interview (MANDATORY)

- **Business name** and type (restaurant, cafe, patisserie, bar)
- **Logo** file (SVG/PNG)
- **Color palette** (accent color, background preference)
- **Menu data source:**
  - A) Paste as text (name — price — description per line)
  - B) CSV/JSON file
  - C) I'll generate sample data, you fill in
- **Categories** — how to group items (e.g., Pastalar, Kruvasanlar, Icecekler)
- **Dietary icons needed?** (vegan, glutensiz, laktozsuz, etc.)
- **Currency** (TRY, USD, EUR)
- **Style preference** — minimal / bold / classic / kiosk-style

## Menu Data Format

Normalize input into this structure:
```json
{
  "categories": [
    {
      "name": "Pastalar",
      "icon": "🎂",
      "items": [
        {
          "name": "Meyveli Pasta",
          "description": "Taze meyveler ve vanilya krema",
          "price": 450,
          "image": "optional-url",
          "badges": ["popular"],
          "dietary": ["vegetarian"]
        }
      ]
    }
  ]
}
```

## Build Output

Single HTML file with:

1. **Header** — Logo + business name + search bar
2. **Category Tabs** — Horizontal scrollable pills, sticky on scroll
3. **Menu Grid** — Cards with image (if provided), name, description, price, dietary icons, badges
4. **Search** — Real-time filter by name/description
5. **Category Filter** — Click tab to filter, smooth scroll to section
6. **Animations** — Staggered card entrance, hover effects, smooth filtering transitions
7. **Mobile** — Full responsive, touch-friendly category tabs
8. **Footer** — Business info, "Powered by" optional

For layout patterns and card designs, read `references/menu-patterns.md`.

## Style System

Build from interview answers:
- **Kiosk style** — Dark bg, large images, bold prices (McDonald's inspired)
- **Minimal** — White bg, typography-focused, small/no images
- **Classic** — Cream/paper texture bg, serif fonts, elegant
- **Bold** — Vibrant colors, large cards, playful

## Technical

- Vanilla HTML/CSS/JS, Google Fonts
- CSS Grid for menu layout
- IntersectionObserver for scroll-triggered category highlighting
- No framework dependency
- Serve via python3 http.server

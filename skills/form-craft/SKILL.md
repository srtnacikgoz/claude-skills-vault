---
name: form-craft
description: Build beautiful, animated, multi-step forms with real-time validation and delightful micro-interactions. Takes a list of form fields and generates a premium form experience — Typeform-style single-question, multi-step wizard, or classic layout. Includes validation, progress bar, success animation. Trigger when user says "build a form", "registration form", "signup form", "contact form", "order form", "kayit formu", "siparis formu", or needs a form with better UX.
---

# Form Craft

Build premium, animated forms from a field list. Output is a self-contained HTML file or a React component.

## Step 0: Interview (MANDATORY)

- **Form purpose** (registration, contact, order, survey, booking)
- **Fields needed** — list each: name, type (text/email/phone/select/textarea/checkbox/radio/date/file), required?, placeholder
- **Form style:**
  - A) **Typeform** — one question per screen, keyboard-navigable, progress bar
  - B) **Multi-step wizard** — grouped steps, back/next, step indicator
  - C) **Classic** — all fields visible, single page, sectioned
- **Brand colors** (accent for buttons/focus states, background)
- **Output format:**
  - A) Standalone HTML (vanilla)
  - B) React component (TSX)
  - C) Next.js Server Action form
- **Submit action** — where does the data go? (API endpoint, email, just collect)
- **Success behavior** — redirect, show message, confetti?

## Field Types & Validation

| Type | Validation | UX Pattern |
|------|-----------|-----------|
| text | min/max length | Floating label, character counter |
| email | RFC 5322 regex | Real-time check with green checkmark |
| phone | Country-aware format | Auto-format as user types |
| password | Strength meter | Show/hide toggle, strength bar |
| select | Required selection | Custom dropdown with search |
| textarea | min/max length | Auto-grow height, char counter |
| date | Min/max date | Native date picker or custom calendar |
| file | Size/type check | Drag-and-drop zone with preview |
| checkbox | Required check | Custom styled checkbox |
| radio | Required selection | Card-style radio (visual, not dots) |

## Animation Patterns

- **Field entrance** — staggered fade-up on load/step change
- **Focus state** — label floats up, border color transitions to accent
- **Validation** — green checkmark slides in on valid, red shake on error
- **Step transition** — slide left/right between steps
- **Progress** — animated top bar or step dots
- **Submit** — button transforms to spinner → checkmark
- **Success** — full-screen checkmark animation or confetti burst

For code patterns of each animation, read `references/form-patterns.md`.

## Accessibility

- All fields have proper `<label>` associations
- Error messages use `aria-describedby`
- Focus management between steps (auto-focus first field)
- Keyboard navigation (Enter = next, Escape = back)
- prefers-reduced-motion respected

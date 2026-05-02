# Plan: Stil Sistemi — 7 Alandan 3 Alana Sadeleştirme

## Context

Mevcut stil sistemi 7 ayrı promptDirections alanı kullanıyor (background, typography, layout, colorPalette, productPlacement, lighting, overallFeel). Kullanıcı bunların tek bir `styleDirective` alanına birleştirilmesini istiyor. Ayrıca `dallEPrompt` ve `backgroundHex` kalacak.

**Hedef:** 7 ayrı alan → tek `styleDirective` + `dallEPrompt` + `backgroundHex`

---

## Etki Haritası (Faz 1)

### Etkilenen dosyalar: 10

| # | Dosya | Değişecek mi | Neden |
|---|-------|-------------|-------|
| 1 | `functions/src/types/poster.ts` | EVET | PosterPromptDirections interface |
| 2 | `functions/src/controllers/orchestrator/posterSmartController.ts` | EVET | System prompt enjeksiyonu (satır 714-720) |
| 3 | `functions/src/controllers/orchestrator/posterConfigController.ts` | EVET | updatePosterStyle nested merge (satır 177-179) + yorum (satır 151) |
| 4 | `functions/src/services/config/posterConfig.ts` | EVET | extractHexFromBackgroundText (satır 105) — artık colorPalette veya styleDirective'den çıkarmalı |
| 5 | `functions/src/orchestrator/seed/posterData.ts` | EVET | 8 seed stil — 7 alan → styleDirective + dallEPrompt |
| 6 | `admin/src/pages/Poster.tsx` | EVET | styleEditForm, handleSaveStyleEdit, düzenleme modalı, "Tümünü kopyala" butonu |
| 7 | `admin/src/pages/QrMenu.tsx` | EVET | VisualStyleForm, VISUAL_FIELDS, handleSave, makeDraft, StyleCard düzenleme, standardSections |
| 8 | `admin/src/components/poster/PosterAnalyzer.tsx` | EVET | StyleForm, dnaToStyleForm, FORM_FIELDS, handleSave |
| 9 | `admin/src/components/qr-menu/QrMenuPromptGenerator.tsx` | EVET | PosterStyle interface, buildPrompt standardSections |
| 10 | `admin/src/services/api.ts` | HAYIR | Generic POST body geçiriyor, type kontrolü yok |

---

## Değişiklik Planı (Faz 2)

### Sıralama: Type → Backend → Frontend

---

### Dosya 1: `functions/src/types/poster.ts`

**Değişiklik:** PosterPromptDirections'ı sadeleştir

```typescript
// ESKİ (8 alan):
export interface PosterPromptDirections {
  background: string;
  typography: string;
  layout: string;
  colorPalette: string;
  lighting: string;
  overallFeel: string;
  dallEPrompt?: string;
  productPlacement?: string; // DEPRECATED
}

// YENİ (2+6 opsiyonel alan):
export interface PosterPromptDirections {
  styleDirective: string;       // Stilin tüm tarifi — tek metin
  dallEPrompt?: string;         // DALL-E şablon promptu ({PRODUCT} placeholder)
  // Backward compat — eski stiller için, yeni stiller bunları kullanmaz
  background?: string;
  typography?: string;
  layout?: string;
  colorPalette?: string;
  lighting?: string;
  overallFeel?: string;
  productPlacement?: string;
}
```

**Neden opsiyonel:** Firestore'daki eski stiller hala 7 alanlı. Yeni kod eski formatı okuyabilmeli.

---

### Dosya 2: `functions/src/controllers/orchestrator/posterSmartController.ts` (satır 714-720)

**Değişiklik:** System prompt enjeksiyonu — styleDirective varsa onu kullan, yoksa eski 6 alanı birleştir

```typescript
// ESKİ:
Background: ${style.promptDirections.background}
Typography: ${style.promptDirections.typography}
...

// YENİ:
const dirs = style.promptDirections;
const styleBlock = dirs.styleDirective 
  ? dirs.styleDirective
  : [
      dirs.background && `Background: ${dirs.background}`,
      dirs.typography && `Typography: ${dirs.typography}`,
      dirs.layout && `Layout: ${dirs.layout}${dirs.productPlacement ? ` | Product: ${dirs.productPlacement}` : ""}`,
      dirs.colorPalette && `Color Palette: ${dirs.colorPalette}`,
      dirs.lighting && `Lighting: ${dirs.lighting}`,
      dirs.overallFeel && `Overall Feel: ${dirs.overallFeel}`,
    ].filter(Boolean).join("\n");

// System prompt'ta:
STYLE DIRECTIVE:
${styleBlock}
```

---

### Dosya 3: `functions/src/controllers/orchestrator/posterConfigController.ts` (satır 151-179)

**Değişiklik:** updatePosterStyle yorum + nested merge mantığı

- Yorum (satır 151): yeni alanları da belirt
- Nested merge (satır 177-179): aynı mantık çalışır — spread ile merge. Değişiklik gerekmez çünkü generic `{ ...existing, ...updates.promptDirections }` yapıyor.
- Sadece yorum güncellenecek.

---

### Dosya 4: `functions/src/services/config/posterConfig.ts` (satır 105)

**Değişiklik:** extractHexFromBackgroundText → styleDirective veya colorPalette'den de hex çıkarabilmeli

```typescript
// ESKİ:
const extracted = extractHexFromBackgroundText(style.promptDirections?.background);

// YENİ:
const extracted = extractHexFromBackgroundText(
  style.promptDirections?.styleDirective 
  || style.promptDirections?.colorPalette 
  || style.promptDirections?.background
);
```

---

### Dosya 5: `functions/src/orchestrator/seed/posterData.ts`

**Değişiklik:** 8 seed stil — 7 ayrı alan → tek styleDirective + dallEPrompt

Her stil için mevcut 7 alanı tek bir styleDirective metnine birleştirecek + examplePromptFragment → dallEPrompt.

Örnek (Bold Minimal):
```typescript
{
  name: "Bold Minimal",
  nameTr: "Cesur Minimal",
  description: "...",
  promptDirections: {
    styleDirective: "Background: Clean solid background — pure white, deep black, or a single bold color. No textures, no gradients. Typography: Bold condensed sans-serif typeface. Title is large and commanding. Layout: Asymmetric composition. Product slightly off-center with generous negative space. Product is hero — 35-45% of frame, rule of thirds. Color Palette: Maximum 2-3 colors, high contrast pairs. Lighting: Hard directional light creating strong shadows. Overall Feel: Confident, modern, magazine-cover energy.",
    dallEPrompt: "A professional product poster featuring {PRODUCT}. Clean solid background...",
  },
  isActive: true,
  sortOrder: 1,
}
```

---

### Dosya 6: `admin/src/pages/Poster.tsx`

**Değişiklikler:**

1. **PosterStyle interface** (satır 15-23): `promptDirections` alanlarını güncelle
2. **styleEditForm state** (satır 65-70): 6 alan → `styleDirective` + `dallEPrompt`
3. **Düzenleme butonu form doldurma** (satır 382-395): eski format → yeni format dönüşümü
4. **handleSaveStyleEdit** (satır 141-178): promptDirections objesini yeni formatta gönder
5. **"Tümünü kopyala" butonu** (satır 596-610): yeni formatı kopyala
6. **Düzenleme modal formu** (satır 714-735): 6 textarea → 1 büyük textarea (styleDirective) + 1 dallEPrompt
7. **"Yeni Stil Ekle" butonu** — EKLENecek (mevcut değil)

**Backward compat form doldurma:**
```typescript
// Eski stiller 6 alanlı, yeni stiller styleDirective alanlı
const directive = s.promptDirections?.styleDirective || [
  s.promptDirections?.background && `Background: ${s.promptDirections.background}`,
  s.promptDirections?.typography && `Typography: ${s.promptDirections.typography}`,
  s.promptDirections?.layout && `Layout: ${s.promptDirections.layout}`,
  s.promptDirections?.colorPalette && `Color Palette: ${s.promptDirections.colorPalette}`,
  s.promptDirections?.lighting && `Lighting: ${s.promptDirections.lighting}`,
  s.promptDirections?.overallFeel && `Overall Feel: ${s.promptDirections.overallFeel}`,
].filter(Boolean).join("\n");
```

---

### Dosya 7: `admin/src/pages/QrMenu.tsx`

**Değişiklikler:**

1. **VisualStyleForm interface** (satır 8-19): 6 alan → `styleDirective`
2. **EMPTY_FORM** (satır 21-25): güncelle
3. **VISUAL_FIELDS** (satır 27-38): 6 alan → 1 büyük textarea
4. **handleSave** (satır 214-228): promptDirections.styleDirective olarak gönder
5. **makeDraft** (satır 608-625): eski format → styleDirective dönüşümü
6. **StyleCard düzenleme** (satır 734-742): yeni format
7. **standardSections** (satır 652-657): styleDirective'den oku

---

### Dosya 8: `admin/src/components/poster/PosterAnalyzer.tsx`

**Değişiklikler:**

1. **StyleForm interface**: 6 alan → `styleDirective` + `dallEPrompt`
2. **dnaToStyleForm**: 6 ayrı dönüşüm → tek styleDirective birleştirme
3. **FORM_FIELDS**: 6 textarea → 1 büyük textarea + dallEPrompt
4. **handleSave**: promptDirections.styleDirective olarak gönder
5. **styleForm init state**: güncelle

---

### Dosya 9: `admin/src/components/qr-menu/QrMenuPromptGenerator.tsx`

**Değişiklikler:**

1. **PosterStyle interface** (satır 11-18): `styleDirective` ekle
2. **buildPrompt** (satır 50-58): standardSections → styleDirective'den oku, fallback eski alanlar

---

## Zihinsel Build (Faz 3)

### TypeScript
- [x] `styleDirective` required, eski 6 alan opsiyonel → Firestore'daki eski stiller `styleDirective` alanı yok → backend'de okurken fallback lazım
- [x] Frontend'de eski stili açınca `styleDirective` undefined gelir → form doldururken birleştirme fallback lazım

### Firestore/Backend
- [x] Mevcut Firestore dökümanları eski formatta — yeni kod bunları okuyabilmeli (fallback: 6 alandan birleştir)
- [x] updatePosterStyle nested merge — `styleDirective` gönderilince eski alanlar korunur (sorun yok)
- [x] posterConfig.ts hex extraction — styleDirective veya colorPalette veya background'dan çıkarmalı

### JSX/React
- [x] 6 textarea kaldırılıp 1 büyük textarea ekleniyor — form state key'leri değişecek
- [x] QrMenu.tsx'teki StyleCard'da standardSections array'i değişecek

### Build
- Functions: `cd functions && npm run build`
- Admin: `cd admin && npx vite build`

---

## Uygulama Sırası (Faz 4)

1. `functions/src/types/poster.ts` — type güncelle
2. `functions/src/services/config/posterConfig.ts` — hex extraction güncelle
3. `functions/src/controllers/orchestrator/posterSmartController.ts` — prompt enjeksiyonu güncelle
4. `functions/src/controllers/orchestrator/posterConfigController.ts` — yorum güncelle
5. `functions/src/orchestrator/seed/posterData.ts` — seed data güncelle
6. **Functions build** → `npm run build`
7. `admin/src/components/poster/PosterAnalyzer.tsx` — form + dönüşüm güncelle
8. `admin/src/components/qr-menu/QrMenuPromptGenerator.tsx` — buildPrompt güncelle
9. `admin/src/pages/QrMenu.tsx` — form + düzenleme güncelle
10. `admin/src/pages/Poster.tsx` — form + düzenleme + "Yeni Stil Ekle" butonu
11. **Admin build** → `npx vite build`

---

## Doğrulama (Faz 5)

1. `cd functions && npm run build` — hatasız
2. `cd admin && npx vite build` — hatasız
3. Mevcut stiller (eski format) hala çalışır — backward compat fallback
4. Yeni stil eklenebilir — styleDirective + dallEPrompt
5. Düzenleme modalı tek büyük textarea gösterir
6. QrMenu tarafı da çalışır

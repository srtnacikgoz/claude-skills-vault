# Poster Sistemi v2 — Analiz Tabanlı Üretim

## Bağlam
Mevcut poster sistemi 8+ manuel seçenek gerektiriyor (stil, mood, tipografi, layout, kamera açısı, ışık, arka plan). Kullanıcı beğendiği bir poster yükleyip "bunun aynısını yap" demek istiyor. Tüm seçenekler kalkacak, poster analizi her şeyi otomatik belirleyecek. Ayrıca Gemini yazı render edemediği için metin programatik eklenecek.

## Yeni Akış

```
Referans poster yükle
    ↓
AI analiz → JSON (renkler, fontlar, pozisyonlar, ışık, kompozisyon)
    ↓
Ürün görseli + başlık/alt başlık/marka adı gir
    ↓
Gemini → arka plan + ürün görseli (YAZISIZ)
    ↓
HTML/CSS → metin overlay (Google Fonts + analiz pozisyonları)
    ↓
PNG export (html-to-image)
```

## Kaldırılacaklar
- Stil seçici (8 stil kartı)
- Mood seçici
- Tipografi seçici (başlık + alt başlık)
- Layout seçici
- Kamera açısı seçici
- Işık tipi seçici
- Arka plan seçici
- Negatif prompt
- Target model seçici (sadece Gemini kalacak)
- includeText toggle
- Arka plan kaldırma modu

## Kalacaklar
- Aspect ratio seçici (2:3, 1:1, 9:16)
- Galeri + feedback sistemi
- Öğrenme sistemi (global rules)
- Ürün görseli yükleme

---

## Phase 1: Backend — Tipler + Analiz Endpoint

### 1.1 `functions/src/types/poster.ts` → Yeniden yaz (~120 satır)

Kaldırılacak interface'ler:
- PosterMoodModifiers, PosterMood
- PosterTypography, PosterLayout
- PosterCameraAngle, PosterLightingType, PosterBackground

Eklenecek:
```typescript
interface PosterAnalysis {
  colorDNA: {
    dominantColors: Array<{ role: string; hex: string; percentage: number }>;
    backgroundGradient?: { type: "solid" | "linear" | "radial"; colors: string[]; angle?: number };
    colorTemperature: string;
    colorGrade: string;
  };
  typographyDNA: {
    title: TextElementDNA;
    subtitle?: TextElementDNA;
    brand?: TextElementDNA;
  };
  compositionDNA: {
    productPlacement: string;
    productScale: string;
    negativeSpaceRatio: string;
    visualFlow: string;
  };
  lightingDNA: {
    pattern: string;
    colorTemperature: string;
    quality: string;
    keyToFillRatio: string;
    shadowDescription: string;
  };
  atmosphereDNA: {
    moodAdjectives: string[];
    textureOverlay: string;
    grainLevel: string;
    depthEffect: string;
  };
  backgroundPrompt: string; // Gemini'ye verilecek hazır prompt (YAZISIZ)
  aspectRatio: string;
}

interface TextElementDNA {
  detectedStyle: string;
  googleFontMatch: string;
  googleFontWeight: number;
  fallbackStack: string;
  capitalization: "uppercase" | "capitalize" | "lowercase" | "none";
  letterSpacing: string;
  color: string;
  estimatedSizePct: number;
  position: { xPct: number; yPct: number };
  maxWidthPct: number;
  textAlign: "left" | "center" | "right";
}
```

### 1.2 `functions/src/controllers/orchestrator/posterSmartController.ts` → Yeniden yaz (~380 satır)

**`analyzePosterDesign` yeniden yaz:**
- Preset eşleştirme kaldır (styleId, moodId, typographyId arama yok)
- Yeni system prompt: doğrudan PosterAnalysis JSON şeması döndür
- Google Font eşleştirme talimatı ekle (top 50 font listesi)
- `backgroundPrompt` alanı: Gemini'ye verilecek hazır sahne tarifi (metin yok)

**`generatePosterPrompt` → `generateBackgroundPrompt` olarak yeniden yaz:**
- Tüm config yükleme kaldır (style, mood, typography, layout)
- Input: `{ analysis: PosterAnalysis, productImageBase64, aspectRatioId? }`
- `analysis.backgroundPrompt` + global rules + aspect ratio + "YAZISIZ" talimatı birleştir
- Tek model: Gemini (dall-e/midjourney/flux talimatları kaldır)

**Kaldır:**
- `checkPosterCombination`
- `updatePosterStyle`, `createPosterStyle`, `deletePosterStyle`

### 1.3 `functions/src/controllers/orchestrator/posterImageController.ts` → Küçük düzenleme (~155 satır)
- "ZERO TEXT" talimatı ekle (prompt wrapper)
- Geri kalanı aynı

---

## Phase 2: Backend — Config Temizliği

### 2.1 `functions/src/controllers/orchestrator/posterConfigController.ts` → Sadeleştir (~250 satır)

Kaldır:
- listPosterMoods, createPosterMood, updatePosterMood, deletePosterMood
- listPosterTypographies, listPosterLayouts
- listCameraAngles, listLightingTypes, listBackgrounds
- seedPosterConfig'den mood/typo/layout/camera/light/bg seed'leri

Kalsın:
- listPosterStyles → "kaydedilmiş analizler" olarak yeniden kullanılabilir
- listPosterAspectRatios
- listPosterGallery, deletePosterGalleryItem
- submitPosterFeedback
- getPosterGlobalRules, updatePosterGlobalRules, triggerPosterLearning

### 2.2 `functions/src/services/config/posterConfig.ts` → Sadeleştir (~100 satır)

Kaldır: moods, typographies, layouts, cameraAngles, lightingTypes, backgrounds cache/getter'ları
Kalsın: styles + aspectRatios

### 2.3 `functions/src/services/posterLearningService.ts` → Uyarla (~140 satır)
- styleId bağımlılığını kaldır, tüm düşük puanlı posterlerden öğren

---

## Phase 3: Frontend — Yeni UI

### 3.1 `admin/src/pages/Poster.tsx` → Komple yeniden yaz (~350 satır)

5 adımlı basit akış:
1. Referans poster yükle → analiz et
2. Analiz sonucunu gör (renk paleti, font önizleme, layout)
3. Ürün görseli yükle
4. Başlık/alt başlık/marka adı gir
5. Oluştur → arka plan üret → metin ekle → indir

### 3.2 `admin/src/components/poster/PosterAnalyzer.tsx` → Yeniden yaz (~300 satır)
- Görsel analiz sonuçları (renk swatchleri, font önizleme)
- "Stil olarak kaydet" kaldır — analiz ZATEN stil

### 3.3 `admin/src/components/poster/PromptGenerator.tsx` → SİL
- Yerine `PosterComposer.tsx` gelecek

### 3.4 `admin/src/components/poster/PosterComposer.tsx` → YENİ (~350 satır)
- Arka plan üretim butonu
- Metin overlay önizleme
- İndirme (html-to-image)

### 3.5 `admin/src/components/poster/TextOverlayCanvas.tsx` → YENİ (~250 satır)
- HTML div + absolute positioned text elementleri
- Google Fonts dinamik yükleme
- Kullanıcı font boyutu/pozisyon/renk ince ayar yapabilir
- `toPng()` ile yüksek çözünürlüklü export

---

## Phase 4: Temizlik
- Eski tip tanımları sil
- Ölü endpoint'leri kaldır
- index.ts export'ları güncelle
- Galeri geriye uyumlu (eski posterler posterUrl ile gösterilir)

---

## Font Eşleştirme Stratejisi

AI analiz prompt'unda top 50 Google Font listesi verilir:
- Serif: Playfair Display, Bodoni Moda, EB Garamond, Cormorant Garamond, Lora, DM Serif Display
- Sans: Inter, Montserrat, Poppins, DM Sans, Outfit, Plus Jakarta Sans
- Display: Bebas Neue, Oswald, Archivo Black, Abril Fatface

Tespit edilen font → en yakın Google Font eşleştirmesi + weight + fallback stack

Frontend'de dinamik yükleme:
```javascript
const link = document.createElement("link");
link.href = `https://fonts.googleapis.com/css2?family=${fontName}:wght@${weight}&display=swap`;
document.head.appendChild(link);
```

## Metin Overlay Sistemi

HTML-to-image yaklaşımı (Canvas API değil):
- `html-to-image` zaten dependency olarak mevcut
- HTML/CSS ile metin render → subpixel rendering, ligature desteği
- `document.fonts.ready` bekle → sonra `toPng()` çağır
- Yüksek çözünürlük: scale transform ile 2480x3508px export

## Riskler ve Çözümler

| Risk | Çözüm |
|------|-------|
| Font eşleştirme %100 doğru olmaz | Kullanıcı dropdown'dan değiştirebilir |
| Pozisyon tahmini yaklaşık | Sürükle-bırak veya slider ile ince ayar |
| Font yüklenmeden export | `document.fonts.ready` promise bekle |
| Gemini yine yazı koyar | Güçlü "ZERO TEXT" talimatı + boş alan bırakma |
| Eski galeri öğeleri | posterUrl alanı yeterli, analysis opsiyonel |

## Dosya Özeti

| Dosya | İşlem | Mevcut | Yeni |
|-------|-------|--------|------|
| types/poster.ts | Yeniden yaz | 160 | ~120 |
| posterSmartController.ts | Yeniden yaz | 818 | ~380 |
| posterImageController.ts | Küçük düzenleme | 161 | ~155 |
| posterConfigController.ts | Sadeleştir | 448 | ~250 |
| posterConfig.ts | Sadeleştir | 369 | ~100 |
| posterLearningService.ts | Uyarla | 158 | ~140 |
| Poster.tsx | Yeniden yaz | 1344 | ~350 |
| PosterAnalyzer.tsx | Yeniden yaz | 559 | ~300 |
| PromptGenerator.tsx | SİL | 521 | 0 |
| PosterComposer.tsx | YENİ | 0 | ~350 |
| TextOverlayCanvas.tsx | YENİ | 0 | ~250 |
| PosterGallery.tsx | Küçük düzenleme | 204 | ~210 |

**Toplam: 4742 → ~2605 satır (%45 azalma)**

## Doğrulama

1. `cd functions && npm run build` — backend hatasız derlenmeli
2. Admin panelde poster sayfası açılmalı — sadece upload + metin alanları görünmeli
3. Referans poster yükle → JSON analiz sonucu görmeli
4. Ürün görseli + metin gir → arka plan üret → yazısız görsel gelmeli
5. Metin overlay önizleme → Google Font yüklenmeli, doğru pozisyonda görünmeli
6. PNG indir → yüksek çözünürlük, font doğru render edilmiş olmalı
7. Galeri'de eski posterler hala görünmeli

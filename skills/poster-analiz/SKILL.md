---
name: poster-analiz
description: "Poster gorselini veya sozlu tarifi analiz edip admin panele yapistirilabilir stil formati uretir. Referans poster analizi — renk, isik, tipografi, layout, atmosfer, DALL-E prompt. API masrafi sifir. Tetikleyiciler — poster analiz, bu posteri analiz et, stil cikar, poster stil, analiz et su posteri."
---

# Poster Stil Analizi

Referans poster gorselini veya sozlu tarifi analiz edip, admin panele dogrudan yapistirilabilir formatta stil ciktisi uretir.

## Tetikleyiciler

- "poster analiz"
- "bu posteri analiz et"
- "stil cikar"
- "poster stil"
- Kullanici poster gorseli paylastiginda

## Surec

### Adim 1: Girdi Tipi Belirle

**Gorsel varsa:** Kullanici poster gorseli paylasti — dogrudan analiz et. Soru sorma, aciklama isteme — hemen analiz yap.

**Gorsel yoksa:** Kullanici sozlu tarif etti ("koyu yesil zemin, buyuk beyaz yazi, sagda urun"). Bu tarifi stil formatina cevir.

### Adim 2: Referans Template'i Oku

POSTER_STYLE_TEMPLATE.md dosyasini oku — analiz formati ve kurallari oradan gelir:

```
Read .claude/references/POSTER_STYLE_TEMPLATE.md
```

Bu dosya:
- styleDirective icindeki zorunlu bolumleri tanimlar (Color Palette, Background, Typography, Layout, Lighting, Overall Feel)
- Her bolumun format kurallarini verir (hex + yuzde + Kelvin + derece — belirsiz ifade YASAK)
- Layout bolumunde element-bazli detay zorunlulugunu belirtir
- DALL-E prompt kurallari ve ornegi vardir
- YASAK kelimeler listesi vardir

### Adim 3: Analiz Yap

Gorseli veya tarifi analiz ederken su siraya uy:

**A. Posterdeki TUM elemanlari tespit et:**
- Ana baslik (headline) — ne yaziyor, nerede, ne boyutta
- Alt baslik (subtitle) — varsa
- Urun (hero-product) — nerede, frame'in yuzde kaci
- Fiyat yazisi — varsa
- Logo/marka isareti — varsa
- Dekoratif elemanlar (el, aksesuar, prop, susler) — varsa
- Ikincil urunler/tabaklar — varsa
- Arka plan deseni/dokusu — varsa

**B. Her eleman icin konum bilgisi cikar:**
- Zone: top-left, top-center, center-right vs.
- Bounds: x ve y yuzde olarak (x:10-90% y:2-15%)
- Boyut: frame yuzdesine gore (%45 frame height)
- Katman sirasi (zIndex)
- Diger elemanlarla iliski (→ headline: directly below)

**C. Estetik DNA cikar:**
- Renk paleti: her rengin rolu + #HEX + yuzde + harmoni + Kelvin + doygunluk
- Arka plan: doku, grain, vignette, gradient (hex YAZMAZ — colorPalette'e ait)
- Tipografi: sinif, weight, case, spacing, renk, boyut (frame yuzdesine gore)
- Isik: pattern, quality, yon (derece), Kelvin, key-to-fill ratio, golge
- Atmosfer: 3-4 mood sifati, grain, depth, era

### Adim 4: Ciktiyi Olustur

Cikti TAM OLARAK bu formatta olmali (admin panel parse sistemi bu ayraclari bekler):

```
Aciklama: [1-2 cumle — bu stili benzersiz kilan sey, neyi degistirirsen bozulur]

--- Stil Tarifi ---
Color Palette: [rol: #HEX (N%), ...] — harmoni: X; sicaklik: XK; doygunluk: X; grade: X
Background: [doku/yuzey, gradient, grain, vignette — hex YAZMAZ]
Typography: Headline: [sinif] [weight] [case] [spacing] [renk #HEX], ~[N]% frame height. Subtitle: [...]. Hierarchy: N seviye.
Layout: Canvas: [oran]. [eleman]: [zone] (x:N-N% y:N-N%), [aciklama], [boyut]. → [iliski]. ... Layers: [sira]
Lighting: [pattern] [quality], [yon] [derece], [Kelvin]K, [ratio] key-to-fill, [golge]
Overall Feel: [3-4 mood sifati], [grain], [depth], [era]

--- DALL-E Prompt ---
A professional product poster featuring {PRODUCT} [150-250 kelime, tam detayli sahne tarifi]
```

### Adim 5: Kullaniciya Ver

Ciktiyi dogrudan ver. Ek aciklama, yorum, soru EKLEME. Kullanici bu ciktiyi admin panelde "Yeni Stil Ekle" → "Analiz Yapistir" alanina yapistiracak.

## Kurallar

### dallEPrompt Genellestirme Kurali (KRITIK)

dallEPrompt GENEL SABLON olmali — referans postere ozel detaylar yazilmaz.

**Degistirilecekler:**
- Referans posterdeki baslik metni → `{TITLE}`
- Referans posterdeki alt baslik metni → `{SUBTITLE}` 
- Referans posterdeki fiyat → `{PRICE}`
- Referans posterdeki urun adi/tarifi → `{PRODUCT}`
- Referans posterdeki marka/logo adi → "brand logo" (genel)
- Referans posterdeki spesifik aksesuar (chopstick, Japon yazisi) → "accent prop" veya kaldir
- Referans posterdeki spesifik insan detayi (kirmizi tirnak) → genel tarif ("human hand")
- Referans posterdeki spesifik yemek detayi (maydanoz, tofu) → kaldir (urun fotografi zaten yuklenecek)

**Kalacaklar (genel yapisal tarif):**
- Konum bilgileri (center-right, top 15%, x:10-90%)
- Boyut bilgileri (45% frame height)
- Font stili (geometric sans-serif bold ALL-CAPS)
- Renk hex kodlari (#3D5A3E, #FFFFFF)
- Isik tarifi (top-left 45°, 5500K, 4:1)
- Katman sirasi
- Dekoratif elemanlarin VARLIGI ve KONUMU (ama spesifik ne oldugu degil)

**Ornek donusum:**
- YANLIS: `A female hand with red nails enters from top-right, sprinkling seeds onto the bowl`
- DOGRU: `A hand enters from top-right edge, adding garnish onto {PRODUCT}`

- YANLIS: `Bottom-left: dark chopsticks at 30-degree diagonal`
- DOGRU: `Bottom-left: accent prop at 30-degree diagonal angle`

- YANLIS: `"POT'SOUP" in ALL-CAPS white`
- DOGRU: `"{TITLE}" in ALL-CAPS white`

### YASAK Kelimeler (ciktida asla kullanilmaz)
- "warm colors", "nice lighting", "clean look", "modern font", "minimal design"
- "beautiful", "stunning", "elegant" (olcu olmadan)
- "good composition", "well-balanced"
- Hex kodu olmadan renk tarifi
- Kelvin degeri olmadan isik tarifi
- Yuzde olmadan boyut tarifi
- Derece olmadan yon tarifi

### Zorunlu Olculer
- Her renk: #HEX + yuzde
- Her isik: Kelvin + derece + ratio
- Her boyut: frame yuzdesine gore
- Her konum: zone + x/y yuzde bounds
- Her font: sinif + weight + case + spacing + renk

### Layout Elemani Tamamlanma Kontrolu
Analiz bitmeden once kontrol et:
- [ ] Ana baslik tarif edildi mi?
- [ ] Alt baslik varsa yazildi mi?
- [ ] Urun (hero-product) konumu ve boyutu var mi?
- [ ] Fiyat/kalori yazisi varsa eklendi mi?
- [ ] Logo/marka isareti varsa eklendi mi?
- [ ] Dekoratif elemanlar (el, aksesuar, prop) varsa eklendi mi?
- [ ] Katman sirasi (Layers) yazildi mi?

### Sozlu Tarif Modu
Gorsel yoksa kullanicinin tarifi uzerinden:
- Eksik bilgiyi varsayimla tamamla (makul varsayimlar)
- Ama varsayimi belirt: "Varsayim: 2:3 portrait, ürün sağ-ortada"
- Kullanici duzeltebilir

## Ornekler

### Ornek Girdi: Pot'Soup Posteri (gorsel)
Koyu yesil zemin, ust ortada buyuk beyaz "POT'SOUP" yazisi, altinda "SOUP BY ITSU", solda urun adi ve fiyat, sagda buyuk kase, ustten el giriyor baharat serpiyor...

### Ornek Cikti:
```
Aciklama: Dikey bolunmus layout, koyu yesil matte zemin uzerinde beyaz tipografi ve canli urun fotografi. Elin baharat serpmesi dinamik hareket katiyor — bu olmadan poster statik kalir.

--- Stil Tarifi ---
Color Palette: dark green background: #3D5A3E (55%), white text: #FFFFFF (15%), product warm tones: #C8956A (12%), dark accent: #1A2E1A (10%), highlight cream: #F5F0E6 (8%) — harmoni: analogous green-earth; sicaklik: 4500K neutral-cool; doygunluk: muted with selective warmth on product; grade: lifted shadows to #3D5A3E, warm midtones on food
Background: solid matte surface, no visible texture, no grain, no vignette, even flat tone
Typography: Headline: geometric sans-serif black(900) ALL-CAPS very tight(-0.05em) #FFFFFF, ~15% frame height. Subtitle: same family medium(500) Title Case #FFFFFF, ~5% frame height. Body: regular(400) #FFFFFF, ~3% frame height. Hierarchy: 3 levels.
Layout: Canvas: 2:3 portrait. headline: top-center (x:5-95% y:2-15%), "POT'SOUP" bold white, ~15% frame height, centered. subtitle: top-center (x:20-80% y:15-20%), "SOUP BY ITSU" medium white, ~40% of headline. → headline: directly below. product-name: left (x:5-35% y:35-50%), "THAI COCONUT VEGGIE" 3 lines left-aligned white. price: left (x:5-25% y:50-55%), "£4.49" white bold. → product-name: directly below. hero-product: center-right (x:25-90% y:35-80%), large bowl, fills ~45% frame height, 30 degree above angle. human-hand: top-right (x:45-75% y:0-40%), female hand red nails, sprinkling seeds, zIndex:3. → hero-product: directly above bowl. chopsticks: bottom-left (x:3-15% y:82-98%), diagonal 30 degree. small-dish: bottom-center (x:40-55% y:88-98%), seeds dish. brand-logo: bottom-left (x:3-12% y:92-98%), "itsu" script white. japanese-text: bottom-right (x:70-95% y:90-97%), white decorative. Layers: background → product → chopsticks + dish → text → hand (topmost)
Lighting: natural-window soft diffused, top-left 45 degree, 5500K daylight, 4:1 key-to-fill, soft shadows lower-right, subtle rim on bowl edge
Overall Feel: fresh energetic inviting urban-casual, no grain, flat depth, contemporary, no texture overlay

--- DALL-E Prompt ---
A professional product poster featuring {PRODUCT} placed in center-right position, filling approximately 45% of the 2:3 portrait frame. Background is solid matte dark green (#3D5A3E) with no texture or grain. At the top, a large bold geometric sans-serif headline "{TITLE}" in ALL-CAPS white with very tight letter-spacing spans 80% of frame width, centered. Directly below, "{SUBTITLE}" in medium weight white at 40% of headline size. Left side at 35-50% height: product description text in white, left-aligned. Below that, "{PRICE}" in white bold. A hand enters from the top-right edge of the frame, adding garnish onto {PRODUCT}. Bottom-left: accent prop at 30-degree diagonal angle. Bottom-center: small dish with garnish elements. Bottom-left corner: small brand logo in white. Lighting is soft natural from top-left at 45 degrees, 5500K daylight, 4:1 key-to-fill ratio, soft shadows falling lower-right. Overall mood is fresh, energetic, and inviting. Contemporary flat style, no film grain, no vignette.
```

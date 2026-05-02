---
name: poster-maker
description: Pastane/kafe ürün tanıtım posterleri tasarla ve üret (40x60cm baskı kalitesinde). AI ile görsel + metin birlikte üretir. Tasarım sitelerinden ilham araştırması yapar, prompt üretir, Gemini ile görsel oluşturur, Real-ESRGAN ile baskı kalitesine upscale eder. Tetikleyiciler — "poster yap", "poster tasarla", "poster üret", "afiş yap", "tanıtım posteri", "40x60 poster", "baskı görseli", "mağaza posteri", "vitrin posteri", "ürün posteri", "poster prompt".
---

# Poster Maker

Pastane/kafe ürün tanıtım posterleri tasarla ve üret. 40x60cm baskı kalitesinde, AI ile görsel + metin birlikte.

## Sabit Marka Bloğu (Her Posterde Zorunlu)

Her posterin uygun bir köşesinde/altında şu marka bloğu bulunmalı:

```
Sade Patisserie
patisserie l'artisan
```

Bu blok küçük, zarif, asla baskın değil — ama her zaman mevcut. Serif font, tracked uppercase, muted renk.

## Görsel Referans Zorunluluğu

Kullanıcı poster isterken mutlaka ürün görseli de vermeli. Bu görsel:
- Posterdeki ürünün AI tarafından doğru tanımlanmasını sağlar
- food-photo-enhancer skill'indeki gibi analiz edilir — ürün tipi, malzemeler, renkler, dokular
- Prompt'a detaylı ürün tarifi olarak aktarılır

Görsel verilmediyse: "Poster için ürün görseli paylaşır mısın?" diye sor.

## Metin İçeriği Belirleme

Posterdeki metinler görseldeki ürüne göre otomatik şekillenir:

1. **Başlık**: Ürün adı (görselden veya kullanıcıdan) — büyük serif
2. **Alt başlık**: Ürünün 3-5 kelimelik cazip tanımı — görseldeki malzemelere bakarak üret
3. **Fiyat**: Kullanıcı isterse eklenir
4. **Marka bloğu**: Her zaman sabit (yukarıdaki)

Kullanıcı özel metin vermezse, görseldeki ürüne bakarak uygun başlık ve alt başlık öner.

## Poster Tipleri

| Tip | Açıklama | Metin İçeriği |
|-----|----------|---------------|
| **Ürün Hero** | Tek ürün, büyük, etkileyici | Ürün adı + kısa slogan + marka |
| **Sezonluk Tanıtım** | Mevsimsel kampanya | Kampanya adı + tarih + fiyat + marka |
| **Yeni Ürün Lansmanı** | Yeni ürün duyurusu | "Yeni" badge + ürün adı + açıklama + marka |
| **Menü Highlight** | Öne çıkan ürün grubu | Kategori adı + 2-3 ürün + marka |
| **Marka/Atmosfer** | Mekan tanıtımı | Marka adı + tagline |

## Süreç

### Adım 0: Görseli Analiz Et

Kullanıcının verdiği ürün görselini incele (food-photo-enhancer mantığıyla):
- Ürün tipini belirle (kruvasan, tart, pasta vs.)
- Görünen malzemeleri listele
- Renkleri, dokuları, şekli not et
- Bu bilgileri prompt'un ürün tarifi kısmında kullan

### Adım 1: Brief Al

Kullanıcıdan şu bilgileri topla (eksikse sor):

1. **Poster tipi**: Yukarıdaki tiplerden hangisi? (belirtilmezse "Ürün Hero" varsayılan)
2. **Özel metin**: Kullanıcının istediği başlık/slogan varsa al, yoksa görsele göre öner
3. **Fiyat**: Eklenecek mi?
4. **Ton/Mood**: Premium, sıcak, enerjik, minimal? (belirtilmezse "premium minimal" varsayılan)
5. **Mevsim/Bağlam**: Sezonluk mu? Özel gün mü?

### Adım 2: Tasarım Araştırması

Poster tasarımı için 5 tasarım kaynağını araştır. Paralel Agent'larla çalış.

**Arama stratejisi:**

```
site:dribbble.com food poster design bakery
site:dribbble.com product poster typography pastry
site:cosmos.so food poster print design
site:cosmos.so bakery branding poster
site:visualjournal.it food poster editorial typography
site:visualjournal.it bakery print design
site:behance.net pastry poster design 40x60
site:behance.net food photography poster layout
site:pinterest.com bakery poster design premium
site:pinterest.com patisserie poster typography
```

**Araştırma odağı (poster'e özel):**

| Kategori | Ne Aranır |
|----------|-----------|
| **Layout** | Metin-görsel dengesi, üst/alt metin alanı, asimetrik yerleşim |
| **Tipografi** | Serif vs sans-serif, font boyutu hiyerarşisi, metin yerleşimi |
| **Renk** | Yemek sektörü renk paletleri, kontrast, okunurluk |
| **Fotoğraf Stili** | Açı, ışık, ürün yerleşimi, negatif alan |
| **Baskı Detayları** | Kenar boşlukları, bleed alanı, çözünürlük |

**Rapor formatı:**

```
## Poster Tasarım İlhamı

### Trend Bulgular
1. [Trend] — [kaynak] — [nasıl uygulanır]
2. ...

### Önerilen Yaklaşım
- Layout: [...]
- Tipografi: [...]
- Renk paleti: [...]
- Fotoğraf stili: [...]
```

### Adım 3: Poster Prompt Üretimi

40x60cm poster için optimize edilmiş AI prompt üret.

**Teknik gereksinimler:**

| Parametre | Değer |
|-----------|-------|
| Aspect ratio | 2:3 (portrait) |
| Hedef çözünürlük | 4724 x 7087 px (300 DPI) |
| AI üretim çözünürlüğü | ~1400 x 2100 px (upscale öncesi) |
| Metin alanı | Üst veya alt %20-25 boşluk |
| Güvenli alan | Kenarlardan 2cm (baskı bleed) |

**Prompt yapısı:**

```
POSTER TYPE: [ürün hero / sezonluk / lansman / menü / marka]
DIMENSIONS: 2:3 portrait ratio (40x60cm print poster)

PRODUCT ZONE (üst/orta %60-70):
[Ürün açıklaması — food-photo-enhancer skill'indeki SCASS formatı]
- Ürünün detaylı görsel tarifi
- Açı, ışık, kompozisyon
- Arka plan atmosferi (poster'e uygun, sade beyaz DEĞİL)

TEXT ZONE (alt/üst %25-30):
"[Ana başlık metni]" — large, elegant, clearly readable
"[Alt başlık / fiyat / slogan]" — smaller, complementary
- Font stili: [serif / sans-serif / script — araştırmaya göre]
- Renk: [metin rengi — arka planla kontrast]
- Yerleşim: [ortalı / sola yaslı / sağa yaslı]

ATMOSPHERE & BACKGROUND:
- Poster arka planı (beyaz değil — mood'a uygun gradient, renk, doku)
- Dekoratif öğeler varsa (minimal, ürünü gölgelemeyen)

STYLE: Professional print poster for premium patisserie.
High-end food photography meets editorial poster design.
Clean typography, generous white space, luxury feel.

CRITICAL RULES:
- Text must be CLEARLY READABLE — high contrast against background
- Product must be the HERO — text supports, doesn't dominate
- Leave SAFE MARGINS (2cm equivalent) for print bleed
- NO cluttered design — minimal, premium, breathable
```

**Metin yazma kuralları (Gemini için):**

- Metni tırnak içinde yaz: `"Taze Kruvasan"` — Gemini tırnak içini birebir yazar
- Türkçe karakterlere dikkat: ş, ç, ğ, ı, ö, ü doğru yazılmalı
- Maksimum 2 satır metin — daha fazlası karmaşık ve okunmaz
- Font stili prompt'ta belirt: "elegant serif font", "modern sans-serif", "handwritten script"

### Adım 4: Görsel Üretimi

**Birincil: Gemini (Nano Banana Pro)**
- Mevcut pipeline veya doğrudan Gemini API
- Aspect ratio: 2:3
- Metin yazma yeteneği iyi — önce bununla dene

**Yedek: Ideogram 3.0** (metin kalitesi yetersizse)
- Tipografi konusunda sektör lideri (~%90 doğruluk)
- Poster/afiş için özel olarak eğitilmiş
- API erişimi: $15/ay (Plus plan)
- Prompt'u Ideogram formatına uyarla

**Karşılaştırma ve karar:**

1. Gemini ile üret
2. Metni kontrol et — okunuyor mu, doğru yazılmış mı?
3. Sorunluysa → Ideogram ile tekrar üret
4. Her iki sonucu kullanıcıya sun

### Adım 5: Upscale (Baskı Kalitesi)

AI üretimi ~1400x2100px → Baskı için 4724x7087px (300 DPI) gerekli.

**Real-ESRGAN (açık kaynak, ücretsiz):**

```bash
# Kurulum
pip install realesrgan

# Upscale (4x)
python -m realesrgan -i poster_input.png -o poster_output.png -s 4

# Alternatif: özel model (fotoğraf için daha iyi)
python -m realesrgan -i poster_input.png -o poster_output.png -n realesrgan-x4plus
```

**Alternatif upscale araçları:**
- **Topaz Gigapixel AI** — ücretli ama en kaliteli
- **Upscayl** — ücretsiz desktop app (Real-ESRGAN tabanlı)
- **waifu2x** — anime/illüstrasyon için

**Upscale sonrası kontrol:**
- Metin hâlâ keskin mi?
- Ürün detayları korunmuş mu?
- Artifacting var mı? (özellikle metin kenarlarında)

### Adım 6: Çıktı ve Baskı Hazırlığı

Kullanıcıya teslim:

1. **AI üretim görseli** (orijinal çözünürlük)
2. **Upscale talimatları** (komut satırı veya araç önerisi)
3. **Baskı notları:**
   - Dosya formatı: TIFF veya yüksek kalite PNG (JPEG sıkıştırma kaybı yapar)
   - Renk profili: CMYK dönüşümü gerekebilir (ekran RGB, baskı CMYK)
   - Bleed: 3mm her kenardan taşma alanı bırak
   - Kağıt önerisi: 200-250gr kuşe mat veya parlak

## Hızlı Şablonlar

### Ürün Hero Poster

```
Poster tipi: Ürün Hero
Ürün: [ürün adı]
Başlık: "[ürün adı]"
Alt başlık: "[slogan veya fiyat]"
Mood: Premium, minimal
```

### Sezonluk Kampanya

```
Poster tipi: Sezonluk
Ürün: [mevsimsel ürün]
Başlık: "[kampanya adı]"
Alt başlık: "[tarih aralığı]"
Mood: Sıcak, davetkar
```

## Kurallar

- **Araştırma önce.** Her poster öncesi en az 3 kaynak araştır.
- **Metin okunabilirliği her şeyden önemli.** Metin okunmuyorsa poster başarısız.
- **Ürün her zaman hero.** Metin destekler, baskılamaz.
- **Minimal tasarım.** Kalabalık poster = kötü poster. Az eleman, çok etki.
- **Baskı gerçekçiliği.** Ekranda güzel görünen baskıda kötü olabilir — CMYK ve çözünürlük uyarısı ver.
- **Türkçe karakter kontrolü.** Her prompt'ta Türkçe harfleri doğrula.
- **food-photo-enhancer ile uyumlu.** Ürün fotoğrafı kısmında aynı SCASS framework'ünü kullan.

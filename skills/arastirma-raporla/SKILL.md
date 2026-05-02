---
name: arastirma-raporla
description: Use when kullanıcı bilgi boşluğu hissettiği bir konuda sektör standardı araştırması + büyük oyuncu çözüm örnekleri + kalıcı markdown rapor dosyası istediğinde. Tetikleyiciler — "araştır ve raporla", "sektör nasıl yapıyor", "best practice araştır", "X nasıl çözüyor", "Square/Shopify/Toast/Stripe nasıl yapmış", "web ve github araştırması yap", "rapor olarak kaydet", "araştırma raporu hazırla", "büyük oyuncular nasıl yapmış".
---

# Araştırma ve Raporla

## Amaç

Kullanıcı bir karar noktasında duruyor ve o konuda bilgisi eksik. Kendi kafasından çözüm uydurmak yerine **sektör birikiminden** yararlanmak istiyor. Bu skill:

1. **Gerçek kaynaklardan** sektör standartlarını bulur (web + GitHub)
2. **Büyük oyuncuların** (Square, Shopify, Toast, Stripe, vb.) çözümlerini inceler
3. Bulguları karşılaştırıp **ortak prensipler + ayrışan yaklaşımlar** çıkarır
4. Sonuçları **kalıcı markdown dosyasına** yazar — chat'te yanıp sönmez
5. Kullanıcının projesine uygulanabilirlik çıkarımı yapar

## Temel Prensip — Varsayım Yasak

**Her iddianın arkasında somut kaynak (link, repo, dokümantasyon) olmalı.**

- ❌ "Muhtemelen şöyle yapıyorlar"
- ❌ "Genelde böyle olur"
- ❌ "Bildiğim kadarıyla..."
- ✅ "Stripe docs'ta şöyle yazıyor: [link]"
- ✅ "Shopify'ın açık kaynak repo'sunda şu pattern var: [github URL]"
- ✅ "Square geliştirici blogunda 2024'te bu yaklaşımı duyurdu: [blog URL]"

Eğer kaynak bulamadıysan → **"Bu konuda yeterli kaynak bulamadım"** yaz. Uydurma.

## Süreç — 7 Adım

### 1. Konuyu Netleştir
Kullanıcıya **tek soru** ile netleştir:
- Hangi konu tam olarak? (örn. "yeni müşteri onboarding akışı")
- Karar bağlamı ne? (örn. "ikinci tenant eklemek üzereyim, nasıl yapmalıyım")
- Hangi zaman dilimi? (örn. "2024-2026 güncel pratikler")

Konu **açıksa** (kullanıcı zaten net söylemişse) bu adımı atla.

### 2. Sektör Genel Araştırması
`WebSearch` ile genel araştırma:
- "X onboarding best practices 2025"
- "X SaaS X tenant provisioning"
- "how to do X in SaaS"
- Türkçe varyantlar da dene

**Aranacak kaynak tipleri:**
- SaaS/ürün blogu yazıları (Stripe, Intercom, Amplitude)
- Engineering blog (Shopify, GitHub, Airbnb)
- Konferans konuşmaları (SaaStr, GOTO)
- Stack Overflow yüksek upvote'lu sorular

### 3. 2-3 Büyük Oyuncu İncele
Her büyük oyuncu için:
- Resmi dokümantasyon / developer docs → WebFetch
- Engineering blogu (varsa)
- GitHub repo (açık kaynaksa)
- Screenshot'lı blog yazıları (UX için)

**Büyük oyuncu seçimi** — kullanıcının sektörüne göre:
- B2B SaaS → Stripe, Intercom, Slack
- POS/Perakende → Square, Toast, Clover
- E-ticaret → Shopify, WooCommerce
- Fintech → Stripe, Plaid
- Genel → HubSpot, Notion, Linear

Eğer emin değilsen **kullanıcıya sor** hangi oyuncuların daha alakalı olduğunu.

### 4. GitHub Araştırması
`gh` CLI veya WebFetch ile:
- İlgili açık kaynak projelerde README/docs
- Issue tartışmaları (aynı probleme insanların yaklaşımı)
- Kod örnekleri (gerçek implementation)

**Tipik GitHub aramaları:**
- `site:github.com [konu] pattern`
- `tenant provisioning typescript`
- `saas onboarding flow nextjs`

### 5. Sentez — Ortak + Ayrışan
Bulguları 2 sütunlu tabloya koy:

| Ortak Prensipler | Ayrışan Yaklaşımlar |
|------------------|---------------------|
| A pattern'i herkeste var | Şirket A şöyle, Şirket B böyle yapıyor |
| B gerekliliği standart | Trade-off noktası: hız vs güvenlik |

Her satır için **kaynak linki** ekle.

### 6. Raporu Yaz
Dosya yolu: `docs/research/YYYY-MM-DD-<konu-slug>.md`

Proje dizini yoksa `docs/research/` klasörünü oluştur.

Şablon (bkz. `TEMPLATE` bölümü aşağıda).

### 7. Özet Sun
Kullanıcıya **3-5 cümle** özet:
- Dosya yolu (clickable markdown link)
- En kritik 3 bulgu
- Kullanıcının sonraki adım önerisi

Uzun paragraf yazma — ayrıntılar raporda zaten.

## Rapor Şablonu

```markdown
# [Konu]: Sektör Araştırma Raporu

**Tarih:** YYYY-MM-DD
**Araştıran:** Claude (oturum sırasında)
**Amaç:** [Kullanıcının hangi karar için istediği]

## TL;DR (3 cümle)
[En kritik bulguların özeti]

## Araştırma Yöntemi
- Aranan kaynaklar: [web blogları, docs, GitHub]
- İncelenen büyük oyuncular: [A, B, C]
- Anahtar kelimeler: [liste]

## Sektör Genel Pratikleri
### Ortak Prensipler
- **Prensip 1** — [açıklama]. Kaynak: [link]
- **Prensip 2** — [açıklama]. Kaynak: [link]

### Ayrışan Yaklaşımlar
- **Yaklaşım A** — [açıklama]. Kullanan: [şirket]. Kaynak: [link]
- **Yaklaşım B** — [açıklama]. Kullanan: [şirket]. Kaynak: [link]

## Büyük Oyuncu İncelemeleri

### [Oyuncu 1 — örn. Stripe]
**Çözüm özeti:** ...
**Kilit pattern:** ...
**Kaynaklar:**
- [Docs URL]
- [Blog yazısı URL]
- [GitHub repo URL, varsa]

### [Oyuncu 2 — örn. Shopify]
(aynı yapı)

### [Oyuncu 3 — örn. Square]
(aynı yapı)

## Karşılaştırma Tablosu

| Kriter | Oyuncu 1 | Oyuncu 2 | Oyuncu 3 |
|--------|----------|----------|----------|
| [Kriter A] | ... | ... | ... |
| [Kriter B] | ... | ... | ... |

## Bu Projeye Uygulanabilirlik
- **Hemen alınabilir:** [hangi pattern'ler direkt uygulanır]
- **Adapte edilmeli:** [hangi pattern'ler modifiye gerektirir]
- **Uygulanamaz:** [hangi pattern'ler bu projeye uymaz, neden]

## Önerilen Sonraki Adımlar
1. [Somut adım]
2. [Somut adım]
3. [Somut adım]

## Ek Okumalar
- [URL] — [kısa açıklama]
- [URL] — [kısa açıklama]

## Bulunamayan Bilgiler
[Araştırmada cevap bulunamayan sorular varsa buraya yaz. Dürüstlük için kritik.]
```

## Yaygın Hatalar

| Hata | Neden Yanlış | Doğrusu |
|------|--------------|---------|
| "Muhtemelen şöyle yapıyorlar" | Varsayım, kaynak yok | WebSearch/WebFetch ile gerçek kaynak bul |
| 5-6 oyuncu yüzeysel | Kapsam geniş, derinlik yok | 2-3 oyuncu ama derinlemesine |
| Hepsi aynı bulgu — "herkes benzer yapıyor" | Muhtemelen yüzeysel araştırma | Ayrışan yaklaşımları da ara |
| Rapor çok uzun (2000+ satır) | Kimse okumaz | Öz tut, detaylar için link ver |
| Tarih yok / slug yok | Sonra bulunamaz | `YYYY-MM-DD-konu-slug.md` formatı zorunlu |
| Kullanıcının sektörüyle alakasız oyuncular | Uygulanabilirlik düşük | Kullanıcının alanına göre seç |
| Sadece İngilizce kaynaklar | Türkçe bağlam eksik | Türkçe aramalar da dene (örn. "vertical saas türkiye") |

## Hangi Araçları Kullan

| Amaç | Araç |
|------|------|
| Genel web araması | `WebSearch` |
| Belirli URL'den içerik çekme | `WebFetch` |
| Dosya oluşturma | `Write` (docs/research/ altında) |
| Dizin kontrolü | `Bash: ls` |
| Progress tracking | `TodoWrite` (4+ adımlı iş olduğu için) |

## Ne Zaman Kullanma

- Kullanıcı **sadece hızlı bir soru** soruyorsa (örn. "şu komut ne işe yarar") → skill invoke etme, doğrudan cevap ver.
- Kullanıcı **kendi kararını vermiş**, sadece implementasyon istiyorsa → skill invoke etme.
- Bilgi zaten **proje içinde dokümante edilmiş** ise → önce projede ara, skill'e düşme.

## Başarı Kriterleri

Rapor tamamlandığında:
1. ✅ Dosya `docs/research/YYYY-MM-DD-konu.md` formatında var
2. ✅ Her iddianın yanında **tıklanabilir kaynak** var
3. ✅ 2-3 büyük oyuncu **somut olarak** incelenmiş
4. ✅ Ortak + ayrışan pattern'ler net ayrılmış
5. ✅ Kullanıcının projesine **uygulanabilirlik** bölümü var
6. ✅ "Bulunamayan bilgiler" bölümünde dürüst itiraflar var (varsa)
7. ✅ Chat'te uzun paragraf yerine **kısa özet + dosya linki** sunulmuş

Kriter karşılanmıyorsa rapor eksik — bitirmeden kullanıcıya sunma.

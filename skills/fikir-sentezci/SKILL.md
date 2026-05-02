---
name: fikir-sentezci
description: >
  Mevcut bir plan veya karar dokümanı üzerinde dışarıdan gelen fikirleri değerlendirir ve sentezler.
  Gelen fikir planla uyumluysa entegre eder, alakasızsa flag'ler, yeni fikirler üretir.
  Tetikleyiciler: "sentezle", "bu fikri değerlendir", "plana ekle", "bu ne dersin",
  "dışarıdan fikir geldi", "bunu plana dahil et", "fikir sentezi".
  Girdi formatları: metin, URL, dosya, screenshot.
---

# Fikir Sentezci

Mevcut bir plan/karar dokümanı üzerinde çalışan fikir değerlendirme ve entegrasyon aracı.

## Temel Felsefe

- Kullanıcının planı TEK GERÇEKTİR. Dışarıdan gelen her fikir bu plana göre değerlendirilir.
- Yalakalık yok. Fikir kötüyse kötü de, alakasızsa alakasız de.
- Fikri değerlendir ama ASLA planı kullanıcı onayı olmadan değiştirme.

## Akış

### 1. Plan Bağlamını Yakala

Skill başlatıldığında mevcut konuşmada bir plan/karar dokümanı olmalı.
Yoksa kullanıcıya sor: "Üzerinde çalıştığımız planı paylaşır mısın?"

Plan bağlamından şunları çıkar:
- **Ana hedef**: Plan neyi çözmeye çalışıyor?
- **Alınan kararlar**: Hangi yönde ilerlemeye karar verilmiş?
- **Kırmızı çizgiler**: Neler reddedilmiş veya dışarıda bırakılmış?

### 2. Gelen Fikri Al ve Anla

Girdi formatına göre:
- **Metin**: Doğrudan oku ve özetle
- **URL**: WebFetch ile içeriği çek, planla ilgili kısımları ayıkla
- **Dosya**: Read ile oku, planla ilgili kısımları ayıkla
- **Screenshot**: Görseli oku, içeriğini yorumla

Fikrin özünü 1-2 cümlede çıkar: "Bu fikir şunu öneriyor: ..."

### 3. Uyumluluk Değerlendirmesi

Gelen fikri plana karşı değerlendir. Üç kategori kullan:

#### Çok Uyumlu
- Planın ana hedefiyle doğrudan örtüşüyor
- Alınan kararları destekliyor veya güçlendiriyor
- Planın eksik bir noktasını tamamlıyor

Çıktı formatı:
```
UYUMLU — Bu fikir planımızla örtüşüyor.

Ne diyor: [1-2 cümle özet]
Planın neresine oturuyor: [hangi bölüm/karar]
Nasıl entegre edilir: [somut öneri]
Planı nasıl güçlendirir: [katkısı]
```

#### Kısmen Uyumlu
- Planın ruhuna uygun ama detaylarda farklılık var
- Bazı kısımları işe yarar, bazıları planla çelişir
- İlginç ama uyarlanması gerekir

Çıktı formatı:
```
KISMEN UYUMLU — İlginç ama uyarlama gerekiyor.

Ne diyor: [1-2 cümle özet]
Uyumlu kısımları: [planla örtüşen noktalar]
Çelişen kısımları: [planla çatışan noktalar]
Uyarlama önerisi: [nasıl değiştirilirse plana oturur]
```

#### Alakasız
- Planın hedefiyle ilgisi yok
- Veya planın kırmızı çizgileriyle doğrudan çelişiyor
- Veya çok farklı bir problemi çözüyor

Çıktı formatı:
```
ALAKASIZ — Bu fikir planımızla örtüşmüyor.

Ne diyor: [1-2 cümle özet]
Neden alakasız: [somut açıklama]
Park edildi: Evet — ileride başka bir bağlamda işe yarayabilir.
```

### 4. Beyin Fırtınası (Opsiyonel ama Değerli)

Gelen fikir UYUMLU veya KISMEN UYUMLU ise, bu fikirden esinlenerek yeni fikirler üret:

```
Bu fikirden esinlenen düşünceler:
1. [Fikir A] — [neden ilginç]
2. [Fikir B] — [neden ilginç]
3. [Fikir C] — [neden ilginç]
```

Kurallar:
- En fazla 3 ek fikir üret. Kalite > Miktar.
- Her fikir planın mevcut hedefine hizmet etmeli.
- "Olsa güzel olur" değil, "bunu yaparsan şu somut fayda olur" şeklinde yaz.
- Eğer beyin fırtınası üretecek bir şey yoksa, zorla üretme. "Bu fikir yeterince net, ek öneri yok" de.

### 5. Plan Güncelleme Önerisi

Eğer fikir UYUMLU veya KISMEN UYUMLU ise, planın güncellenmesi için somut öneri sun:

```
Önerilen Plan Güncellemesi:
- [Bölüm X]'e şu madde eklensin: "..."
- [Bölüm Y]'deki şu ifade güçlendirilsin: "..."
```

ASLA planı doğrudan değiştirme. Sadece öneri sun, kullanıcı onaylarsa uygula.

## Çoklu Fikir Senaryosu

Kullanıcı birden fazla fikri aynı anda paylaşabilir. Bu durumda:
1. Her fikri ayrı ayrı değerlendir
2. Fikirler arası ilişkileri belirt ("Fikir 2, Fikir 1'i tamamlıyor" gibi)
3. Sonunda birleşik bir özet sun

## Önemli Kurallar

- Plan kullanıcının mülküdür. Saygı göster, sahiplenme.
- Dışarıdan gelen her fikir (AI dahil) şüpheyle karşılanır. Planla uyumu KANITLA.
- Fikir çok güzel olsa bile plan kırmızı çizgileriyle çelişiyorsa → ALAKASIZ.
- Kullanıcı "ekle" derse ekle, "bırak" derse bırak. Tartışmayı uzatma.
- Türkçe yaz, teknik terimlerde İngilizce parantez içinde verilebilir.

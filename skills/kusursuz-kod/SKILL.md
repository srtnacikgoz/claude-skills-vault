---
name: kusursuz-kod
description: "Kusursuz kod yazma süreci — tek seferde çalışan, hatasız kod üretmek için zorunlu adımlar. Kod yazmadan önce tüm etki haritasını çıkarır, değişiklik zincirini takip eder, zihinsel build yapar. Her değişikliği tek seferde doğru yapar, 'sonra düzeltiriz' yaklaşımını reddeder. Tetikleyiciler — kusursuz yaz, hatasız yaz, tek seferde çalışsın, düzgün planla, sorunsuz kod, dikkatli yaz, kusursuz-kod."
---

# Kusursuz Kod Yazma Süreci

Bu skill, kod değişikliği yapmadan ÖNCE çalıştırılması gereken zorunlu bir süreçtir. Amaç: tek seferde çalışan, düzeltme gerektirmeyen kod üretmek.

## Ne Zaman Kullanılır

- Birden fazla dosyada değişiklik yapılacaksa
- Type/interface değiştirilecekse
- Bir alan eklenecek/kaldırılacaksa
- Refaktör yapılacaksa
- Kullanıcı "tek seferde çalışsın", "hatasız yaz", "dikkatli ol" dediğinde

## Ne Zaman KULLANILMAZ

- Tek satır düzeltme (typo, basit fix)
- Sadece yeni dosya oluşturma (mevcut koda dokunmuyorsa)
- Araştırma/okuma görevi

---

## ZORUNLU SÜREÇ

### Faz 1: Etki Haritası (Kesinlikle Atlanmaz)

Değişiklik yapmadan önce, değişecek her kavram için **tam etki haritası** çıkar:

```
Değişen şey: [alan/type/fonksiyon adı]
├── Type tanımı: [dosya:satır]
├── Backend kullanımı: [dosya:satır] — nasıl kullanılıyor
├── Frontend kullanımı: [dosya:satır] — nasıl kullanılıyor  
├── API çağrısı: [dosya:satır] — nasıl gönderiliyor
├── Firestore okuma: [dosya:satır] — nasıl okunuyor
├── Firestore yazma: [dosya:satır] — nasıl yazılıyor
├── Seed data: [dosya:satır] — varsayılan değer var mı
├── Import eden dosyalar: [liste]
└── Başka referanslar: [varsa]
```

**Nasıl yapılır:**
1. `Grep` ile değişen alan/fonksiyon adını tüm projede ara
2. Her sonucu oku — sadece dosya adı değil, kullanım bağlamını anla
3. Zincirleri takip et: A dosyası B'ye prop geçiyor → B bunu C'ye API olarak gönderiyor → C bunu Firestore'a yazıyor
4. Zincirin **son halkasına** kadar git — "muhtemelen başka yerde kullanılmıyordur" YASAK

**Çıktı formatı:**
```
## Etki Haritası: [değişiklik adı]

### [Dosya 1 tam yolu]
- Satır X: [ne yapıyor, nasıl etkileniyor]
- Satır Y: [ne yapıyor, nasıl etkileniyor]

### [Dosya 2 tam yolu]  
- Satır X: [ne yapıyor, nasıl etkileniyor]

### Toplam etkilenen dosya: N
### Toplam değişecek nokta: N
```

### Faz 2: Değişiklik Planı

Etki haritası çıktıktan sonra, **her dosya için** ne değişeceğini yaz:

```
## Değişiklik Planı

### Dosya 1: [tam yol]
- Satır X: [eski] → [yeni]
- Satır Y: kaldırılacak
- Satır Z: eklenecek

### Dosya 2: [tam yol]
- Satır X: [eski] → [yeni]

### Sıralama: [hangi dosya önce değişmeli — type → backend → frontend]
```

**Sıralama kuralı:**
1. Type tanımları (interface/type) — önce
2. Backend (controller/service) — sonra
3. Frontend (component/page) — en son
4. Seed data — varsa son

### Faz 3: Zihinsel Build

Her dosya değişikliği için kodu yazmadan önce şu soruları sor:

**TypeScript:**
- [ ] Opsiyonel alan gerçekten opsiyonel mi? (`undefined` geldiğinde patlıyor mu?)
- [ ] Type'ı kullanan her yer yeni yapıya uyumlu mu?
- [ ] Import'lar güncel mi?

**JSX/React:**
- [ ] Her açılan tag kapanıyor mu?
- [ ] Ternary'nin iki kolu da geçerli JSX mi?
- [ ] map() içinde key var mı?
- [ ] State kaldırıldıysa onu kullanan her JSX temizlendi mi?

**Firestore/Backend:**
- [ ] Eski veri formatı yeni kodu kırar mı? (backward compat)
- [ ] Opsiyonel alan `undefined` geldiğinde fallback var mı?
- [ ] API response formatı değişti mi? Frontend bunu bekliyor mu?

**Build:**
- [ ] `tsc` yetmez — `npx vite build` gerekli (esbuild farklı parse eder)
- [ ] Functions build: `cd functions && npm run build`

### Faz 4: Uygulama

**Kural: Bir dosyayı değiştir → mantıksal doğruluğunu kontrol et → sonraki dosyaya geç.**

1. Type dosyasını düzenle → oku, doğrula
2. Backend dosyasını düzenle → oku, doğrula → `npm run build`
3. Frontend dosyasını düzenle → oku, doğrula → `npx vite build`
4. Hata varsa: **hemen dur**, hatanın kaynağını bul, düzelt, tekrar build

**Paralel değişiklik SADECE birbirinden bağımsız dosyalarda.**

### Faz 5: Doğrulama

```bash
# Backend
cd functions && npm run build

# Frontend  
cd admin && npx vite build

# İkisi de hatasız geçmeli
```

Hata varsa:
1. Hata mesajını oku — dosya ve satır numarasını bul
2. O satırı oku — bağlamı anla
3. Etki haritasında kaçırılan bir yer mi? Kontrol et
4. Düzelt → tekrar build

---

## Backward Compatibility Kontrol Listesi

Bir alan kaldırılıyor veya değiştiriliyorsa:

- [ ] Firestore'da mevcut dökümanlar eski formatta — yeni kod bunları okuyabilmeli
- [ ] Opsiyonel yap (`?`) veya fallback ekle
- [ ] Eski alanı kullanan frontend bileşenleri hata vermemeli
- [ ] API endpoint'i eski format body gönderilse de çalışmalı

---

## Anti-Pattern'ler (YASAK)

1. **"Muhtemelen başka yerde kullanılmıyordur"** → Grep ile kontrol et
2. **"Build geçer herhalde"** → Build et, gör
3. **"Sonra düzeltiriz"** → Şimdi düzelt
4. **5 dosyayı değiştirip sonra build** → Her dosyadan sonra doğrula
5. **Sadece `tsc` ile yetinmek** → `npx vite build` de çalıştır
6. **Etki haritası çıkarmadan koda başlamak** → Önce harita, sonra kod
7. **Hata mesajını okumadan tekrar denemek** → Oku, anla, sonra düzelt

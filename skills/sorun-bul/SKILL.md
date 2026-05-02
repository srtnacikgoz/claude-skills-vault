---
name: sorun-bul
description: Sorunları derinlemesine araştır ve kök nedeni bul. CSS/UI bozuklukları, runtime hataları, veri eşleşme sorunları, build hataları, performans sorunları — her tür sorun için kapsamlı araştırma. Tetikleyiciler — "sorun bul", "kapsamlı araştır", "kapsamlıca araştır", "bu sorunu araştır", "neden böyle", "neden çalışmıyor", "debug et", "sorun ne", "hata bul", "investigate". Gerektiğinde web ve GitHub araştırması da yapar.
---

# Sorun Araştırma Süreci

Her sorun için aşağıdaki adımları sırayla izle. Adım atlama.

## 1. Sorunu Tanımla

- Kullanıcının tarif ettiği veya screenshot'ta görünen sorunu **tek cümlede** özetle.
- Beklenen davranış vs gerçekleşen davranış net olsun.
- Screenshot varsa dikkatlice incele — görsel ipuçları kritik.

## 2. Kanıt Topla (Kod Tarafı)

Soruna göre şu araştırmaları yap (hepsini değil, ilgili olanları):

**CSS/UI sorunları:**
- İlgili component'i oku, class'ları kontrol et
- Parent container'ın layout etkisini incele (flex, grid, overflow)
- Görsellerin gerçek boyutlarını kontrol et (`sips -g pixelHeight -g pixelWidth`)
- Şeffaf alan, padding, margin sorunlarını araştır
- Browser cache olasılığını değerlendir

**Runtime hataları:**
- Hata mesajını parse et — dosya, satır, stack trace
- İlgili dosyayı oku, hatanın oluştuğu context'i anla
- Server vs client component ayrımını kontrol et
- Import'ları, prop tiplerini, null/undefined olasılıklarını incele

**Veri sorunları:**
- Veri kaynağını kontrol et (DB query, API call, Firebase)
- Dönen veriyi logla veya test et
- Eşleşme/mapping sorunlarını araştır (unicode, büyük/küçük harf, boşluk)
- Schema uyumsuzluğu kontrol et

**Build/Config sorunları:**
- `package.json`, `next.config.ts`, `tsconfig.json` kontrol et
- Environment variable'ları kontrol et
- Versiyon uyumsuzluklarını araştır

## 3. Hipotez Oluştur

- Toplanan kanıtlara dayanarak **en olası 2-3 neden** listele.
- Her hipotez için güven seviyesi belirt (yüksek/orta/düşük).
- En yüksek güvenli hipotezden başla.

## 4. Hipotezi Test Et

- Hipotezi doğrulayacak **minimal bir test** yap.
- Kodu değiştirmeden önce sorunu doğrula.
- Gerekirse geçici log/debug kodu ekle, sonra kaldır.

## 5. Web/GitHub Araştırması (Gerekirse)

Eğer adım 2-4 sorunu çözmezse:

- **WebSearch** ile hata mesajı + framework versiyonu ara
- **GitHub Issues** araştır: `site:github.com [framework] [hata mesajı]`
- Stack Overflow, framework docs kontrol et
- Bulunan çözümleri mevcut context'e uyarla — kopyala-yapıştır yapma

## 6. Çözümü Uygula

- Kök nedeni açıkla — kullanıcıya **neden** olduğunu söyle.
- Minimum değişiklikle düzelt — gereksiz refactor yapma.
- Çözümün yan etkilerini değerlendir.

## 7. Doğrula

- Çözümden sonra sorunun gerçekten düzeldiğini kontrol et.
- İlgili başka yerlerde aynı sorun var mı kontrol et.
- Kullanıcıya sonucu bildir.

## Kritik Kurallar

- **Tahmin etme, araştır.** "Muhtemelen şudur" deyip geçme, kanıtla.
- **Bir seferde bir hipotez test et.** Aynı anda 3 şeyi değiştirme.
- **Orijinal dosyaları koru.** Araştırma sırasında dosyaları bozma.
- **Cache'i unutma.** Görsel/font/CSS sorunlarında her zaman cache olasılığını değerlendir.
- **Unicode tuzaklarına dikkat.** Türkçe karakterlerde NFC normalization uygula.
- **Screenshot varsa mutlaka oku.** Görsel kanıt sözlü tanımdan daha değerli.

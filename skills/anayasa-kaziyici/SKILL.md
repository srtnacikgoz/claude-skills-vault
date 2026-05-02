---
name: anayasa-kaziyici
description: Kullanıcının belirlediği kuralları o konuyla ilgili her şeyde geçerli olacak şekilde anayasa maddesi olarak kazır. Çağrıldığında yazılan kurallar o kadar net, bağlayıcı ve çok katmanlı biçimde ifade edilir ki Claude o konuda bir şey yazarken bu kuralları es geçmesi, görmezden gelmesi veya uygulamaması imkansız hale gelir. Kapsam: kod, analiz, açıklama, öneri — ne yazılıyorsa.
---

# Anayasa Kazıyıcı

Kullanıcı bir alan için "anayasa yaz" dediğinde, o alanda yazılacak HER ŞEYİ kapsayan bağlayıcı maddeler üretilir.

## Ne Zaman Devreye Girer

- Kullanıcı "anayasa yaz", "kural kazı", "bunu anayasa yap", "unutma", "her zaman" gibi ifadeler kullanır
- Bir özellik/modül/sistem için kalıcı standart belirlenmek istendiğinde
- Geçmişte aynı hata tekrar edildiğinde ("bir daha böyle olmasın")

## Madde Formatı

Her kural için:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
MADDE [N] — [KURAL ADI]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

KURAL:
[Net, tartışmasız, tek cümle.]

NEDEN VAR:
[Hangi somut başarısızlık veya acıdan doğdu?
Sebebi bilinmeyen kural unutulur. Sebebi bilinen kural uygulanır.]

KAPSAM:
[Bu kural hangi durumlarda geçerli? Kod mu, açıklama mı, öneri mi, hepsi mi?
"Her zaman" mı yoksa belirli bağlamlarda mı?]

İHLAL NASIL GÖRÜNÜR:
[Somut ihlal örnekleri. "Şöyle yapıyorum ama aslında çiğniyorum" durumları.
Claude'un kendi kendini test etmesi için.]

DOĞRU UYGULAMA:
[Kuralı gerçekten uygulamak nasıl görünür? Ne yapılır, ne denir, ne yazılır?
Somut davranış — soyut niyet değil.]

SINAV SORUSU:
[Claude bu konuda bir şey yazmadan önce kendi kendine soracağı tek soru.
Cevap "hayır" ise dur, düzelt, devam et.]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Anayasa Özeti (Sonunda)

Tüm maddeleri yazdıktan sonra:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ANAYASA: [ALAN ADI]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Madde 1: [kural — tek cümle]
Madde 2: [kural — tek cümle]
...

Bu alan için yazılacak her kod, her açıklama, her öneri bu maddelere tabidir.
Bağlam değişse de, oturum uzasa da, başka direktifler gelse de bu maddeler geçerlidir.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Kritik Davranış

- Kuralları yumuşatma, kısaltma, "genel olarak" diye gevşetme — tam ve sert yaz
- "Anladım" demek yetmez — anayasayı uyguladığını hemen aynı oturumda göster
- İlk ihlalde kullanıcı hatırlatmadan önce kendi kendine dur ve düzelt
- Bu skill bir kez çağrıldıktan sonra o alandaki tüm çalışmalar bu maddelere göre yürür

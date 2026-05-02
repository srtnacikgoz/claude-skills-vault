---
name: firebase-deploy
description: Firebase Functions ve Hosting akıllı deploy. Git diff analizi ile sadece değişen fonksiyonları deploy eder (20+ dk yerine 3-5 dk). FUNCTIONS_DISCOVERY_TIMEOUT otomatik ayarlanır. Tetikleyiciler — "deploy", "deploy et", "yayınla", "fonksiyonları deploy et", "hosting deploy", "seed çalıştır", "firebase deploy", "sadece X deploy et".
---

# Firebase Smart Deploy

50+ Cloud Function var. Tümünü deploy etmek 20+ dk. Bu skill sadece değişenleri deploy eder.

## Zorunlu Kurallar

1. **`FUNCTIONS_DISCOVERY_TIMEOUT=120000`** her deploy komutunda (10s default yetmez)
2. **`NODE_OPTIONS='--max-old-space-size=8192'`** tüm fonksiyonlar deploy edilirken
3. Deploy öncesi **build çalıştır** ve başarılı olduğunu doğrula
4. Seed endpoint'leri sadece **yeni koleksiyon** eklendiğinde

## Proje Sabitleri

- Region: `europe-west1`
- URL: `https://europe-west1-instagram-automation-ad77b.cloudfunctions.net/{fnName}`
- Functions: `functions/` — `npm run build` (tsc)
- Admin: `admin/` — `npm run build` (vite)
- Hosting: `admin/dist`

## Karar Ağacı

```
Kullanıcı "deploy" dedi
  ├─ Hangi dosyalar değişti?
  │   ├─ Controller değişti → o controller'ın export'larını deploy et
  │   ├─ Service değişti → o service'i import eden controller'ları bul → export'larını deploy et
  │   ├─ types.ts / index.ts değişti → tüm fonksiyonlar
  │   └─ Sadece admin/ değişti → hosting deploy
  │
  ├─ Kullanıcı belirli fonksiyon adı verdi → doğrudan deploy et
  ├─ "tümünü deploy et" dedi → npm run deploy:quick
  └─ "seed" dedi → seed endpoint'lerini çağır
```

## Deploy Komutları

### Belirli fonksiyonlar (en hızlı, 3-5 dk)
```bash
cd functions && npm run build
FUNCTIONS_DISCOVERY_TIMEOUT=120000 firebase deploy --only functions:fn1,functions:fn2
```

### Tüm fonksiyonlar (20+ dk)
```bash
cd functions
npm run deploy:quick
```

### Hosting
```bash
cd admin && npm run build && firebase deploy --only hosting
```

### Seed (POST zorunlu)
```bash
curl -X POST https://europe-west1-instagram-automation-ad77b.cloudfunctions.net/seedEnhancementPresets
curl -X POST https://europe-west1-instagram-automation-ad77b.cloudfunctions.net/seedEnhancementStyles
curl -X POST https://europe-west1-instagram-automation-ad77b.cloudfunctions.net/seedCategories
```

## Fonksiyon Tespiti

Controller dosyasından export edilen fonksiyonları çıkar:
```bash
grep -E "^export const \w+ = functions" <controller-file>.ts | sed -E 's/export const ([a-zA-Z0-9_]+) = functions.*/\1/'
```

Service değiştiyse bağımlı controller'ları bul:
```bash
grep -rl "enhancementService" functions/src/controllers/orchestrator/*.ts
```

## package.json Kısayolları

| Script | Ne yapar |
|--------|----------|
| `npm run deploy` | Lint + build + tüm fonksiyonlar |
| `npm run deploy:quick` | Build + tüm fonksiyonlar (lint yok) |
| `npm run deploy:enhancement` | Sadece enhancement (14 fonksiyon) |

## Doğrulama

Deploy sonrası en az bir endpoint'i test et:
```bash
curl https://europe-west1-instagram-automation-ad77b.cloudfunctions.net/listEnhancementPresets
```
Beklenen: `{"success":true,"presets":[...],"count":...}`

## Sık Hatalar

- `FUNCTIONS_DISCOVERY_TIMEOUT` unutmak → timeout ile fail
- Build yapmadan deploy → eski kod gider
- Seed'i GET ile çağırmak → 405 hatası
- Tüm fonksiyonları gereksiz deploy → 20+ dk bekleme

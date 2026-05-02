# Plan: Poster Prompt'a Arka Plan Kaldırma Entegrasyonu

## Context

Kullanıcı pastane ürünlerinin (pasta, kruvasan, çikolata, içecek) fotoğraflarını kullanarak poster tasarlıyor. Poster Prompt Üret sayfasında AI'a prompt ürettiğinde, bazen ürünü arka plandan izole etmek istiyor — saydam (transparent) PNG çıktısı için. Kullanıcının hazırladığı profesyonel seviye background removal prompt'u var. Bunu mevcut poster prompt akışına entegre edeceğiz.

Ek ihtiyaç: Bazen ana ürünün yanında bir bardak, aksesuar veya objenin de kalması gerekebilir.

---

## Yaklaşım

PromptGenerator modal'ına (mevcut `includeText` toggle'ı gibi) **bir toggle + koşullu text input** ekleyeceğiz. Backend'de bu aktifken, system prompt'a background removal talimatı enjekte edilecek.

---

## Değişiklikler

### 1. Frontend — PromptGenerator.tsx
**Dosya:** `admin/src/components/poster/PromptGenerator.tsx`

- `removeBackground` (boolean, default: false) ve `keepObjects` (string, default: "") state'leri ekle (satır ~36)
- `includeText` toggle'ından sonra (satır ~196) yeni toggle bloğu:
  - Toggle: "Arka planı kaldır" + alt açıklama: "Ürünü saydam arka plan ile izole et"
  - `removeBackground` true olduğunda altında koşullu text input: "Ürünle birlikte kalacak objeler (opsiyonel)" placeholder: "ör: bardak, peçete, çatal"
- `handleGenerate` API çağrısına (satır ~75-96) `removeBackground` ve `keepObjects` parametrelerini ekle
- Aktif Parametreler özetine (satır ~210-219) "✂️ Arka plan kaldırma aktif" satırı ekle

### 2. Frontend — API Service
**Dosya:** `admin/src/services/api.ts` (~satır 2992)

- `generatePosterPrompt` params tipine `removeBackground?: boolean` ve `keepObjects?: string` ekle

### 3. Backend — posterSmartController.ts
**Dosya:** `functions/src/controllers/orchestrator/posterSmartController.ts`

- Destructure: `removeBackground`, `keepObjects` (satır ~460-468)
- Log'a ekle (satır ~470-482): `arkaplanKaldır: removeBackground, saklananObjeler: keepObjects`
- System prompt'a koşullu blok enjekte et (satır ~607, rules/corrections'dan sonra):

```
BACKGROUND REMOVAL MODE:
{keepObjects varsa: "Isolate the main product along with: {keepObjects}." yoksa: "Isolate ONLY the main product."}
Remove the entire background. Create a perfectly clean transparent background (alpha channel).
Preserve realistic food textures and material quality.
Keep subtle natural contact shadows under the product only.
No floating look, no artificial drop shadow.
Edges must be ultra-clean — no halo, no white edges, no jagged mask.
Maintain color accuracy and lighting direction.
High-resolution PNG with transparent background, editorial quality cutout.
The prompt MUST prominently include these background removal instructions.
```

- `removeBackground` aktifken CRITICAL — PRODUCT REFERENCE RULE bloğunu (satır ~619-624) modifiye et: "Arka plan sahnesi/ortam tarif etme, ürünü izole etmeye odaklan" yönergesi ekle

- Model uyumluluğu: DALL-E transparency desteklemediğinden, `targetModel === "dall-e"` ve `removeBackground` ise "transparent background" yerine "pure white background, seamless, no shadows on background" kullan

---

## Değişmeyecekler

- Firestore koleksiyonu gerekmez — bu sabit bir teknik talimat, kullanıcı seçenek listesi değil (TARGET_MODEL_INSTRUCTIONS gibi)
- Poster.tsx'e dokunulmaz — toggle PromptGenerator modal içinde yaşar
- Mevcut `backgroundId` seçimi ile çakışma: backend `removeBackground: true` ise `backgroundId`'yi yoksayar, log'a uyarı yazar

---

## Doğrulama

1. Admin panelde Poster sayfasına git, ürün fotoğrafı yükle
2. Prompt Generator modal'ını aç → "Arka planı kaldır" toggle'ının göründüğünü doğrula
3. Toggle'ı aç → "Saklanan objeler" input'unun belirdiğini doğrula
4. Her 4 model (DALL-E, Midjourney, Gemini, Flux) için prompt üret → prompt'ta background removal talimatının yer aldığını doğrula
5. DALL-E modeli için "transparent" yerine "pure white background" kullanıldığını kontrol et
6. Toggle kapalıyken prompt'un eski haliyle aynı olduğunu doğrula
7. `npm run build` başarılı olmalı (hem admin hem functions)

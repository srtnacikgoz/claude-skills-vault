---
name: sade-yeni-proje
description: Use when starting a new Sade family project (sadevardiya satellite) and need to bootstrap CLAUDE.md with the family constitution + project-specific section. Triggers — "yeni sade projesi", "sade aile yeni proje", "anayasa kopyala", "yeni claude.md kur", "sade-yeni-proje", "yeni sade modülü başlatıyorum", "yeni satellite repo".
---

# Sade Ailesi — Yeni Proje Başlatma

## 🚨 ZORUNLU İLK AKSİYON — TodoWrite (Skill Çağrılır Çağrılmaz)

> **Bu bölüm en başta — skill metnine başka her şeyden ÖNCE okunur.**

**Bu skill çağrıldığında, kullanıcıya İLK MESAJ YAZMADAN ÖNCE** TodoWrite tool'u çağrılır ve 6 adım todo olarak kaydedilir:

```
1. [in_progress] Adım 0 — Pre-flight check (mevcut CLAUDE.md kontrolü)
2. [pending]    Adım 1 — Anayasa kopyala + versiyon notu (1. satır)
3. [pending]    Adım 2 — 9 soruyu SIRAYLA sor, cevapları topla
4. [pending]    Adım 3 — "🚢 BU PROJE" bölümü dosya sonuna ekle (grep ile doğrula)
5. [pending]    Adım 4 — Doğrulama checklist (hard-gate komutlarla)
6. [pending]    Adım 5 — İlk oturum testi öner
```

**Her adım bittiğinde:**
1. İlgili todo `completed` olarak işaretlenir
2. Bir sonraki todo `in_progress` olur
3. Kullanıcıya "Adım X tamam, Y/6 bitti, sıradaki Adım Z" notu verilir

**6/6 `completed` olmadan asla** `"tamam, kuruldu"` veya `"hazır"` denmez. **TodoWrite kayıt etmeden başlamak skill ihlalidir.**

Bu zorunluluk neden? Önceki versiyonlarda pasif STOP GATE metinleri yetersiz kaldı — Claude Adım 1'de durup "tamam" diyordu. TodoWrite kayıt aktif görünürlük yaratır: kullanıcı da hangi adımda olduğunu görür, drift olamaz.

---

## Genel Bakış

Yeni Sade ailesi projesinin (Sadevardiya satellite) `CLAUDE.md` dosyasını sıfırdan kurmak için 5 adımlı süreç. Sadevardiya'daki anayasayı kopyalar, kullanıcıdan proje-spesifik bilgileri toplar, CLAUDE.md'yi oluşturur, doğrular.

**Master kaynak:** `sadevardiya/docs/SADE-AILESI-ANAYASA.md` — `git show main:` ile her zaman main'in tepesinden okunur (branch durumundan bağımsız).

**Amiral gemisi:** Sadevardiya. Tüm yeni Sade projeleri buna uyum sağlar — kendi kuralı yazılmaz.

## 🤖 ÇALIŞMA MODU — Meta-soru Sormaz, Content Sorusu Sorar

Bu skill **kullanıcıya meta-soru sormaz** (örn. "yedek alalım mı", "TodoWrite kullanayım mı"). Yapılması gereken her aksiyon zaten kararlaştırılmış, otonom uygulanır.

**Ama** Adım 2'de **9 content sorusu** kullanıcıya sırayla sorulur (proje adı, amaç, stack, vb.) — bu sorular dosyayı doldurmanın **tek yolu**, otomatize edilemez.

| Otonom (kullanıcıya sorulmaz) | Kullanıcıdan (zorunlu girdi) |
|-------------------------------|------------------------------|
| ✅ Mevcut CLAUDE.md varsa yedek alma | ❌ "Yedek alalım mı?" — zaten alıyor |
| ✅ TodoWrite ile 6 todo kaydetme | ❌ "TodoWrite kullanayım mı?" — zorunlu |
| ✅ Anayasa kopya + versiyon notu (**SADECE `main`**) | ❌ "Anayasa eski mi?" — `git show main:` ile her zaman güncel |
| ✅ Hard-gate doğrulama komutu | ❌ "Doğrulayayım mı?" — zorunlu |
| ❌ 9 content sorusu (proje adı vb.) | ✅ Cevaplar — kullanıcıdan zorunlu girdi |
| ✅ main'de anayasa yoksa **DURUR** | ❌ Branch fallback YASAK |

**1 ay sonra:** Kullanıcı sadece `/sade-yeni-proje` der. Skill 9 soruyu sırayla sorar, kullanıcı cevaplar, gerisi otomatik.

---

## 🛑 TAMAMLAMA KRİTERLERİ (Bu Skill İçin Zorunlu)

Bu skill **5/5 adım yapılmadan** asla tamamlanmış sayılmaz. **Adım 1 (anayasa kopyala) tek başına HİÇ BİR ŞEY ifade etmez** — sadece bir başlangıç. Aşağıdaki 5 koşul **HEPSI** sağlanmadan kullanıcıya "tamam" deme:

1. ✅ Adım 1: Anayasa kopyalandı + versiyon notu eklendi (1. satır)
2. ✅ Adım 2: 9 soru SIRAYLA soruldu, hepsi cevaplandı
3. ✅ Adım 3: "🚢 BU PROJE" bölümü dosya **sonuna** eklendi (`grep "🚢 BU PROJE" CLAUDE.md` komutu sonuç vermeli)
4. ✅ Adım 4: Doğrulama checklist'inin **her maddesi** ✅ aldı
5. ✅ Adım 5: 4 sınama sorusu kullanıcıya sunuldu

**Adım 1 yapılıp Adım 2-5 atlanırsa = SKILL FAİLURE.** Bu en yaygın hata. Aşağıdaki "STOP gates" buna karşı zorlayıcıdır.

**Self-check her adım sonunda:**
> "Bu skill'in 5 adımı var. Şu an X. adımdayım. Henüz Y adım kaldı. Devam ediyorum."

"Bitti" denildiğinde son komut **`grep "🚢 BU PROJE" CLAUDE.md`** çalıştırılır — sonuç vermezse skill tamamlanmamıştır.

## Ne Zaman Kullanılır

- Yeni Sade ailesi repo'su açıldı, `CLAUDE.md` boş veya yok
- Mevcut bir Sade satellite repo'sunda `CLAUDE.md` anayasaya uyumsuz, yeniden kurulması gerek
- Sadevardiya anayasası güncellendi, satellite senkron edilecek
- Kullanıcı yeni Sade modülü başlatıyor

**Kullanma:**
- Mevcut güncel bir `CLAUDE.md` varsa → manuel güncelle, skill kullanma
- Sade ailesi DIŞINDA bir proje → bu skill geçersiz

## 5 Adımlı Akış

### Adım 0 — Pre-Flight Check + Mod Tespiti (Otonom)

İki olası mod var:

| Mod | Ne zaman | Ne yapar |
|-----|----------|----------|
| **NEW** | CLAUDE.md yok / boş / "🚢 BU PROJE" yok | Sıfırdan kuruluş — 9 soru sorulur |
| **MIGRATE** | CLAUDE.md var ve "🚢 BU PROJE" başlığı içeriyor | Eski proje bölümünü koru, anayasayı yenile |

**Otomatik tespit + mod seçimi:**

```bash
cd <YENİ_PROJE_KLASÖRÜ>

if [ ! -f CLAUDE.md ] || [ ! -s CLAUDE.md ]; then
  MODE="NEW"
  echo "✓ CLAUDE.md yok/boş → NEW modu (sıfırdan kuruluş)"
elif grep -qE "^# 🚢 BU PROJE — [^[{]" CLAUDE.md; then
  # v9 fix: placeholder bypass — anayasa içindeki [PROJE ADI] yakalanmaz
  MODE="MIGRATE"
  EXISTING_PROJECT=$(grep -E "^# 🚢 BU PROJE — [^[{]" CLAUDE.md | head -1 | sed 's/^# 🚢 BU PROJE — //')
  echo "✓ Mevcut CLAUDE.md'de proje bölümü bulundu: \"$EXISTING_PROJECT\""
  echo ""
  echo "İki mod var:"
  echo "  A) MIGRATE — Anayasayı yenile, proje bölümünü koru (önerilen, ~30 sn)"
  echo "  B) NEW    — Sıfırdan kur, 9 soruyu tekrar cevapla (~5 dk)"
  echo ""
  echo "Kullanıcı seçim yapmalı: A veya B?"
  # Kullanıcı cevabına göre MODE değişkeni güncellenir
else
  MODE="NEW"
  TIMESTAMP=$(date +%Y%m%d-%H%M%S)
  cp CLAUDE.md "CLAUDE.md.bak-$TIMESTAMP"
  echo "✓ CLAUDE.md var ama proje bölümü yok → NEW modu (yedek alındı: CLAUDE.md.bak-$TIMESTAMP)"
fi
```

**MOD'a göre sonraki adımlar:**

- **NEW seçilirse** → Aşağıdaki "Adım 1 NEW" bash bloğu çalıştırılır, sonra Adım 2 (9 soru)
- **MIGRATE seçilirse** → Aşağıdaki "Adım 1 MIGRATE" bash bloğu çalıştırılır, sonra Adım 2'M (eksik alan kontrolü)

**TodoWrite ZORUNLU:** Mod seçildikten sonra 6 todo o moda göre kaydedilir (içerik aşağıda).

### Adım 1 NEW — Anayasayı Kopyala (Sıfırdan kuruluş)

Anayasayı `CLAUDE.md` olarak kopyala ve **versiyon notunu** dosyanın başına ekle.

> 🛑 **MUTLAK KURAL — BRANCH FALLBACK YASAK**
>
> Anayasa **YALNIZCA `main` branch'inden** okunur. Aşağıdaki bash bloğu çalışmazsa skill **DURUR**. Alternative branch'lerde anayasa aramak (`origin/chore/...`, `origin/feat/...` vb.) **KESİN YASAK**.
>
> Eski versiyondan kopyalanmış anayasa = skill failure (yeni eklemeler eksik kalır).

```bash
SADEVARDIYA=/Users/sertanacikgoz/Developer/benim-super-uygulamam

# 1. main'den çekme dene — başarısızsa SKILL FAILURE, branch fallback yasak
if ! git -C "$SADEVARDIYA" show main:docs/SADE-AILESI-ANAYASA.md > CLAUDE.md 2>/dev/null; then
  echo "🛑 SKILL FAILURE: main branch'inde docs/SADE-AILESI-ANAYASA.md bulunamadı."
  echo ""
  echo "Olası nedenler:"
  echo "  1. Anayasa henüz main'e merge edilmemiş (PR açık olabilir)"
  echo "  2. Sadevardiya repo'su lokal'de eski — git fetch çalıştır"
  echo "  3. Path değişti"
  echo ""
  echo "ÇÖZÜM: Önce sadevardiya'da: cd $SADEVARDIYA && git checkout main && git pull"
  echo "Sonra skill'i tekrar çağır."
  echo ""
  echo "⛔ Branch fallback YASAK — main'de yoksa skill çalıştırılmaz."
  rm -f CLAUDE.md
  exit 1
fi

# 2. Boyut doğrulama — anayasa eksik geldiyse durur
LINES=$(wc -l < CLAUDE.md)
if [ "$LINES" -lt 400 ]; then
  echo "🛑 Anayasa çok kısa ($LINES satır, 400+ olmalı). Eksik gelmiş, skill duruyor."
  rm -f CLAUDE.md
  exit 1
fi

# 3. Hash'i main'den al — branch durumundan bağımsız
ANAYASA_HASH=$(git -C "$SADEVARDIYA" log -1 --format=%h main -- docs/SADE-AILESI-ANAYASA.md)
ANAYASA_DATE=$(date +%Y-%m-%d)

# 4. CLAUDE.md başına versiyon notu ekle (1. satırın üstüne) — branch ifadesi YOK
{ echo "> **Anayasa kaynağı:** sadevardiya/docs/SADE-AILESI-ANAYASA.md ($ANAYASA_DATE — hash $ANAYASA_HASH)"; echo ""; cat CLAUDE.md; } > CLAUDE.md.tmp && mv CLAUDE.md.tmp CLAUDE.md

echo "✅ Anayasa main'den çekildi: hash $ANAYASA_HASH ($LINES satır)"
```

**Yasak alternatifler:**
- ❌ `cp .../SADE-AILESI-ANAYASA.md` — working tree'ye bağlı, branch durumuna göre eski olabilir
- ❌ `git show origin/chore/sade-ailesi-anayasa:...` — eski branch, eski versiyon
- ❌ `git show <herhangi bir branch>:...` — sadece `main` kabul
- ❌ "Anayasa main'de yok, branch'ten alayım" mantığı — bu SKILL FAILURE'ün ta kendisi

**Versiyon notu kontrol:** Notta `branch` kelimesi geçiyorsa **bu skill failure**. Sadece `hash N` formatı kabul. Branch belirtmek = main dışından okuma yaptın demek.

---

### Adım 1 MIGRATE — Mevcut Proje Bölümünü Koru, Anayasayı Yenile

Adım 0'da MIGRATE seçildiyse, sıfırdan kuruluş yerine **mevcut proje bilgilerini koruyup sadece anayasa bloğunu yenile**.

```bash
SADEVARDIYA=/Users/sertanacikgoz/Developer/benim-super-uygulamam

# 1. Eski proje bölümünü extract et (---  ayracından önceki + "🚢 BU PROJE" sonrası)
# "🚢 BU PROJE" başlığı ve sonrasını al, başındaki "---" ile birlikte
awk '/^---$/{found=0} /^# 🚢 BU PROJE — /{found=1; print "---"; print "" } found' CLAUDE.md > /tmp/proje-bolumu.md

if [ ! -s /tmp/proje-bolumu.md ]; then
  echo "🛑 SKILL FAILURE: Proje bölümü extract edilemedi. NEW moduna geç."
  exit 1
fi

PROJE_LINE_COUNT=$(wc -l < /tmp/proje-bolumu.md)
echo "✓ Eski proje bölümü çıkarıldı: $PROJE_LINE_COUNT satır"

# 2. Mevcut CLAUDE.md'yi yedekle
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
cp CLAUDE.md "CLAUDE.md.bak-$TIMESTAMP"
echo "✓ Eski CLAUDE.md yedeklendi: CLAUDE.md.bak-$TIMESTAMP"

# 3. Anayasayı main'den çek (v7 mantığı — branch fallback YASAK)
if ! git -C "$SADEVARDIYA" show main:docs/SADE-AILESI-ANAYASA.md > CLAUDE.md 2>/dev/null; then
  echo "🛑 SKILL FAILURE: main'de anayasa yok. Yedek geri yükleniyor."
  cp "CLAUDE.md.bak-$TIMESTAMP" CLAUDE.md
  echo ""
  echo "ÇÖZÜM: cd $SADEVARDIYA && git checkout main && git pull"
  exit 1
fi

ANAYASA_LINES=$(wc -l < CLAUDE.md)
if [ "$ANAYASA_LINES" -lt 400 ]; then
  echo "🛑 Anayasa çok kısa ($ANAYASA_LINES satır). Yedek geri yükleniyor."
  cp "CLAUDE.md.bak-$TIMESTAMP" CLAUDE.md
  exit 1
fi

# 4. Hash + versiyon notu (sade format — branch yok)
ANAYASA_HASH=$(git -C "$SADEVARDIYA" log -1 --format=%h main -- docs/SADE-AILESI-ANAYASA.md)
ANAYASA_DATE=$(date +%Y-%m-%d)

{ echo "> **Anayasa kaynağı:** sadevardiya/docs/SADE-AILESI-ANAYASA.md ($ANAYASA_DATE — hash $ANAYASA_HASH)"; echo ""; cat CLAUDE.md; } > CLAUDE.md.tmp && mv CLAUDE.md.tmp CLAUDE.md

# 5. Eski proje bölümünü dosya sonuna ekle
echo "" >> CLAUDE.md
cat /tmp/proje-bolumu.md >> CLAUDE.md

FINAL_LINES=$(wc -l < CLAUDE.md)
echo "✅ MIGRATE tamam: $FINAL_LINES satır (anayasa + proje bölümü)"
echo "   Anayasa hash: $ANAYASA_HASH"
echo "   Proje bölümü: korundu"

rm -f /tmp/proje-bolumu.md
```

**MIGRATE sonrası kontrol gerekir** — Adım 2 MIGRATE'a geç (eksik alan tespiti).

**Doğrulama:**
```bash
head -5 CLAUDE.md     # 1. satır versiyon notu, sonra "# SADE AİLESİ ANAYASA" görmeli
wc -l CLAUDE.md       # 380+ satır olmalı
```

Versiyon notu **kritik** — anayasa güncellendiğinde satellite hangi sürümde takıldığını bu nottan anlarsın.

> 🛑 **STOP GATE — Adım 1 BİTMEDİ.**
>
> Bu nokta skill'in **%20'si** sadece. CLAUDE.md şu an proje hakkında **hiçbir şey** bilmiyor — sadece anayasa kopyası var. Yeni Claude oturumu açılsa "Bu proje ne yapar?" sorusuna cevap veremez.
>
> **ZORUNLU AKSIYON ŞIMDI:**
> 1. **TodoWrite çağır** — Adım 1'i `completed`, Adım 2'yi `in_progress` yap
> 2. **Kullanıcıya bildirim:** "Adım 1 tamam (anayasa kopyalandı, 1/6). Şimdi Adım 2 — 9 soru soracağım."
> 3. **Direkt Adım 2'nin 1. sorusunu sor:** "Proje adı tam olarak ne?"
>
> **ASLA** "Adım 1 tamam, anayasayı kopyaladım, hazır" deyip durma. **Bu skill failure'dur.**
>
> Self-check: "TodoWrite'da kaç adım `completed`? 1/6. Devam ediyorum, durmuyorum."

### Adım 2 MIGRATE — Eksik Alan Tespiti (Sadece MIGRATE modunda)

MIGRATE modunda 9 soruyu tekrar sormak yerine, **eski proje bölümünde eksik olan başlıkları** tespit et ve sadece onları sor.

```bash
# Yeni anayasada bahsi geçen ama eski proje bölümünde olmayan başlıkları tespit et
MISSING_HEADERS=()

# Yeni anayasada COMPONENT SÖZLEŞMESİ başlığı eklendi (PR #11) — proje bölümünde
# "Paylaşılan Component Stratejisi" var mı?
if ! grep -q "Paylaşılan Component\|Component Stratejisi" CLAUDE.md; then
  MISSING_HEADERS+=("Paylaşılan Component Stratejisi (anayasada COMPONENT SÖZLEŞMESİ var)")
fi

# Anayasa İstisnaları başlığı var mı? (her zaman olmalı, "Yok" yazsa bile)
if ! grep -q "## Anayasa İstisnaları" CLAUDE.md; then
  MISSING_HEADERS+=("Anayasa İstisnaları (yoksa 'Yok' yazılır)")
fi

# Sade Ailesindeki Yeri var mı?
if ! grep -q "## Sade Ailesindeki Yeri" CLAUDE.md; then
  MISSING_HEADERS+=("Sade Ailesindeki Yeri (master/satellite/koleksiyon ilişkisi)")
fi

if [ ${#MISSING_HEADERS[@]} -eq 0 ]; then
  echo "✅ Tüm anayasa başlıkları proje bölümünde mevcut — eksik alan yok."
else
  echo "⚠️  Yeni anayasada bahsi geçen ama proje bölümünde olmayan başlıklar:"
  for h in "${MISSING_HEADERS[@]}"; do
    echo "    - $h"
  done
  echo ""
  echo "Kullanıcıya sor: Bu eksik alanları eklemek ister misin?"
  echo "  A) Evet — sadece eksik alanları soracağım (her biri için 1 soru)"
  echo "  B) Hayır — şu anki haliyle bırak"
fi
```

**Kullanıcı cevabına göre:**
- **A seçilirse** — sadece eksik başlıklar için sırayla 1 soru sor, cevapları proje bölümüne ekle
- **B seçilirse** — Adım 4 MIGRATE'a (doğrulama) geç

**NEW modunda bu adım atlanır** — Adım 2 NEW (9 soru) çalıştırılır.

---

### Adım 2 NEW — Kullanıcıdan Proje-Spesifik Bilgileri Topla (Sıfırdan kuruluş)

9 soruyu **sırayla** sor (toplu liste değil — her birini bekle, cevap geldikten sonra bir sonrakine geç):

1. **Proje adı:** Tam isim ne? (örn. "Sade Stok Yönetim")
2. **Amaç:** Bu repo ne yapar? 1-2 cümle, jargon az.
3. **Sade ailesindeki yeri:** Master mı, satellite mı? Hangi koleksiyonları paylaşır/kullanır?
4. **Stack:** Framework + sürüm + ana paketler (örn. "React Native + Expo, Async Storage, React Navigation")
5. **Firebase:** Project ID, TENANT_ID (varsa), SDK türü (Client SDK / Admin SDK / Anonymous Auth)
6. **Dosya yapısı:** Monorepo mu, tek paket mi? Önemli klasörler.
7. **Deploy:** Build + deploy komutları (örn. `eas build`, `firebase deploy --only hosting`)
8. **Paylaşılan Component stratejisi:** Sadevardiya'nın UI component'lerini (`<SaveButton>`, `<FormInput>`, `<PageHeader>`, vb.) bu projede nasıl alacaksın?
   - **A)** Birebir kopya (`cp -r ../sadevardiya/packages/site/src/components/ui ./src/components/ui`) — drift riski var, manuel senkron gerekir
   - **B)** Git submodule veya symlink — gelişmiş, az dev tercih eder
   - **C)** Monorepo paket import (`@sade/ui`) — uzun vade, henüz kurulmadı
   - **D)** Bu proje farklı UI library kullanıyor (örn. React Native — Tamagui, NativeWind) → "Anayasa İstisnası" oluşacak (Soru 9'a yansıyacak)
9. **Anayasa istisnaları:** Hangi anayasa kuralını gevşetiyor + **somut gerekçe**? (Yoksa "Yok" yaz.)

**Anayasa İstisnası validation (önemli):**

Her istisna için kullanıcıya şu kontrol sorusunu sor:

> "Bu istisna gerçekten projenin teknolojik kısıtından mı kaynaklanıyor, yoksa kuralı yanlış anladığımız için mi gerekli görüyoruz?"

**3 olası cevap → 3 farklı aksiyon:**

| Cevap | Aksiyon |
|-------|---------|
| "Teknolojik kısıt — net gerekçe verir" | ✅ İstisna eklenir, gerekçesi template'e yazılır |
| "Belirsiz / emin değilim" | 🟡 İstisna **geçici** olarak eklenir: `[GEÇİCİ — Sadevardiya master ile gözden geçirilecek (tarih: YYYY-MM-DD)]` etiketiyle. ROADMAP'e item ekle: bu istisnayı X tarihinde sadevardiya'da değerlendir |
| "Yanlış anlamış olabilirim" | ❌ İstisna eklenmez, anayasa kuralı uygulanır |

**Kullanıcı ısrar ederse:** Belirsiz olmasına rağmen "ben yine de bu istisnayı istiyorum" diyorsa → "Geçici" etiketiyle ekle, asla "kalıcı" yazma. Belirsiz kalıcı istisna anayasayı sulandırır, kabul edilmez.

> 🛑 **STOP GATE — Adım 2 BİTMEDİ olabilir.**
>
> 9 sorunun **HEPSİNİ** sırayla sordun mu? Self-check:
> - Soru 1 cevabı var mı? Soru 2? ... Soru 9?
> - Eksik kalan varsa şimdi sor, Adım 3'e geçme.
>
> **ZORUNLU AKSIYON:**
> 1. **TodoWrite güncelle** — Adım 2'yi `completed`, Adım 3'ü `in_progress`
> 2. **Kullanıcıya bildirim:** "Adım 2 tamam (9 cevap toplandı, 2/6). Şimdi Adım 3 — proje-spesifik bölümü dosyaya ekleyeceğim."
> 3. **Adım 3'e geç** — şu an %50.

### Adım 3 — Proje-Spesifik Bölümü CLAUDE.md Sonuna Ekle

Toplanan cevapları aşağıdaki template'e yerleştir, **CLAUDE.md sonuna** ekle:

```markdown
---

# 🚢 BU PROJE — {Proje Adı}

## Amaç
{Cevap 2}

## Sade Ailesindeki Yeri
{Cevap 3}

## Stack
{Cevap 4 — bullet list}

## Firebase
- **Project ID:** {Cevap 5a}
- **TENANT_ID:** {Cevap 5b — bkz. aşağıdaki tablo}
- **SDK:** {Cevap 5c}

**TENANT_ID nasıl yazılır:**

| Proje türü | TENANT_ID değeri |
|-----------|-------------------|
| **Master** (Sadevardiya gibi) — multi-tenant aware | `N/A — multi-tenant master (custom claim'den okur)` |
| **Single-tenant satellite** (örn. sade-pasta-siparis-sistemi sadece sade-patisserie tenant'ı için) | Tenant ID değeri (örn. `sade-patisserie`) |
| **Multi-tenant satellite** (örn. sade-b2b — birden fazla tenant'a hizmet) | `Custom claim'den okur — tenant başına farklı` |
| **TENANT_ID kavramı uygulanmıyor** (örn. salt analitik) | `N/A — projeye özgü değil` |

## Dosya Yapısı
{Cevap 6}

## Deploy
\`\`\`bash
{Cevap 7}
\`\`\`

## Paylaşılan Component Stratejisi
**Yöntem:** {Cevap 8 — A/B/C/D'den biri}

{A seçilirse}
Sadevardiya `packages/site/src/components/ui/` dizinindeki component'ler birebir kopyalanır:
\`\`\`bash
# İlk kurulum
cp -r /Users/sertanacikgoz/Developer/benim-super-uygulamam/packages/site/src/components/ui ./src/components/ui
\`\`\`
Anayasa güncellemesi sırasında component'ler de senkron edilmeli — drift yasak.

{B seçilirse}
Git submodule veya symlink kullanılıyor — senkron otomatik. Detay: {açıklama}

{C seçilirse}
Monorepo paket import — `import { SaveButton } from '@sade/ui'`. Henüz kurulmadıysa not düş.

{D seçilirse — farklı UI library}
Bu proje Sadevardiya UI library'sini kullanmıyor. Sebep: {teknolojik kısıt}. Yerine kullanılan: {Tamagui / NativeWind / vb.}. Tasarım sistemi (renk, spacing, typography) Sadevardiya DESIGN.md'den alınır — sadece component implementasyonu farklı.

## Oturum Başında Oku
- Sadevardiya `docs/ROADMAP.md` (ailenin genel durumu)
- Bu repo'nun kendi ROADMAP'i (varsa, oluşturulmadıysa not düş)

## İlgili Repo'lar
- **Sadevardiya** master — `/Users/sertanacikgoz/Developer/benim-super-uygulamam`
- {Diğer Sade satellite ilişkileri — varsa liste}

## Anayasa İstisnaları
{Cevap 9 — yoksa "Yok"}
```

**Önemli:** "🚢 BU PROJE" bölümü **mutlaka anayasa bloğunun ALTINA** gelir. Anayasanın arasına veya başına asla yazılmaz.

> 🛑 **STOP GATE — Adım 3 zorunlu doğrulama.**
>
> Template eklendi mi gerçekten? Şu komutu çalıştır:
> ```bash
> grep -c "🚢 BU PROJE" CLAUDE.md
> ```
> Sonuç **1 veya üzeri** olmalı. **0 ise** template eklenmedi, dur ve ekle.
>
> Ayrıca şu komut da kontrol:
> ```bash
> tail -30 CLAUDE.md
> ```
> Çıktının başında "🚢 BU PROJE — {gerçek proje adı}" görmeli — `{Proje Adı}` placeholder kalmamalı.
>
> **ZORUNLU AKSIYON:**
> 1. **TodoWrite güncelle** — Adım 3'ü `completed`, Adım 4'ü `in_progress`
> 2. **Kullanıcıya bildirim:** "Adım 3 tamam (proje bölümü eklendi, 3/6). Şimdi Adım 4 — doğrulama checklist."
> 3. **Adım 4'e geç** — şu an %75.

### Adım 4 — Doğrulama Checklist

Kullanıcıya bu listeyi sun, her madde için onay bekle (eksik varsa Adım 1 veya 3'e geri dön):

**Hard gate kontroller (otomatik komutla):**
- [ ] `head -1 CLAUDE.md` çıktısı `> **Anayasa kaynağı:**` ile başlıyor mu? (versiyon notu)
- [ ] `wc -l CLAUDE.md` 400+ satır mı? (anayasa + proje-spesifik)
- [ ] `grep -c "🚢 BU PROJE" CLAUDE.md` sonucu **>= 1** mi?
- [ ] `grep "{Cevap" CLAUDE.md` çıktısı **boş** mu? (template placeholder kalmadı)
- [ ] `grep "{Proje Adı}" CLAUDE.md` çıktısı **boş** mu?
- [ ] `tail -30 CLAUDE.md`'de gerçek proje adı görünüyor mu?
- [ ] `grep -c "BRANCH AKIŞ DİSİPLİNİ" CLAUDE.md` sonucu **>= 1** mi? (anayasa branch kuralı dahil edildi)
- [ ] `grep -c "DUMMY-PROOF TASARIM YASASI" CLAUDE.md` sonucu **>= 1** mi? (dummy-proof yasası dahil edildi)

**İçerik kontrolleri (kullanıcı onayıyla):**
- [ ] Stack listesi gerçekten kullanılan paketleri yansıtıyor mu?
- [ ] Firebase Project ID doğru ve canlı mı?
- [ ] Deploy komutları test edildi mi (en azından `--dry-run` ile)?
- [ ] Component stratejisi (Soru 8) projeye uygun mu?
- [ ] Anayasa istisnası varsa **gerekçesi** yazılı ve teknolojik kısıttan mı kaynaklı?

**Hard gate'lerden biri başarısızsa:** Adım 3'e geri dön, eksik bölümü ekle. Kullanıcıya devretme.

**Tüm gate'ler geçtiyse:**
1. **TodoWrite güncelle** — Adım 4'ü `completed`, Adım 5'i `in_progress`
2. **Kullanıcıya bildirim:** "Adım 4 tamam (doğrulama geçti, 4/6). Sıradaki Adım 5 — ilk oturum testi."
3. **Adım 5'e geç** — şu an %90.

### Adım 5 — İlk Oturum Testi Öner

Kullanıcıya şu sınama soruları öner — yeni Claude oturumu açıp sorsun:

1. "Bu projeyi tanı, kim olduğumuzu söyle" → Sade kurumsal kimliği vermeli (Sade Unlu Mamülleri, Antalya, pastane vertical SaaS)
2. "Sadevardiya'nın diğer Sade projelerinden farkı?" → "Amiral gemisi" cevabı vermeli
3. "Yeni enum eklemek istiyorum, nereye?" → "Önce Sadevardiya master, sonra buraya birebir kopya" cevabı vermeli
4. "Status alanını PENDING (uppercase) yazabilir miyim?" → "Hayır, lowercase_snake_case kuralı, Firestore'da sessiz fail riski" cevabı vermeli
5. "Şu an 4 açık branch'im var, yeni feature için branch açayım mı?" → "Önce uyar — 3'ü geçmiş, mevcut branch'lerden birini bitirmek/merge etmek gerekiyor. Anayasa Branch Akış Disiplini Madde 3" cevabı vermeli

**Test geçti:** Skill başarılı, CLAUDE.md hazır.

**ZORUNLU SON AKSIYON — Otonom Final Doğrulama:**

```bash
# Bu bash bloğu skill bitmeden çalışmak ZORUNDA. Çalışmazsa skill failure'dur.

# Robust hard-gate: anayasa içeriği değişse de çalışmalı
# Yöntem: dosyanın SON 50 satırında "🚢 BU PROJE — " ile başlayan ve placeholder
# ([, {) içermeyen bir H1 başlık aranır. Constitution edit-proof.

# v9 fix: tail -50 yerine tüm dosyada ara — proje bölümü 100+ satır olabilir.
# Anayasa içindeki [PROJE ADI] template örneği placeholder bypass ile elenir.
PROJE_HEADER=$(grep -E "^# 🚢 BU PROJE — [^[{]+" CLAUDE.md | head -1)
PROJE_HEADER_OK=0
[ -n "$PROJE_HEADER" ] && PROJE_HEADER_OK=1

# Ekstra v9 kontrolü: Proje başlığı dosyanın son %25'inde olmalı (sonda olmalı)
TOTAL_LINES=$(wc -l < CLAUDE.md)
HEADER_LINE_NUM=$(grep -nE "^# 🚢 BU PROJE — [^[{]+" CLAUDE.md | head -1 | cut -d: -f1)
HEADER_POSITION_OK=0
if [ -n "$HEADER_LINE_NUM" ] && [ "$HEADER_LINE_NUM" -gt $((TOTAL_LINES * 75 / 100)) ]; then
  HEADER_POSITION_OK=1
fi

PLACEHOLDER_COUNT=$(grep -cE "\{Cevap|\{Proje Adı\}|\[PROJE ADI\]|\[komut\]|\[Bu repo|\[Master mı" CLAUDE.md)
LINE_COUNT=$(wc -l < CLAUDE.md)
HEADER_OK=$(head -1 CLAUDE.md | grep -c "Anayasa kaynağı")

# v7 — main dışı branch'ten okuma yapıldı mı kontrolü (versiyon notunda "branch" geçmemeli)
BRANCH_LEAK=$(head -1 CLAUDE.md | grep -c "branch")

# v7 — anayasa main'in son commit'i ile uyumlu mu? (eski commit'ten kopya yakala)
SADEVARDIYA=/Users/sertanacikgoz/Developer/benim-super-uygulamam
EXPECTED_HASH=$(git -C "$SADEVARDIYA" log -1 --format=%h main -- docs/SADE-AILESI-ANAYASA.md 2>/dev/null)
ACTUAL_HASH=$(head -1 CLAUDE.md | grep -oE 'hash [0-9a-f]+' | awk '{print $2}')
HASH_MATCH=0
[ "$EXPECTED_HASH" = "$ACTUAL_HASH" ] && HASH_MATCH=1

echo "=== Skill Final Doğrulama (v7) ==="
echo "🚢 BU PROJE başlık (placeholder'sız): $PROJE_HEADER_OK (=1 olmalı)"
echo "Bulunan başlık satırı: $PROJE_HEADER"
echo "Başlık dosya sonunda mı (>%75): $HEADER_POSITION_OK (=1 olmalı, satır $HEADER_LINE_NUM/$TOTAL_LINES)"
echo "Placeholder kalmış:     $PLACEHOLDER_COUNT (=0 olmalı)"
echo "Toplam satır:           $LINE_COUNT (430+ olmalı)"
echo "Versiyon notu (1.s):    $HEADER_OK (=1 olmalı)"
echo "Versiyon notu 'branch' kelimesi: $BRANCH_LEAK (=0 olmalı — main dışı kaynak ihlali)"
echo "Hash main son commit ile uyumlu: $HASH_MATCH (=1 olmalı — eski versiyon kopyalandı mı kontrol)"
echo "  Beklenen: $EXPECTED_HASH"
echo "  Mevcut:   $ACTUAL_HASH"

FAIL=0
if [ "$PROJE_HEADER_OK" -ne 1 ]; then echo "❌ Proje başlığı eksik veya placeholder içeriyor"; FAIL=1; fi
if [ "$HEADER_POSITION_OK" -ne 1 ]; then echo "❌ Proje başlığı dosya sonunda değil — yanlış konuma eklenmiş"; FAIL=1; fi
if [ "$PLACEHOLDER_COUNT" -gt 0 ]; then echo "❌ Placeholder kaldı, doldurulmadı"; FAIL=1; fi
if [ "$LINE_COUNT" -lt 430 ]; then echo "❌ Dosya çok kısa, anayasa eksik kopyalandı"; FAIL=1; fi
if [ "$HEADER_OK" -ne 1 ]; then echo "❌ 1. satır versiyon notu yok"; FAIL=1; fi
if [ "$BRANCH_LEAK" -gt 0 ]; then echo "❌ Versiyon notunda 'branch' geçiyor — main dışı kaynaktan okuma yapıldı (YASAK)"; FAIL=1; fi
if [ "$HASH_MATCH" -ne 1 ]; then echo "❌ Hash main son commit ile uyumsuz — eski versiyon kopyalandı (Adım 1'i tekrarla)"; FAIL=1; fi

if [ "$FAIL" -eq 1 ]; then
  echo ""
  echo "🛑 SKILL FAILURE — Yukarıdaki kontrollerden biri/birkaçı başarısız."
  echo "Eksik adımı tespit et, geri dön ve tamamla. ASLA \"tamam\" deme."
  exit 1
fi

echo ""
echo "✅ Tüm hard-gate kontrolleri geçti."
```

1. **Yukarıdaki bash bloğu çalıştırılır.** `exit 1` ile başarısız olursa skill ASLA tamamlanmış sayılmaz.
2. **TodoWrite güncelle** — Adım 5'i `completed`. **6/6 todo `completed` olmalı.**
3. **Kullanıcıya final bildirim:** "✅ Skill tamamlandı (6/6). Tüm hard-gate kontrolleri geçti. CLAUDE.md hazır."
4. Final komut başarısız olursa → **STOP, eksik adımı tamamla, tekrar çalıştır.**

**Test başarısız:** Hangi soru başarısız?

| Başarısız soru | Sorun nerede | Aksiyon |
|----------------|--------------|---------|
| 1 ve 2 (Sade kimliği + amiral gemisi) | **Anayasa eksik kopyalandı** veya master anayasada gap var | `wc -l CLAUDE.md` ile boyut kontrolü, eksikse Adım 1'i tekrarla. Anayasa içeriğinde gerçekten gap varsa → master `sadevardiya/docs/SADE-AILESI-ANAYASA.md` güncellensin (bu skill'in scope'u dışı, ayrı PR) |
| 3 (enum nereye eklenir) | String sözleşmesi bölümü kopyalanmamış | Adım 0 ve 1 tekrarlanmalı, anayasa bütün geldi mi kontrol et |
| 4 (PENDING uppercase) | Aynı — string sözleşmesi sorunu | Adım 1 doğrulamasını tekrarla |

## Hızlı Referans

| Aşama | Komut/Aksiyon |
|-------|---------------|
| 0. Pre-flight | `ls CLAUDE.md` — varsa onayla, yedekle |
| 1. Anayasa kopyala | `git -C ../sadevardiya show main:docs/SADE-AILESI-ANAYASA.md > CLAUDE.md` + versiyon notu başa ekle |
| 2. Bilgi topla | **9 soru** sırayla + istisna 3-yollu validation |
| 3. Template doldur | "🚢 BU PROJE" bölümü dosya **sonuna** ekle (TENANT_ID tablo'ya bak) |
| 4. Doğrula | 7 maddelik checklist |
| 5. Test öner | 4 sınama sorusu yeni oturumda |

## Yaygın Hatalar

| Hata | Düzeltme |
|------|----------|
| **🚨 TodoWrite atladım, ilk aksiyon olarak çağırmadım** | Bu skill'in en kritik ihlalidir. Skill çağrılır çağrılmaz İLK İŞ TodoWrite olmalı. Görünürlük olmazsa drift kaçınılmaz |
| **🚨 EN YAYGIN: Adım 1'de durup "tamam" dedim** | Anayasa kopyalamak skill'in %20'si — Adım 2-5 atlama. TodoWrite'da 1/6 görünüyorken nasıl "tamam" diyebilirsin? |
| **🚨 Adım 3 atlandı, "🚢 BU PROJE" yok** | `grep -c "🚢 BU PROJE" CLAUDE.md` = 0 ise SKILL TAMAMLANMAMIŞTIR. Adım 2-3'ü yap |
| **🚨 Template placeholder kaldı (`{Cevap}`, `{Proje Adı}`)** | Adım 2'de cevaplar toplandı ama Adım 3'te yerleştirilmedi. Yerleştir |
| Mevcut CLAUDE.md'nin üzerine onaysız yazıldı | Adım 0 atlanmamalı — yedek + onay zorunlu |
| Versiyon notu eklenmedi | Adım 1 tamamlanmadı — başa `> Anayasa kaynağı: sadevardiya vYYYY-MM-DD (hash N)` ekle |
| Anayasa bloğu eksik kopyalandı | `wc -l CLAUDE.md` ile boyut kontrolü, 380+ satır olmalı |
| Proje-spesifik bölüm anayasanın **arasına** yazıldı | Sadece dosya **sonuna** ekle |
| 9 sorudan birini atladın | Hepsi zorunlu, atlama. Component stratejisi (Soru 8) en sık unutulan |
| "Anayasa istisnası" gerekçesiz veya kalıcı yazıldı | Gerekçe yoksa istisna kabul edilemez. Belirsizse "GEÇİCİ" etiketiyle ekle |
| 9 soruyu toplu liste olarak sordun | Sırayla sor — her cevap sonraki sorunun bağlamını netleştirir |
| Master proje için TENANT_ID değeri yazıldı | Master = `N/A — multi-tenant master`, somut tenant ID yazma |
| Component stratejisi A seçildi ama `cp` komutu çalıştırılmadı | Adım 3 template'inde belirtildi sadece — kullanıcıya hatırlat: `cp -r ...` komutu manuel çalıştırılmalı |
| Senkronizasyon notu unutuldu | Anayasa güncellenince satellite manuel senkron şart |

## Anayasa Güncellendiğinde Senkronizasyon

Sadevardiya'da `SADE-AILESI-ANAYASA.md` değiştiğinde satellite `CLAUDE.md`'lerin anayasa bloğu güncellenmeli. Manuel akış:

1. Sadevardiya'da son hash: `git log --oneline -1 docs/SADE-AILESI-ANAYASA.md`
2. Satellite repo'ya geç, CLAUDE.md'yi aç
3. Anayasa bloğunu (başından "🚢 BU PROJE" başlığına kadar) yenisiyle değiştir
4. CLAUDE.md başında versiyon notu güncelle: `> Anayasa kaynağı: sadevardiya v202X-XX-XX (hash NNN)`
5. Commit: `chore(anayasa): vX'e güncelle`

**Uzun vade otomasyon (henüz yapılmadı):**

GitHub Action — Sadevardiya'da `docs/SADE-AILESI-ANAYASA.md` değiştiğinde satellite repolarda otomatik PR aç. Workflow taslağı:

```yaml
# .github/workflows/anayasa-sync.yml (sadevardiya repo'sunda)
on:
  push:
    branches: [main]
    paths: [docs/SADE-AILESI-ANAYASA.md]
jobs:
  notify-satellites:
    # gh CLI ile her satellite repoda issue/PR aç
```

Bu otomasyon eklenirse skill'in "manuel senkronizasyon" bölümü güncellenir.

## Bağlantılı Skill'ler

- `/saas-uzmani` — yeni projenin SaaS stratejisi/tier kararı belirsizse danış
- `/multitenant-uzmani` — yeni proje multi-tenant rules/auth kurulumu için
- `/agent-yazici` — yeni projeye özel sub-agent yazımı için

## Real-World Etki

İlk uygulama: 2026-04-26. Sadevardiya'nın 277 satırlık `CLAUDE.md`'si parçalandı, ortak kurallar (anayasa) 396 satırlık `SADE-AILESI-ANAYASA.md` dosyasına taşındı. Bu skill sayesinde yeni Sade projesi açma süresi **~30 dakika manuel düzenlemeden** **~5 dakika otomatik kopya + bilgi toplama**'ya indi.

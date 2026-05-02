---
name: git-oturum-bitir
description: Use at the end of every Sade family work session — scans for risk (uncommitted work, unpushed commits, open branches, unsynced main), proposes actions, autonomously executes after approval, and ensures clean closure for next session/computer transition. Triggers — "/git-oturum-bitir", "git oturum bitir", "günü bitir", "oturum kapat", "iş kaydet", "bilgisayar değiştireceğim", "kapanış kontrolü", "sessionı sonlandır".
---

# Git Oturum Bitir — Sade Ailesi

## Genel Bakış

Sade ailesi oturumunu kapatmadan önce **kayıp iş ve açık branch riskini sıfırlar**. Bilgisayar değişikliğini güvenli yapar — diğer makinede sabah `/git-oturum-baslat` çağrıldığında her şey yerinde olur.

**Hedef:** "Yarım iş ortada kalmasın, push edilmemiş commit unutulmasın, açık branch birikmesin."

## 🤖 OTONOM ÇALIŞMA

**Trigger sadece skill çağrısı.** Kullanıcının tek müdahalesi — risk başına seçim (yapılır mı / atlanır mı).

- ✅ Risk taraması: otomatik
- ✅ TodoWrite ile 6 adım kayıt: otomatik
- ✅ Otonom git komutları: kullanıcı onayıyla
- ✅ Final özet: otomatik

## 🚨 ZORUNLU İLK AKSİYON — TodoWrite

Skill çağrılır çağrılmaz, ilk mesaj YAZMADAN ÖNCE TodoWrite ile 6 adım kaydedilir:

```
1. [in_progress] Adım 0 — Pre-flight (git repo + cwd)
2. [pending]    Adım 1 — Mevcut durum tespiti
3. [pending]    Adım 2 — 4 risk taraması
4. [pending]    Adım 3 — Eylem listesi (kullanıcıya sun)
5. [pending]    Adım 4 — Otonom uygulama (kullanıcı onayıyla)
6. [pending]    Adım 5 — Final kapanış raporu
```

Her adım bittiğinde `completed`, kullanıcıya "X/6 bitti" bildirimi.

## 🛑 TAMAMLAMA KRİTERLERİ

6/6 todo `completed` olmadan asla "kapanış hazır" denmez. Final raporda **tüm 4 risk** ya çözülmüş ya bilinçli atlanmış olmalı.

---

## Adım 0 — Pre-Flight

```bash
if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "🛑 Bu klasör git repo değil."
  exit 1
fi

REPO=$(basename $(git rev-parse --show-toplevel))
BRANCH=$(git branch --show-current)
echo "✓ Repo: $REPO | Branch: $BRANCH"
```

## Adım 1 — Mevcut Durum Tespiti

```bash
echo "═══════════════════════════════════════════"
echo "  GİT OTURUM KAPANIŞ TARAMASI"
echo "═══════════════════════════════════════════"

echo ""
echo "📍 Repo: $REPO"
echo "📍 Branch: $BRANCH"
echo "📍 Cwd: $(pwd)"
echo ""

git status -sb
echo ""
git log --oneline -3
```

## Adım 2 — 4 Risk Taraması

```bash
RISKS=()

# RİSK 1: Uncommitted iş
UNCOMMITTED=$(git status --porcelain)
if [ -n "$UNCOMMITTED" ]; then
  COUNT=$(echo "$UNCOMMITTED" | wc -l | tr -d ' ')
  RISKS+=("UNCOMMITTED|$COUNT dosya değişmiş ama commit edilmemiş")
fi

# RİSK 2: Push edilmemiş commit (sadece şu anki branch için)
UPSTREAM=$(git for-each-ref --format='%(upstream)' refs/heads/$BRANCH)
if [ -n "$UPSTREAM" ]; then
  AHEAD=$(git rev-list --count $UPSTREAM..HEAD 2>/dev/null || echo 0)
  if [ "$AHEAD" -gt 0 ]; then
    RISKS+=("UNPUSHED|$AHEAD commit local'de var, origin'e push edilmemiş")
  fi
else
  # Upstream yok — branch hiç push edilmemiş
  if [ "$BRANCH" != "main" ]; then
    RISKS+=("NEW_BRANCH|Bu branch hiç push edilmemiş, origin'de yok")
  fi
fi

# RİSK 3: Açık feature branch (main dışı)
if [ "$BRANCH" != "main" ]; then
  RISKS+=("OPEN_BRANCH|$BRANCH branch'i açık — PR + merge gerekebilir")
fi

# RİSK 4: Local main eski (origin'in gerisinde)
if git rev-parse --verify main >/dev/null 2>&1; then
  BEHIND=$(git rev-list --count main..origin/main 2>/dev/null || echo 0)
  if [ "$BEHIND" -gt 0 ]; then
    RISKS+=("MAIN_BEHIND|Local main, origin'in $BEHIND commit gerisinde")
  fi
fi

echo ""
echo "🔍 Tespit edilen riskler: ${#RISKS[@]}"
for risk in "${RISKS[@]}"; do
  echo "  ⚠️  $risk"
done
```

## Adım 3 — Eylem Listesi

Kullanıcıya her risk için 2-3 seçenek sun:

```
═══════════════════════════════════════════
  ÖNERİLEN EYLEMLER
═══════════════════════════════════════════

⚠️  RİSK 1: Uncommitted iş ({count} dosya)
   a) Commit et — mesaj yaz, commit oluştur
   b) Stash et — geçici kenara al
   c) Discard et — değişiklikleri at (DİKKAT — geri alınamaz)
   → Hangisi (a/b/c)?

⚠️  RİSK 2: Push edilmemiş {N} commit
   a) Push et — origin'e gönder
   b) Bekle — şimdi push etme
   → Hangisi (a/b)?

⚠️  RİSK 3: Açık branch ({branch})
   a) PR aç + squash merge — branch kapat
   b) Push et + PR aç (henüz merge etme)
   c) Açık kalsın — yarın devam edeceğim
   → Hangisi (a/b/c)?

⚠️  RİSK 4: Local main {N} commit gerisinde
   a) Pull et — origin'le senkron
   b) Bekle — bu oturumda main'e dokunmuyorum
   → Hangisi (a/b)?
```

**Önemli:** Her risk için ayrı seçim. Kullanıcı tek tek cevaplayabilir veya "hepsi a" diyebilir.

## Adım 4 — Otonom Uygulama

Kullanıcı seçtikten sonra her riskin aksiyonu çalıştırılır:

### RİSK 1 Aksiyonları

**a) Commit:**
```bash
read -p "Commit mesajı: " MSG
git add -A    # tüm değişiklikleri stage
git commit -m "$MSG"
```

**b) Stash:**
```bash
TS=$(date +%Y%m%d-%H%M%S)
git stash push -u -m "session-end-$TS"
echo "✓ Stash'lendi: session-end-$TS"
echo "  Geri almak için: git stash apply stash@{0}"
```

**c) Discard:** (TEHLİKELİ — ekstra onay)
```bash
read -p "EMİN MİSİN? Tüm değişiklikler silinecek (yes/hayır): " CONFIRM
if [ "$CONFIRM" = "yes" ]; then
  git restore .
  git clean -fd  # untracked dosyalar
fi
```

### RİSK 2 Aksiyonları

**a) Push:**
```bash
if [ -z "$UPSTREAM" ]; then
  git push -u origin "$BRANCH"
else
  git push
fi
```

### RİSK 3 Aksiyonları

**a) PR + merge:**
```bash
if [ -z "$UPSTREAM" ]; then
  git push -u origin "$BRANCH"
fi
read -p "PR başlığı: " TITLE
gh pr create --title "$TITLE" --body "Otomatik kapanış — git-oturum-bitir skill'i tarafından açıldı"
gh pr merge --squash --delete-branch
git checkout main && git pull
```

**b) Push + PR (merge yapma):**
```bash
git push -u origin "$BRANCH" 2>/dev/null || git push
read -p "PR başlığı: " TITLE
gh pr create --title "$TITLE" --body "WIP — yarın devam"
echo "✓ PR açık, merge yapılmadı."
```

### RİSK 4 Aksiyonları

**a) Pull main:**
```bash
git checkout main
git pull
git checkout "$BRANCH"   # geri dön
```

## Adım 5 — Final Kapanış Raporu

```bash
echo ""
echo "═══════════════════════════════════════════"
echo "  ✅ OTURUM KAPANIŞ RAPORU"
echo "═══════════════════════════════════════════"
echo ""
echo "📍 Final branch: $(git branch --show-current)"
echo "📍 Repo: $REPO"
echo ""

# Final risk taraması (kalan var mı?)
FINAL_UNCOMMITTED=$(git status --porcelain | wc -l | tr -d ' ')
FINAL_AHEAD=$(git rev-list --count @{u}..HEAD 2>/dev/null || echo 0)

echo "🔍 Kalan durum:"
echo "  Uncommitted: $FINAL_UNCOMMITTED dosya"
echo "  Push bekleyen: $FINAL_AHEAD commit"
echo ""

if [ "$FINAL_UNCOMMITTED" -eq 0 ] && [ "$FINAL_AHEAD" -eq 0 ]; then
  echo "✅ KAPANIŞ MÜKEMMEL — Hiçbir risk kalmadı."
  echo "   Yarın sabah / başka bilgisayarda /git-oturum-baslat ile devam et."
else
  echo "ℹ️  Bilinçli atlandığı için $FINAL_UNCOMMITTED uncommitted + $FINAL_AHEAD unpushed kaldı."
  echo "   Bu sade-stash veya WIP olarak kabul ediliyor."
fi

echo ""
echo "═══════════════════════════════════════════"
```

## Hard-Gate Final Doğrulama

```bash
FINAL_BRANCH=$(git branch --show-current)
if [ -z "$FINAL_BRANCH" ]; then
  echo "🛑 Detached HEAD — bu olmamalı, son adımda branch'e dönülmesi gerek"
  exit 1
fi

# 6/6 todo completed kontrolü Claude tarafından
echo "✅ Skill tamamlandı."
```

## Hızlı Referans

| Risk | Aksiyon |
|------|---------|
| Uncommitted | Commit / Stash / Discard |
| Unpushed | Push veya bekle |
| Open branch | PR+merge / push+PR / açık kal |
| Main eski | Pull veya bekle |

## Yaygın Hatalar

| Hata | Düzeltme |
|------|----------|
| Risk taraması yapmadan rapor verdi | Adım 2 zorunlu, atlanmaz |
| Discard'ı onaysız uyguladı | "yes" yazılmadan asla `git restore .` çalışmaz |
| Açık branch'i unutup main'de bıraktı | Adım 5 final tarama yakalar |
| TodoWrite atladı | İlk aksiyon — atlamak skill ihlali |
| Detached HEAD'de bitirdi | Hard-gate yakalar |

## Sade Ailesine Özgü Notlar

- **Bilgisayar değişimi senaryosu:** Tüm risklerin kapatılması demek "diğer makinede /git-oturum-baslat ile sorunsuz devam" demek. Risk 1 (uncommitted) ve Risk 2 (unpushed) bu senaryoda kritik — kapatılmadan diğer bilgisayara geçilmez.
- **Stash güvenliği:** Discard yerine stash tercih edilir — geri alınabilir.
- **PR açma şart değil:** Yarım iş varsa açık branch'i koruma seçeneği var. Disipline her şeyi sıkmaya çalışma — kullanıcı bilinçli "yarım kalsın" diyebilir.
- **Sade ailesi multi-repo:** Her Sade repo'sunda çalışır, repo-spesifik özel davranış yok.

## İlişkili Skill'ler

- `/git-oturum-baslat` — eş skill, oturum başlangıcında
- `/sade-yeni-proje` — yeni Sade satellite kurulumu

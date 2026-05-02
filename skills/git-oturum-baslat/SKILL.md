---
name: git-oturum-baslat
description: Use at the start of every Sade family work session — assesses git state across all branches, detects multi-machine drift and stale work, presents 4 startup scenarios (new work / continue / cleanup / analysis), and sets up a clean working point. Triggers — "/git-oturum-baslat", "git oturum başlat", "git başlangıç", "yeni gün", "branch durumu", "git durumum ne", "branch karmaşası çöz", "oturuma başlıyorum", "güne başlıyorum".
---

# Git Oturum Başlat — Sade Ailesi

## Genel Bakış

Her Sade ailesi oturumunun ilk komutu. 30 saniyede git durumunu temizleyip kullanıcıyı **güvenli ve doğru bir başlangıç noktasına** götürür. Multi-machine + paralel AI ajan + açık branch karmaşasını disipline eder.

**Hedef:** Kullanıcı asla "hangi branch'teyim, ne durumda" sorusunu sormak zorunda kalmasın.

## 🤖 OTONOM ÇALIŞMA

**Trigger sadece skill çağrısı.** Kullanıcıdan ekstra bilgi beklemez.

- ✅ Pre-flight + fetch + status: otomatik
- ✅ Sorun tespiti: otomatik
- ✅ TodoWrite ile 7 adım kayıt: otomatik
- ✅ Kullanıcının tek müdahalesi: 4 senaryodan birini seçmek (Adım 5)

## 🚨 ZORUNLU İLK AKSİYON — TodoWrite

Skill çağrılır çağrılmaz, ilk mesaj YAZMADAN ÖNCE TodoWrite ile 7 adım kaydedilir:

```
1. [in_progress] Adım 0 — Pre-flight (git repo + cwd kontrolü)
2. [pending]    Adım 1 — Senkronizasyon (git fetch --all --prune)
3. [pending]    Adım 2 — Envanter (branch + status + log)
4. [pending]    Adım 3 — Sorun tespiti (uncommitted, divergent, stale)
5. [pending]    Adım 4 — Tek sayfa rapor (kullanıcıya sun)
6. [pending]    Adım 5 — Senaryo seçimi (4 seçenek)
7. [pending]    Adım 6 — Otonom uygulama
8. [pending]    Adım 7 — Çalışma noktası kurma + final
```

Her adım bittiğinde `completed`, sonraki `in_progress`, kullanıcıya "X/8 bitti" bildirimi.

## 🛑 TAMAMLAMA KRİTERLERİ

8/8 todo `completed` olmadan asla "hazırsın" veya "tamam" denmez. Kullanıcının seçeceği bir şey yoksa skill durmaz, kendi başına bitirir.

---

## Adım 0 — Pre-Flight (Otonom)

```bash
# Git repo mu? cwd doğru mu?
if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "🛑 Bu klasör git repo değil. cd ile doğru klasöre git."
  exit 1
fi

REPO_NAME=$(basename $(git rev-parse --show-toplevel))
CURRENT_BRANCH=$(git branch --show-current)
echo "✓ Repo: $REPO_NAME"
echo "✓ Mevcut branch: $CURRENT_BRANCH"
```

## Adım 1 — Senkronizasyon

```bash
echo "→ Origin'den haberler alınıyor..."
git fetch --all --prune 2>&1 | tail -10
```

`--prune` = origin'de silinmiş branch'lerin local refs'i de temizlenir. Multi-machine senkron için kritik.

## Adım 2 — Envanter

```bash
echo "=== LOCAL BRANCH'LER ==="
git branch -vv

echo ""
echo "=== ORİGİN BRANCH'LER ==="
git ls-remote --heads origin 2>&1 | awk '{print $2}' | sed 's|refs/heads/||'

echo ""
echo "=== MEVCUT BRANCH STATUS ==="
git status -sb

echo ""
echo "=== SON 5 COMMIT ==="
git log --oneline -5
```

## Adım 3 — Sorun Tespiti

Aşağıdaki 5 risk her oturum başlangıcında otomatik taranır:

```bash
ISSUES=()

# 1. Uncommitted iş var mı?
if [ -n "$(git status --porcelain)" ]; then
  ISSUES+=("⚠️  Uncommitted iş var (commit veya stash gerek)")
fi

# 2. Local main divergent mı?
if git rev-parse --verify main >/dev/null 2>&1; then
  BEHIND=$(git rev-list --count main..origin/main 2>/dev/null || echo 0)
  AHEAD=$(git rev-list --count origin/main..main 2>/dev/null || echo 0)
  if [ "$BEHIND" -gt 0 ]; then
    ISSUES+=("⚠️  Local main, origin'in $BEHIND commit gerisinde (pull gerek)")
  fi
  if [ "$AHEAD" -gt 0 ]; then
    ISSUES+=("⚠️  Local main, origin'in $AHEAD commit önünde (push gerek veya bilinmeyen iş)")
  fi
fi

# 3. Bilinmeyen commit'ler var mı? (son 5 commit, bu oturumda yapılmamış)
USER_EMAIL=$(git config user.email)
RECENT_OTHER=$(git log --since="2 days ago" --format="%an" | grep -v "$USER_EMAIL" | sort -u | head -3)
if [ -n "$RECENT_OTHER" ]; then
  ISSUES+=("ℹ️  Son 2 günde başka yazarlardan commit var (paralel oturum?)")
fi

# 4. Açık branch sayısı
LOCAL_BRANCHES=$(git branch | wc -l | tr -d ' ')
if [ "$LOCAL_BRANCHES" -gt 3 ]; then
  ISSUES+=("⚠️  $LOCAL_BRANCHES local branch açık — fazla, temizlik önerilir")
fi

# 5. Origin'de silinmiş ama local'de duran branch'ler
git remote prune origin --dry-run 2>&1 | grep "would prune" | while read line; do
  ISSUES+=("ℹ️  Stale branch: $(echo $line | awk '{print $3}')")
done
```

## Adım 4 — Tek Sayfa Rapor

Kullanıcıya format:

```
═══════════════════════════════════════════
  GİT OTURUM BAŞLANGIÇ RAPORU
═══════════════════════════════════════════

📍 Repo:           {repo_name}
📍 Mevcut branch:  {current_branch}
📍 Origin sync:    {synced ✅ | divergent ⚠️}

📊 Açık branch'ler ({count}):
   ⭐ {current}
   - {other_branches}

🔍 Tespit edilen durumlar:
   {issues_list}

═══════════════════════════════════════════
  4 SENARYODAN BİRİNİ SEÇ:
═══════════════════════════════════════════

  A) 🆕 Yeni iş başlatıyorum
     → main'e geç, pull, yeni branch aç

  B) 🔄 Yarım işime devam ediyorum
     → mevcut/seçilen branch'e checkout, pull

  C) 🧹 Sadece temizlik
     → main'e geç, pull, ölü branch sil

  D) 🤔 Bilmiyorum / detaylı analiz
     → her açık branch'in son durumu, son commit'ler

  Cevap: A / B / C / D ?
```

## Adım 5 — Senaryo Seçimi (Kullanıcı Etkileşimi)

**Tek müdahale noktası.** Kullanıcı A/B/C/D der, sonrası otonom.

### A) Yeni İş

```bash
git checkout main
git pull
read -p "Yeni branch için kısa açıklama (örn. 'shelf-life-export'): " DESC
read -p "Tip (feat/fix/chore/docs/refactor): " TYPE
BRANCH="$TYPE/$DESC"
git checkout -b "$BRANCH"
echo "✓ $BRANCH branch'i açıldı, main'in tepesinde."
```

### B) Yarım İşe Devam

```bash
echo "Açık branch'ler:"
git branch | grep -v main | nl
read -p "Hangi branch (numara veya isim): " CHOICE
# checkout + pull
git checkout "$CHOICE"
git pull 2>&1
echo "✓ $CHOICE branch'inde, multi-machine senkron tamam."
```

### C) Sadece Temizlik

```bash
git checkout main 2>&1
git pull 2>&1

# Ölü local branch'leri tespit et (origin'de yok artık)
for branch in $(git for-each-ref --format='%(refname:short)' refs/heads/); do
  if [ "$branch" = "main" ]; then continue; fi
  UPSTREAM=$(git for-each-ref --format='%(upstream)' refs/heads/$branch)
  if [ -z "$UPSTREAM" ]; then continue; fi
  if ! git ls-remote --exit-code --heads origin "$branch" >/dev/null 2>&1; then
    echo "→ Ölü branch tespit: $branch (origin'de yok)"
    read -p "  Sileyim mi? (y/n): " YN
    [ "$YN" = "y" ] && git branch -D "$branch"
  fi
done

echo "✓ Temizlik tamam."
```

### D) Detaylı Analiz

```bash
echo "=== HER AÇIK BRANCH'IN SON DURUMU ==="
for branch in $(git branch --format='%(refname:short)'); do
  echo ""
  echo "─── $branch ───"
  git log --oneline -3 "$branch"
  AHEAD_BEHIND=$(git rev-list --left-right --count main...$branch 2>/dev/null)
  echo "main'e göre: $AHEAD_BEHIND (sol: main, sağ: $branch)"
done

echo ""
echo "Şimdi A/B/C senaryolarından birini seçebilirsin."
```

## Adım 6 — Otonom Uygulama

Adım 5'teki bash bloğu zaten çalıştı. Bu adım onun verifying'i + cleanup:

```bash
git status -sb
git log --oneline -3
```

## Adım 7 — Final Çalışma Noktası

```bash
NEW_BRANCH=$(git branch --show-current)
HEAD_COMMIT=$(git log --oneline -1 | head -c 60)

echo "═══════════════════════════════════════════"
echo "  ✅ GİT OTURUM HAZIR"
echo "═══════════════════════════════════════════"
echo ""
echo "📍 Şu an: $NEW_BRANCH"
echo "📍 HEAD: $HEAD_COMMIT"
echo ""
echo "Çalışmaya başlayabilirsin. İş bitince:"
echo "  → /git-oturum-bitir   (kapanış kontrolü)"
echo "═══════════════════════════════════════════"
```

## Hard-Gate Final Doğrulama

Skill bitmeden zorunlu kontrol:

```bash
FINAL_BRANCH=$(git branch --show-current)
UNCOMMITTED=$(git status --porcelain | wc -l | tr -d ' ')

if [ -z "$FINAL_BRANCH" ]; then
  echo "🛑 SKILL FAILURE — Detached HEAD veya branch yok"
  exit 1
fi

if [ "$UNCOMMITTED" -gt 0 ]; then
  echo "ℹ️  Uncommitted iş kaldı (Adım 5'te B veya başka senaryo seçildiyse normal)"
fi

echo "✅ Skill tamamlandı: $FINAL_BRANCH'desin, çalışmaya hazırsın."
```

## Hızlı Referans

| Senaryo | Komutlar |
|---------|----------|
| Yeni iş | `git checkout main && git pull && git checkout -b feat/<isim>` |
| Yarım iş | `git checkout <branch> && git pull` |
| Temizlik | `git checkout main && git pull` + ölü branch silme |
| Analiz | `git branch -vv` + her branch için son commit |

## Yaygın Hatalar

| Hata | Düzeltme |
|------|----------|
| TodoWrite atladı | Skill'in en kritik ihlali — ilk aksiyon TodoWrite |
| Adım 1'de durdu (sadece fetch + tamam) | 8 adım var, durmaz |
| 4 senaryo göstermeden uygulama yaptı | Kullanıcı seçimi şart, varsayma |
| Detached HEAD'de bıraktı | Adım 7 hard-gate yakalar, branch'e geçirir |

## Sade Ailesine Özgü Notlar

- **Multi-machine farkındalığı:** `git fetch --all` her zaman önce. Origin'den haber gelmeden başlama.
- **Paralel AI oturumu:** Bilinmeyen commit (başka author) tespit edilirse kullanıcıya not düş.
- **main güvenli liman:** Kafa karışırsa Adım 5'te D → C kombinasyonu.
- **Sade ailesi multi-repo:** Bu skill her Sade repo'sunda çağrılabilir (sadevardiya, sade-b2b, sade-pasta-siparis-sistemi, sade-qr-menu, vb.). Repo-spesifik özel davranış yok.

## İlişkili Skill'ler

- `/git-oturum-bitir` — eş skill, oturum kapatırken kullanılır
- `/sade-yeni-proje` — yeni Sade satellite başlatırken

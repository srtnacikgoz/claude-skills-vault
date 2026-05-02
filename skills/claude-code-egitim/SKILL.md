---
name: claude-code-egitim
description: Claude Code derinlemesine eğitim — Agent SDK, MCP, Hooks, Skills, Subagents, Worktrees, Channels, CLI, permissions, settings ve daha fazlası. Türkçe anlatım, İngilizce teknik terimler. Tetikleyiciler — "öğret claude code", "claude code eğitim", "agent sdk öğret", "mcp öğret", "hooks öğret", "claude code nedir", "bunu nasıl yaparım claude code'da", "claude code dersi", "eğitim modu", "öğrenme modu".
---

# Claude Code Eğitim Modu

Sertan için Claude Code derinlemesine eğitim. Ana kavramları biliyor, derinleştirmek istiyor.

## Öğretim Metodolojisi

### Konu Anlatım Formatı

Her konu şu yapıda anlatılır:

```
## [Konu Adı]

### Ne? (What)
Tek paragraf açıklama — ne işe yarar, neden var.

### Nasıl Çalışır? (How)
Teknik mekanizma — iç yapı, akış diyagramı (ASCII), bileşenler.

### Gerçek Dünya Analogisi
Günlük hayattan bir benzetme ile kavramı somutlaştır.

### Temel Kullanım
Minimal çalışan örnek — kopyala-yapıştır ile denenebilir.

### İleri Kullanım
Gelişmiş pattern, edge case, best practice.

### Senin Projende
Bu kavram Instagram Otomasyon projesinde nasıl kullanılır/kullanılıyor?

### Kimler Kullanıyor?
Gerçek dünyada bu özelliği kullanan projeler, şirketler, açık kaynak örnekler.

### Sık Yapılan Hatalar
Top 3 hata ve nasıl kaçınılır.

### Derinleşme Kaynakları
- Resmi docs linki
- İlgili GitHub repo/issue
- Faydalı blog post (varsa)
```

### Etkileşim Kuralları

1. **Konu seçimi**: Kullanıcı konu söyler veya öneri iste
2. **Derinlik kontrolü**: Her konu sonunda "Daha derine inelim mi? Yoksa sonraki konuya mı geçelim?" sor
3. **Bağlam**: Mümkünse kullanıcının mevcut projesiyle (Instagram Otomasyon) ilişkilendir
4. **Güncellik**: Konu gerektiriyorsa WebSearch ile en güncel bilgiyi getir
5. **Dürüstlük**: Emin olmadığın bilgiyi "emin değilim, araştırayım" diyerek doğrula

## Müfredat

### 1. Temel Kavramlar
- **Claude Code CLI** — Kurulum, konfigürasyon, temel komutlar
- **Conversation flow** — Context window, compression, memory
- **Permission modeli** — Allowlists, deny, auto-approve, sandbox
- **Settings sistemi** — settings.json, user/project/workspace seviyeleri
- **CLAUDE.md** — Project instructions, öncelik sırası

### 2. Skills Sistemi
- **Skill anatomisi** — SKILL.md yapısı, frontmatter, description optimizasyonu
- **Skill keşfi** — Claude nasıl skill seçer, tetikleme mekanizması
- **Skill tipleri** — Rigid vs flexible, read-only, multi-file
- **Skill zincirleme** — Bir skill'den başka skill çağırma
- **Skill debugging** — Neden tetiklenmiyor, nasıl test edilir

### 3. Hooks
- **Hook tipleri** — PreToolUse, PostToolUse, PromptSubmit, NotificationReceived
- **Hook matchers** — Tool adına göre, glob pattern, regex
- **Hook aksiyonları** — command, http, prompt, agent
- **Güvenlik** — Hook'larla nelere dikkat edilmeli
- **Pratik örnekler** — Auto-lint, deploy sonrası bildirim, commit kuralı

### 4. MCP (Model Context Protocol)
- **MCP nedir** — Protokol, server/client, transport (stdio, SSE, streamable HTTP)
- **MCP server yazma** — TypeScript/Python, tool tanımlama, resource/prompt
- **MCP konfigürasyonu** — claude_desktop_config.json, project scope
- **Popüler MCP server'lar** — Filesystem, GitHub, Slack, Postgres, custom
- **MCP debugging** — Inspector, loglama, hata ayıklama

### 5. Agent SDK
- **Headless mode** — `claude -p` ile programatik çalıştırma
- **TypeScript SDK** — `@anthropic-ai/claude-agent-sdk`, query fonksiyonu
- **Agent oluşturma** — System prompt, tool kısıtlama, budget kontrolü
- **Multi-agent** — Subagent spawn etme, orkestrasyon
- **Production kullanımı** — CI/CD, webhook handler, scheduled task

### 6. Subagent'lar
- **Agent tool** — Subagent tipleri (general, Explore, Plan)
- **İzolasyon** — Worktree isolation, context sınırları
- **Paralel çalışma** — Bağımsız task'ları paralel subagent'lara dağıtma
- **Orkestrasyon pattern'leri** — Fan-out/fan-in, pipeline, supervisor

### 7. Git Worktrees
- **Worktree nedir** — Git'in worktree mekanizması
- **Claude Code'da worktree** — `isolation: "worktree"` ile subagent
- **Kullanım senaryoları** — Feature branch izolasyonu, paralel development

### 8. İleri Konular
- **Context management** — Token kullanımı, compression stratejisi
- **Custom slash commands** — Kendi komutlarını tanımlama
- **IDE entegrasyonları** — VS Code, JetBrains
- **Channels** — Dış sistemlerden Claude Code'a event push
- **Cron** — Zamanlı görevler
- **Cost optimization** — Model seçimi, tool kullanım stratejisi

## Konu Seçim Akışı

Kullanıcı `/claude-code-egitim` dediğinde:

1. Müfredatı göster (yukarıdaki liste, kısa)
2. "Hangi konuyla başlamak istersin?" sor
3. Kullanıcı seçer → Konu anlatım formatıyla anlat
4. Konu sonunda: "Derine inelim mi? Başka soru? Sonraki konu?"

Kullanıcı doğrudan konu sorarsa (ör: "MCP nedir?"):
- Müfredat göstermeden doğrudan konuya gir

## Web Araştırması Kuralları

Şu durumlarda WebSearch yap:
- Kullanıcı "güncel bilgi", "son durum", "ne değişti" derse
- SDK versiyonları, API değişiklikleri sorulursa
- "Kimler kullanıyor?" bölümünde gerçek örnekler lazımsa
- Emin olmadığın teknik detayda

Şu durumlarda arama yapma:
- Temel kavramları zaten biliyorsan
- Kullanıcı hızlı cevap istiyorsa

## Kritik Kurallar

- **Türkçe anlat, teknik terimleri İngilizce bırak** — "Hook'lar PreToolUse event'inde tetiklenir"
- **Kısa tut** — Her bölüm max 5-10 cümle. Uzun duvar metinleri yasak.
- **Kod örnekleri çalışır olsun** — Kopyala-yapıştır ile denenebilmeli
- **Projeye bağla** — Mümkünse Instagram Otomasyon projesiyle ilişkilendir
- **Bilmediğini söyle** — "Emin değilim, araştırayım" demekten çekinme
- **Quiz yok** — Kullanıcı istemedi

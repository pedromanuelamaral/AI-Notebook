---
name: data-scrape
description: data gathering loop
metadata:
  author: github.com/pedromanuelamaral 
  modified: 24-August-2026
compatibility: Requires docker, github, searxng and crawl4ai; either browser-mcp, browebase or steel.dev.
---

# Main Orchestration

**Purpose:** setup-compliance check, compute & tokens consumption management, output review/collection/enrichment, loop/cron scheduling, feedback gathering and critical time-sensitive user updates.

**ID:** Main-Orchestration-Brain
**Trigger:** New agent creation, first run, or scheduled cron tick (`0 */3 * * *`).

**Loop:**

  **1. Setup - One Time:**

    - Generate dir structure:
      - `config.yaml` (keywords, filters, priorities, storage provider, ai model, min_score, batch_size, browser provider choice: browser-mcp vs browsebase vs steel)
      - `profile/context.md` (resume/interests/criteria)
      - `scraper/sources/` (one file per source), `scraper/main.py` (orchestrator), `scraper/filters.py` (rule pre-filter)
      - `ai/client.py` with model fallback chain over free custom api endpoints (e.g. `nvidia-nim/llama-3.1-8b -> groq/llama-3.3-70b -> openrouter/qwen-3-8b -> local-llm/bonsai-27b`) + local models via `llama.cpp` / `open-webui` / `fork-prism-llama.cpp`, `ai/pipeline.py` batch size 5, `ai/memory.py` with `feedback.json`, `storage/notion_sync.py` (or sheets/supabase), `.env.example`, `requirements.txt` with crawl4ai, searxng client, notion-client, pyyaml, steel-browser-sdk, browserbase SDK
      - If dir exists -> TERMINAL NO_OP_ALREADY_SETUP, skip to Collection Phase.

    - Docker compose up - Verify all health endpoints 200:
      - `searxng:8080` -> `http://localhost:8080/search?q=test&format=json` 200
      - `crawl4ai:11235` -> `http://localhost:11235/health` 200
      - Browser layer - based on config.yaml choice:
        - `browser-mcp` -> check local Chrome extension active + MCP server reachable (no docker needed, rides your existing browser, zero new Chromium process)
        - `steel.dev self-host` -> `http://localhost:3000/v1/status` 200 + `docker ps | grep steel`
        - `browsebase cloud` -> verify `BROWSEBASE_API_KEY` env + `https://api.browsebase.com/health` (zero local footprint, browser runs on their servers, great for 24GB M4)
      - If any fails after 3 retries -> TERMINAL FAILED_GUARDRAIL, log which service failed, do not proceed.

    - Cron setup - Two layers:
      a. Local cron for docker host: `crontab -e` -> `0 */3 * * * cd /path/my-agent && docker compose up -d && uv run python -m scraper.main >> cron.log 2>&1`
      b. GitHub Actions free: `.github/workflows/scraper.yml` with `on: schedule cron: "0 */3 * * *"`, `workflow_dispatch`, `permissions: contents: write`, steps: checkout@v4, setup-python@v5 3.11 cache pip, pip install -r requirements.txt, optional `playwright install chromium --with-deps` if needed, run agent with env `NOTION_TOKEN`, `NOTION_DATABASE_ID`, `CUSTOM_API_KEY` (nvidia nim / groq / openrouter) or `LOCAL_LLM_ENDPOINT`, commit feedback `git add data/feedback.json || true && git diff --cached --quiet || git commit -m "chore: update feedback history" && git push`
      - If cron setup fails -> TERMINAL BLOCKED_MISSING_CONTEXT, state what is missing (crontab permission, gh workflow path).

  **2. Collection Loop Phase:**

    a. Run Search (SearXNG) Explore Loop for each priority in `config.yaml` -> get candidate URLs. If all priorities return NO_OP -> TERMINAL NO_OP_NO_NEW.
    b. For each candidate batch (max 5 URLs per batch to stay within free custom endpoint rate limits), run Scrape (Crawl4AI) Loop -> normalized items with schema `name, url, source, date_found`.
    c. For any needing JS (empty HTML or NEEDS_BROWSER), run Browse Check Loop (browser-mcp / browsebase / steel.dev) -> verified items.
    d. Deduplicate by URL via seen set + `get_existing_urls(db_id)` from storage. If 0 unique after dedup -> TERMINAL NO_OP_DUPLICATE, exit early to save compute/tokens.
    e. If collect fails for one source, log FAILED but continue other sources. If all sources fail -> TERMINAL FAILED_VERIFICATION with failed source list.

  **3. Enrich Phase - Batch AI (free custom endpoints + locally deployed models):**

    - Check `ai_enabled()` = `CUSTOM_API_ENDPOINT` (nvidia nim, groq, etc) or `LOCAL_LLM_ENDPOINT` (e.g. `http://localhost:8080/v1` for llama.cpp Bonsai 27B / Gemma 12B) exists. If not -> skip AI, TERMINAL SUCCESS_NO_AI, store raw.
    - Tokens management: Track `total_tokens_M` per run, cap based on provider free tier (groq ~14k RPM free, nvidia nim ~1000 req/day free). If approaching limit -> switch to lighter local model `Bonsai 27B` or `Gemma 4-12B` via local-llm or pause low-score items. For local models, track `peak_vram_mb` to avoid OOM on M4 24GB.
    - Load feedback via `load_feedback()` from `data/feedback.json`, build preference prompt via `build_preference_prompt()` max 15 positive/negative examples to keep context low for small local models (critical for 9B models where grounding fails with noisy input).
    - Load context from `profile/context.md` (max 800 chars truncated).
    - Batch items: chunks size 5 (from `config.yaml ai.batch_size`). For each batch, build prompt with items_text json, user context, priorities, preference prompt. Call `ai/client.py generate()` with fallback chain over free custom endpoints: `nvidia-nim -> groq -> openrouter -> local-llm`. Rate_limit 2-7s depending on provider. maxOutputTokens >=2048. Parse `analyses[]`. If score < min_score -> skip. If analyses length mismatch -> use what you have, log warning.
    - If all batches succeed -> TERMINAL SUCCESS_ENRICHED with enriched items (ai_score, ai_summary, ai_notes). If 429 quota on all custom endpoints -> TERMINAL PARTIAL_SUCCESS_RATE_LIMIT, fallback to locally deployed model, store unenriched and schedule retry next cron.

  **4. Store Phase:**

    - Resolve provider from `config.yaml storage.provider`: notion -> `NOTION_DATABASE_ID`, sheets -> `SHEET_ID`, supabase -> `SUPABASE_TABLE`. If env missing -> TERMINAL BLOCKED_MISSING_CONTEXT.
    - Call `sync(db_id, enriched_items)` -> returns added, skipped. Deduplicate by URL before push. If push fails -> retry once with 2s wait, if still fails -> TERMINAL FAILED_VERIFICATION.
    - If added=0 and skipped>0 -> TERMINAL NO_OP_ALREADY_STORED.

  **5. Learn Phase - Feedback Loop:**

    - Query storage for items with positive_statuses `["Saved","Applied","Interested"]` and negative `["Skip","Rejected","Not relevant"]` from `config.yaml feedback`. Extract title/patterns.
    - Call `save_feedback()` -> writes `data/feedback.json`. If write fails -> TERMINAL FAILED_VERIFICATION but don't block pipeline.
    - Commit feedback.json if in GitHub Actions path. This makes agent smarter over time with zero infra.

  **6. Evidence & Schedule + Critical Updates:**

    - Log summary: `Done — {added} new, {skipped} existing, {len(enriched)} enriched, {len(batches)} API calls, {tokens} tokens, {duration}s`.
    - Compute management: Log `peak_vram_mb` if using local LLM, `mfu_percent` if available, duration. If using browsebase/steel cloud -> log zero local footprint, RAM pressure off-device.
    - Critical time-sensitive updates: If ai_score >=90 or price drop >20% or keyword = urgent from config.yaml priorities, push immediate notification (via Notion comment, webhook, or log `CRITICAL:`). Do not wait for next cron.
    - If running via cron, exit. If via GitHub Actions, let workflow commit feedback. Next run auto-triggered by cron `0 */3 * * *`.
    - Final terminal: If any phase SUCCESS -> TERMINAL SUCCESS_PIPELINE. If all NO_OP -> TERMINAL NO_OP_ALL_DUPLICATE. If any FAILED -> TERMINAL PARTIAL_SUCCESS_WITH_ERRORS with source failure map.

**Guardrails:** Batch LLM 5 items/call, maxOutputTokens >=2048, .env in .gitignore, .env.example provided, setup.py creates schema, enrich_existing.py backfills, deduplicate by URL always, respect robots.txt, use public APIs when available, rate limit 1s between scrapes. One logical operation per block via Verified-Execution-Loop for file writes/deletes. Never hardcode keywords, all in config.yaml.

**Free Tier Limits:** Custom endpoints - groq free ~14k RPM, nvidia nim free ~1000 req/day, openrouter free models, local-llm free (M4 24GB) - zero cost, Bonsai 27B ~4-8 tok/s. GitHub Actions unlimited public repos ~20min/day, Notion unlimited ~200 writes/day. Fits free without vendor lock-in.

---

# Search (SearXNG) Explore Loop

**ID:** SearXNG-Discovery-Loop
**Trigger:** User wants deep specific public data/sources/crawl, or Main Orchestration needs candidate URLs.

**Goal:** Discover fresh, relevant public URLs for a topic using self-hosted searxng docker, no API limits, no tracking.

**Loop:**
  1. SETUP - Ensure searxng docker running:
     - Check `docker ps | grep searxng`. If not running -> `docker run -d --name searxng -p 8080:8080 searxng/searxng` or via compose. If fails -> TERMINAL FAILED_GUARDRAIL.
     - Verify endpoint `http://localhost:8080/search?q=test&format=json` returns 200. If 404/429 -> wait 2s retry, if fails 3x -> TERMINAL BLOCKED_MISSING_CONTEXT, state searxng not reachable.
  2. QUERY BUILD: From config.yaml + profile/context.md + priorities, build 3-5 search queries. Example: job board -> ["site:jobs.example.com AI engineer", "AI jobs remote last 24h"]. Deduplicate queries.
  3. SEARCH ONE: For ONE query, call searxng JSON API: `http://localhost:8080/search?q=<query>&format=json&categories=general`. Capture `results[].url, title, content`. If 0 results -> try broader query, if still 0 after 2 tries -> TERMINAL NO_OP_NO_RESULTS.
  4. FILTER: Rule-based pre-filter via scraper/filters.py: required_keywords, blocked_keywords from config.yaml. Fast, before AI. If filtered out all -> TERMINAL NO_OP_FILTERED.
  5. DEDUP: Check against storage existing URLs (Notion/Sheets/Supabase) via get_existing_urls(). If URL already in DB -> skip. If all dupes -> TERMINAL NO_OP_DUPLICATE.
  6. EVIDENCE: Return list of new candidate URLs with title/snippet. Log count. If count>0 -> TERMINAL SUCCESS_DISCOVERED, handoff URLs to Crawl4AI-Deep-Crawl-Loop. If 0 after all queries -> TERMINAL NO_OP_NO_NEW.

**Guardrails:** One search per pass, rate limit 1s between searxng calls. Never hardcode queries, read from config.yaml. No API keys needed - self-hosted.

**Docker Compose:**
```yaml
services:
  searxng:
    image: searxng/searxng
    ports: ["8080:8080"]
    volumes: ["./searxng:/etc/searxng"]
    restart: unless-stopped
```

---

# Scrape (Crawl4AI) Loop

**ID:** Crawl4AI-Deep-Crawl-Loop
**Trigger:** Have candidate URLs from Search Loop, need to extract structured data from public sources.

**Goal:** Deep crawl and normalize public data using crawl4ai docker tool with anti-detection, batch efficiency.

**Loop:**
  1. SETUP - Ensure crawl4ai docker running:
     - Check `docker ps | grep crawl4ai`. If not -> `docker run -d --name crawl4ai -p 11235:11235 --shm-size=2g unclecode/crawl4ai` or compose. Verify `http://localhost:11235/health` 200. If fails 3x -> TERMINAL FAILED_GUARDRAIL.
  2. PICK ONE SOURCE: From candidate URLs, pick ONE source file scraper/sources/*.py or ONE URL batch (max 5 URLs per batch to stay within free endpoint limits). Load filters from config.yaml.
  3. CRAWL ONE - Call crawl4ai via REST or Python client:
     ```python
     from crawl4ai import AsyncWebCrawler
     ```
     Use params: `headless=True, wait_for=".listing" or "article", css_selector from source, magic=True (anti-bot), cache_mode="bypass"`. If JS-rendered fails with empty HTML -> TERMINAL NEEDS_BROWSER, handoff to Browse Check Loop (browser-mcp / browsebase / steel.dev).
  4. NORMALIZE: Convert raw to standard schema via _normalise(): must have name, url, source, date_found (ISO). Add domain fields. If missing required fields -> TERMINAL FAILED_VERIFICATION, log raw snippet tail -n 50.
  5. FILTER & DEDUP: Apply is_relevant() rule filter, then dedup by URL against seen set. If all filtered/duped -> TERMINAL NO_OP_FILTERED.
  6. EVIDENCE: Return normalized batch (max 5 items). Capture tokens, time. If batch ok -> TERMINAL SUCCESS_CRAWLED, handoff to Browse Check Loop for JS verification OR directly to enrichment if simple HTML. If crawl crashes (timeout, 403, bot block) -> retry once with wait 2s + user-agent rotation, if still fails -> TERMINAL EXPERIMENT_CRASH, log 0 items, continue next URL.

**Guardrails:** Batch size <=5 URLs per crawl call, 1s delay between calls. Never call LLM here, only raw extract. Use crawl4ai magic mode for anti-detection. One operation per block via Verified-Execution-Loop.

**Docker Compose:**
```yaml
  crawl4ai:
    image: unclecode/crawl4ai
    ports: ["11235:11235"]
    shm_size: 2gb
    restart: unless-stopped
```

---

# Browse Check Loop

**ID:** Browser-Verification-Loop
**Trigger:** Scrape Loop returned empty content or verification/extraction/optimisation needed, JS-heavy site, anti-bot page, paywalled content needing logged-in session.

**Goal:** Verify and enrich JS-rendered pages using 3-tier browser stack based on workload - choose the right tool for the job, not one tool for all.

**Context from browser-automation matrix (Aug 2026):** Seven tools pretending to be one category. Correct grouping matters:

- **Raw libraries** (you write code): Playwright, Puppeteer
- **Local/profile-attached MCP** (agent drives YOUR actual browser): Browser MCP (https://browsermcp.io/)
- **Managed cloud browser infra** (someone else runs Chromium fleet): Browsebase + Steel.dev (https://github.com/steel-dev/steel-browser)
- Self-hosted clone: Browserstation

Comparing Playwright to Browsebase is like comparing car engine to car rental company. Matrix keeps distinction in Category row.

**Loop:**

  **1. SETUP - Choose provider based on config.yaml `browser.provider` + workload:**

     **Option A - Browser MCP (https://browsermcp.io/) - Local MCP, your own Chrome:**
     - What it is: Chrome extension + local MCP server that puppets YOUR existing browser profile
     - Deployment: Runs entirely on your machine via Chrome extension, no new Chromium process, rides already-open browser
     - Control: Accessibility-tree snapshots + click/type, natural-language-friendly, best middle ground for small local models (strips noisy HTML without needing frontier model Stagehand interpretation)
     - Session persistence: AUTOMATIC - literally your logged-in profile, no re-auth
     - Anti-bot: Best-in-class by construction - real fingerprint, real history, no WebDriver flags
     - Local dev htop: Low - no new Chromium, negligible extension cost, competes with your browsing for resources
     - Best-fit: Personal/solo agent tasks needing actual logged-in sessions (Gmail, internal tools, paywalled sites) without re-auth, resource-conscious solo builder, M4 24GB constrained
     - Check: Chrome extension installed + MCP server reachable. MCP config:
       ```json
       {
         "mcpServers": {
           "browser": {
             "command": "npx",
             "args": ["-y", "@modelcontextprotocol/server-puppeteer", "--browser", "chrome-for-testing", "--port", "9222"]
           }
         }
       }
       ```
       - If not reachable -> try `npx browser-mcp` start. If fails -> TERMINAL FAILED_GUARDRAIL.

     **Option B - Browsebase - Managed cloud browser infra + AI SDK:**
     - What it is: Cloud Chromium fleet (Playwright/Puppeteer/Selenium-compatible) + Stagehand natural-language layer `act()`, `extract()`, `observe()`
     - Deployment: Fully managed cloud only (no self-host), zero local footprint - browser runs on their servers, local process just SDK + HTTP/WebSocket client, great for constrained machines (24GB M4) since RAM pressure moves off-device
     - Control: Natural language via Stagehand OR raw Playwright underneath
     - Session persistence: Yes first-class (session API, profiles)
     - Anti-bot: Strong - dedicated stealth team, Cloudflare partnership, Agent Identity product + built-in residential proxies $8/GB
     - CAPTCHA: Yes built-in, Proxy: built-in
     - Best-fit: Production agentic workflows at scale where you don't want to run browser infra, want LLM-native action layer, don't care about vendor lock-in
     - Check: `BROWSEBASE_API_KEY` env + `https://api.browsebase.com/health` 200. If fails -> TERMINAL BLOCKED_MISSING_CONTEXT.

     **Option C - Steel.dev (https://github.com/steel-dev/steel-browser) - Open-source managed browser infra:**
     - What it is: Apache-2.0 browser API wrapping Chromium in REST/WebSocket, cloud or self-host (Docker/Railway/bare metal) same binary, explicitly positions as "open, self-hostable Browserbase"
     - Deployment: Cloud OR self-host, self-hosted Steel runs full Chromium + API/UI containers budget 500MB-1GB+ RAM per concurrent session
     - Control: Raw CDP (Playwright/Puppeteer/Selenium compatible) + built-in `/scrape`, `/screenshot`, `/pdf` REST endpoints
     - Session persistence: Yes cookies/localStorage/auth state per session
     - Anti-bot: Stealth plugins + fingerprint management + optional residential proxy + built-in CAPTCHA solving (priced per solve)
     - Best-fit: Teams wanting Browserbase-grade infra but refusing vendor lock-in, same API surface self-hostable. Close to dominant strategy for solo resource-conscious self-hosting-biased builder - only option simultaneously free/OSS, genuine feature parity with managed leader, doesn't require K8s cluster like Browserstation. 90% of Browserbase features for $5-15/mo Railway box. Gap between managed and self-hosted-but-good nearly closed.
     - Check: Cloud -> `STEEL_API_KEY`, Self-host -> `docker ps | grep steel` + `http://localhost:3000/v1/status` 200. If fails -> `docker run -d -p 3000:3000 steel-dev/steel-browser` or compose. If fails -> TERMINAL FAILED_GUARDRAIL.

     - Decision logic: If config says `browser.provider=browser-mcp` OR task needs logged-in session (paywall, internal tool) -> Use Browser MCP. If `provider=browsebase` OR need zero local footprint + scale -> Use Browsebase. If `provider=steel` OR want OSS + self-host + avoid vendor lock-in -> Use Steel.dev. Default for you: Steel.dev self-hosted + Browser MCP side-by-side (Steel for sandboxed identity, Browser MCP for logged-in sessions).

  **2. PICK ONE URL:** From Crawl4AI needing verification. One URL per pass to keep context low (critical for local models like Qwen3.5-9B where grounding fails with noisy HTML - accessibility-tree from Browser MCP is best middle ground).

  **3. BROWSER OPEN:**

     - **If Browser MCP:** `browser_navigate url=<url>` rides your actual profile. `browser_wait_for selector=".listing, article, [class*='card']" timeout=10000`. Accessibility-tree snapshot auto-captured, no need to write selectors. If timeout -> `browser_evaluate` scroll `window.scrollTo(0, document.body.scrollHeight)` wait 2s. If still empty -> TERMINAL NO_OP_JS_EMPTY, mark as needs API fallback.

     - **If Browsebase:** Use Stagehand `act("open <url>")` + `observe()` or raw Playwright via SDK `page.goto(url)`. Wait for selector. If Cloudflare challenge -> Browsebase auto-handles via stealth + CAPTCHA solve. If still empty -> TERMINAL NO_OP_JS_EMPTY.

     - **If Steel.dev:** REST `POST http://localhost:3000/v1/sessions` create session with `stealth:true, captcha: true`, then `POST /v1/sessions/{id}/navigate {url}` or CDP `Page.navigate`. Wait for selector via `waitForSelector`. If blocked -> Steel auto retries with fingerprint rotation + residential proxy if configured. If still empty -> TERMINAL NO_OP_JS_EMPTY.

  **4. EXTRACT:**

     - **Browser MCP:** Use `browser_snapshot` (accessibility-tree, clean for small models) or `browser_evaluate` with JS `() => Array.from(document.querySelectorAll("[class*='listing']")).map(el => ({title: el.querySelector("h2,h3")?.innerText, url: el.querySelector("a")?.href}))`. No need for exact CSS if using accessibility tree - just `click`, `type`.

     - **Browsebase:** `extract({instruction: "extract all listings with title and url", schema: {title: string, url: string}})` natural language, or `act("extract")`. Stagehand handles grounding - good for small models where selector generation fails (spatial reasoning scales with params).

     - **Steel.dev:** `POST /v1/sessions/{id}/scrape {url, elements: [{selector: ".listing", extract: ["text","href"]}]}` or CDP `DOM.querySelectorAll`. Built-in `/screenshot`, `/pdf` for evidence.

     Capture html via screenshot for evidence if needed (optional).

  **5. VERIFY:** Compare extracted data vs crawl4ai data. Is content now present? Is it precise (title, url, date)? Is grounding correct (not net 60 read as net 30 failure mode - hardest bug where browser tool doesn't know click was semantically wrong)?

     - If Browser MCP: check accessibility tree labels match expected - if yes -> TERMINAL SUCCESS_VERIFIED.
     - If Browsebase/Steel: check Stagehand observe output or scrape JSON has required fields - if yes -> TERMINAL SUCCESS_VERIFIED.
     - If still empty after scroll + wait + stealth retry -> TERMINAL FAILED_VERIFICATION, log screenshot path, fallback to Playwright raw or mark as API-only.

  **6. CLOSE:** Always close/free session to avoid ghost processes and RAM leak:

     - Browser MCP: `browser_close` (frees tab, not whole browser since it rides your browser).
     - Browsebase: `session.close()` or `browserbase sessions close {id}` - frees cloud instance.
     - Steel.dev: `DELETE /v1/sessions/{id}` - frees container RAM (500MB-1GB per session). If close fails -> TERMINAL FAILED_GUARDRAIL but continue to avoid blocking pipeline.

**Guardrails:** One URL per pass, always close/free session, never leave 10 tabs ghost (RAM leak ~150-300MB per headless Chromium). Sandboxed only for Steel/Browsebase, real profile for Browser MCP (uses your IP, no proxy needed). One logical operation per block. Evidence = screenshot or html snippet or accessibility-tree snapshot. Permissions: ai-agent-profile only for Browser MCP (your logged-in sessions), sandboxed identity for Steel/Browsebase.

**MCP Config - All Three:**

```json
{
  "mcpServers": {
    "browser-mcp": {
      "command": "npx",
      "args": ["-y", "browser-mcp"],
      "env": {"BROWSER": "chrome"}
    },
    "browsebase": {
      "command": "npx",
      "args": ["-y", "browsebase-mcp"],
      "env": {"BROWSEBASE_API_KEY": "${BROWSEBASE_API_KEY}"}
    },
    "steel": {
      "command": "npx",
      "args": ["-y", "steel-browser-mcp"],
      "env": {"STEEL_API_KEY": "${STEEL_API_KEY}", "STEEL_API_URL": "http://localhost:3000"}
    }
  }
}
```

**Decision Matrix for You (from browser-automation-tools-matrix.md):**

| Workload | Choose | Why |
|---|---|---|
| Gmail, internal tools, paywalled, need your cookies | Browser MCP https://browsermcp.io/ | Automatic session persistence, real fingerprint, zero new Chromium, low htop, no re-auth |
| Production scale, zero local footprint, 24GB M4 constrained, need stealth/CAPTCHA/proxy | Browsebase | Zero local RAM, dedicated stealth team, Cloudflare partnership, natural language Stagehand for small models |
| Want Browserbase-grade but OSS, refuse vendor lock-in, self-host $5-15/mo Railway, 90% feature parity | Steel.dev https://github.com/steel-dev/steel-browser | Apache-2.0, cloud or self-host same binary, stealth+CAPTCHA+session persistence+CDP, dominant strategy for solo self-hosting-biased builder |

**Where it lands for you:** Steel.dev self-hosted + Browser MCP side-by-side is dominant. Steel for sandboxed identity (zero main profile pollution), Browser MCP for logged-in sessions. Browsebase when you need to push RAM pressure off-device entirely or need Stagehand natural language layer because small local model (Qwen3.5-9B) fails at raw selector grounding.

---

# Full Docker Compose - All Services

```yaml
services:
  searxng:
    image: searxng/searxng
    ports: ["8080:8080"]
    volumes: ["./searxng:/etc/searxng"]
    restart: unless-stopped

  crawl4ai:
    image: unclecode/crawl4ai
    ports: ["11235:11235"]
    shm_size: 2gb
    restart: unless-stopped

  steel-browser:
    image: steel-dev/steel-browser
    ports: ["3000:3000"]
    environment:
      - STEEL_API_KEY=${STEEL_API_KEY}
      - MAX_CONCURRENT_SESSIONS=2
      - STEALTH=true
      - CAPTCHA_SOLVING=true
    volumes:
      - ./steel-data:/data
    restart: unless-stopped
    # Browser MCP has no docker - it's Chrome extension riding your existing browser
    # Browsebase has no docker - fully managed cloud, zero local footprint
```

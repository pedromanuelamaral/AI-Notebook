# AI Research Hub

> A private, local-first workspace where rules, instructions, loops, and research notes converge around one operator.
> The hub is the operating system; everything below is the stack.

| | |
|---|---|
| **Stack** | Open-source + self-hosted, local-first, on-device inference |
| **Host** | MacBook Pro M4 · 24 GB unified · iOS · Android · Docker |

---

## What this is

An AI research and operational hub. It is not a single app — it is the **directory structure that governs how agents behave, what they research, and how residue is cleaned up after**. It holds four kinds of things:

1. **Rules** — the always-on identity and reasoning contract (`Configurations/`).
2. **Instructions** — task-specific prompt frameworks for analysis, TTS, reasoning, and hard truths (`Instructions/`).
3. **Loops** — automations that run unattended: scrape/collect, and cleanup (`Loops/`).
4. **Notebook** — dated research logs, benchmark verdicts, and build history (`Notebook/`).

A GitHub Actions workflow publishes the public front door (`.github/workflows/`).

---

## Directory structure

```
AI-Research-Hub/
├── Configurations/            ← Rules + system inventory + local model swap
│   ├── AGENT.md               ← Global always-on rules, identity, workspace, reasoning
│   ├── INVENTORY.sh           ← System snapshot (hardware, PATH, models, keys)
│   └── llama-swap.yaml        ← Local models catalogue & run configuration
├── Hooks/
│   └── compact.md             ← Context compact & handoff source-of-truth
├── Instructions/
│   ├── explain.md             ← AI-Explained-Matrix (comparative explainer)
│   ├── world-monitor.md       ← 8-section operational debrief framework
│   ├── uncensor.md            ← Uncensored reasoning/response posture
│   ├── text-to-speech.md      ← Read-aloud optimizer (EN / PT-pt)
│   └── tough-love.md          ← Private-issue stress-test persona
├── Loops/
│   ├── scrape.md              ← Data-gathering orchestration (SearXNG / Crawl4AI / browser)
│   └── cleanup.md             ← Post-task residue & cache hygiene
├── Notebook/                  ← Dated research logs & benchmark verdicts
│   ├── 2026-06-21--Gemini-3.6-Testing.md
│   ├── 2026-06-29--Cerebras-Hackathon.md  (.html recap)
│   ├── 2026-07-20--Gemma4-12B-MTP.md
│   ├── 2026-08-04--Local-AI-update.md
│   ├── 2026-08-05--Gemma4-TTS-LFM.md
│   ├── 2026-08-22--Self-Hosting-Sovereignty.md
│   ├── 2026-08-26--Un-censored.md
│   └── 2026-09-02--Speed-Tradeoffs.md
└── .github/
```

---

## 📁 Files

### Rules & configuration — `Configurations/`

| File | Purpose | Link |
|---|---|---|
| **AGENT.md** | Global always-on rules — identity, workspace, reasoning & execution rules | [🔒](https://github.com/pedromanuelamaral/AI-Research-Hub/blob/main/Configurations/AGENT.md) |
| **INVENTORY.sh** | macOS snapshot script: hardware, PATH, model dirs, key names | [🔑](https://github.com/pedromanuelamaral/AI-Research-Hub/blob/main/Configurations/INVENTORY.sh) |
| **llama-swap.yaml** | Local models catalogue with run configs, context sizes, & eval costs | [🦙](https://github.com/pedromanuelamaral/AI-Research-Hub/blob/main/Configurations/llama-swap.yaml) |

### Instructions — `Instructions/`

| File | Purpose | Link |
|---|---|---|
| **explain.md** | AI-Explained-Matrix — multi-variable (matrix/flowchart/venn) comparative explainer | [📊](https://github.com/pedromanuelamaral/AI-Research-Hub/blob/main/Instructions/explain.md) |
| **world-monitor.md** | 8-section operational debrief framework with signal tagging | [🌍](https://github.com/pedromanuelamaral/AI-Research-Hub/blob/main/Instructions/world-monitor.md) |
| **uncensor.md** | Uncensored reasoning & response posture | [🔓](https://github.com/pedromanuelamaral/AI-Research-Hub/blob/main/Instructions/uncensor.md) |
| **text-to-speech.md** | Read-aloud optimizer — verbatim, fluid, multi-part | [🎤](https://github.com/pedromanuelamaral/AI-Research-Hub/blob/main/Instructions/text-to-speech.md) |
| **tough-love.md** | Private-issue stress-test persona | [💢](https://github.com/pedromanuelamaral/AI-Research-Hub/blob/main/Instructions/tough-love.md) |

### Loops — `Loops/`

| File | Purpose | Link |
|---|---|---|
| **scrape.md** | Data-gathering orchestration: SearXNG → Crawl4AI → browser verification (MCP / Browsebase / Steel) | [🕷️](https://github.com/pedromanuelamaral/AI-Research-Hub/blob/main/Loops/scrape.md) |
| **cleanup.md** | Post-task residue & cache hygiene — one item at a time, verified | [🧹](https://github.com/pedromanuelamaral/AI-Research-Hub/blob/main/Loops/cleanup.md) |

### Research — `Notebook/`

| Note | Link |
|---|---|
| **Gemini 3.6 testing** — index.html refactor & performance/accessibility comparison | [📄](https://github.com/pedromanuelamaral/AI-Research-Hub/blob/main/Notebook/2026-06-21--Gemini-3.6-Testing.md) |
| **Cerebras hackathon** — Arta AI build, scope, criteria ([live demo](https://pedromanuelamaral.github.io/arta)) | [🏗️](https://github.com/pedromanuelamaral/AI-Research-Hub/blob/main/Notebook/2026-06-29--Cerebras-Hackathon.md) |
| **Gemma 4 QAT vs Google original** — inference benchmark | [⚖️](https://github.com/pedromanuelamaral/AI-Research-Hub/blob/main/Notebook/2026-07-20--Gemma4-12B-MTP.md) |
| **Local AI update** — model log & onboarding notes | [💻](https://github.com/pedromanuelamaral/AI-Research-Hub/blob/main/Notebook/2026-08-04--Local-Ai-update.md) |
| **Gemma-4 TTS vs LFM-2.5** — verdict: LFM wins on speed & quality | [🎯](https://github.com/pedromanuelamaral/AI-Research-Hub/blob/main/Notebook/2026-08-05--Gemma4-TTS-LFM.md) |
| **Self-hosting sovereignty** — uncensored local models & privacy rationale | [🏝️](https://github.com/pedromanuelamaral/AI-Research-Hub/blob/main/Notebook/2026-08-22--Self-Hosting-Sovereignty.md) |
| **Un-censored** — fine-tuning & local-hosted output rationale | [🔓](https://github.com/pedromanuelamaral/AI-Research-Hub/blob/main/Notebook/2026-08-26--Un-censored.md) |
| **Speed tradeoffs** — tiny-model verdicts, workhorse vs fast decay | [🏎️](https://github.com/pedromanuelamaral/AI-Research-Hub/blob/main/Notebook/2026-09-02--Speed-Tradeoffs.md) |

---

## 🌐 Live front door

The public side is published to GitHub Pages:

- **Pages deployment** → [https://pedromanuelamaral.github.io/AI-Research-Hub](https://pedromanuelamaral.github.io/AI-Research-Hub) *(deployed via `.github/workflows/pages.yml`)*

---

## 🔗 Related projects

Project lineage & the tools this hub builds on:

| Project | Purpose | Link |
|---|---|---|
| **Arta AI** | Private cultural desk — memory + retrieval + judgment — build started here | [🏛️](https://pedromanuelamaral.github.io/arta) |
| **Mentally here** | Personal, private companion for mental-health journey (built open) | [🩺](https://github.com/p-e-w/mentally-here) |
| **abliteration** | Fine-tuning uncensored models for local, private issue-handling | [🧬](https://github.com/p-e-w/heretic) |
| **Off the Grid (OGAM)** | Free self-hosted private local AI chat app | [📱](https://github.com/off-grid-ai/OGAM) |

---
# macOS Terminal Core Mastery v2
## Timeless, Platform-Agnostic Skills for Any Development Workflow
### (VS Code + Llama.cpp, Agents, or Whatever Comes Next)

**Updated for your current reality (July 2026):** Antigravity may not be clicking right now, you're leaning into VS Code + Llama.cpp (GGUF/Metal via llama.cpp as noted in your agent.md). This guide deliberately de-emphasizes any single interchangeable tool (Antigravity, Gemini CLI, specific IDEs) and focuses on **core terminal skills that transfer everywhere**.

These skills are the constant foundation. IDEs and agent frontends come and go. The terminal gives you:
- Precise, auditable, scriptable control
- Deep understanding of what is actually happening on your machine
- The ability to debug, automate, and integrate anything
- A "source of truth" layer that survives tool churn

This version is structured as a **learning box / curriculum** — clear modules with objectives, concepts, commands, exercises, pitfalls, and "why it matters for agentic coding / modern workflows". It is intentionally longer in the resources section so you can feed rich, high-quality references into NotebookLM for deeper dives, spaced repetition, or audio synthesis.

**How to use this as a learning system:**
1. Work module by module. Do the exercises in a dedicated `~/terminal-practice` folder.
2. After each module, note what felt fuzzy and feed the relevant resources into NotebookLM with a prompt like: "Explain [topic] in the context of using VS Code + Llama.cpp on macOS, with practical examples and common mistakes."
3. Revisit safety habits daily until they are automatic.
4. The goal is **fluency and confidence**, not memorizing every flag.

**Your current context incorporated:**
- You know basics (cd, ls, rm, touch, brew, npm/npx, uv, conda activate, &&, top, find, open) but want better recall and power-user depth.
- Heavy daily computer use but limited memorized keyboard shortcuts.
- Tech-savvy with GitHub, Shortcuts, local models (llama.cpp, MLX in quant-env), privacy focus.
- Want transferable skills, not lock-in to any one agent platform.

---

## Module 0: Mindset & The Universal Value of Terminal Fluency

### Learning Objectives
- Understand why terminal skills remain valuable even when you primarily use VS Code + local LLMs.
- Adopt a "verify first, act second" habit that protects you from agent hallucinations or your own mistakes.
- See the terminal as the control plane that works alongside (not instead of) any editor or agent.

### Core Concepts
The terminal is not "old school" or a fallback. It is the most direct, low-level, and composable interface to your operating system. Every GUI, every IDE (VS Code included), and every agent ultimately translates your intent into shell commands or file operations.

**Why it transfers across tools:**
- VS Code has an excellent integrated terminal + `code` command for launching from terminal.
- Llama.cpp runs best from terminal (building, server mode, inference scripts).
- Any future agent/IDE will still need to interact with files, processes, git, and the filesystem.
- When something breaks (and it will), the terminal is often the only place you can see the raw truth (logs, permissions, environment, exact commands that were run).

**The safety mindset (non-negotiable, tool-agnostic):**
macOS executes what you (or an agent acting on your behalf) type with no judgment. One bad `rm -rf` or path hallucination can be catastrophic. The habits in this guide protect you regardless of whether you're driving from VS Code, a CLI agent, or raw terminal.

### Key Habit to Install Immediately
Before any command that could modify files or run for a long time:
```bash
pwd && ls -la
```
This single habit has saved countless developers. Make it muscle memory.

### Exercise
1. Open Terminal.
2. Run `pwd && ls -la` in your home directory.
3. Create `mkdir -p ~/terminal-practice/module0 && cd ~/terminal-practice/module0`
4. Run the same check again. Notice how the output changes.
5. Write a one-sentence note: "What did I just learn about where commands actually execute?"

### Deeper Dive Resources (for NotebookLM)
- Search for general articles on "why learn the command line in 2026" or "terminal as universal interface for developers". Many emphasize that even with powerful IDEs and AI coding assistants, the ability to inspect and control the underlying system remains irreplaceable.
- Classic essay-style pieces on the philosophy of Unix tools and composability (pipes, small sharp tools) — these principles are why terminal skills survive tool changes.

---

## Module 1: Shell Fundamentals & Your Environment (zsh on macOS)

### Learning Objectives
- Understand what the shell is and why zsh is the default on modern macOS.
- Master the prompt, paths (absolute vs relative vs `~`), and the concept of "current working directory".
- Know how to inspect and manage your environment (PATH, variables, which command is actually running).

### Core Concepts
When you open Terminal, you are running `zsh` (Z Shell). It reads your commands, expands them, and asks the operating system to execute them.

**Critical mental model:**
- There is always a **current working directory** (shown by `pwd`).
- Almost everything is relative to that directory unless you use an absolute path starting with `/` or `~`.
- The shell has state: environment variables (`$PATH`, `$HOME`, `$EDITOR`, etc.), aliases, functions, history.

**Inspect your environment (run these now):**
```bash
echo $SHELL          # Should show /bin/zsh
which zsh
echo $PATH | tr ':' '\n'   # See where the shell looks for commands (order matters!)
which node             # Which node binary is actually being used?
which python3
sw_vers                # Your exact macOS version
```

**Paths explained simply:**
- `~` = your home directory (`/Users/pedroamaral` or whatever your username is)
- `.` = current directory
- `..` = parent directory
- `/` = root of the entire filesystem

### Essential Commands
```bash
pwd                  # Where am I right now? (Always ask this mentally)
cd ~/terminal-practice
cd ..                # Go up one level
cd -                 # Go back to the previous directory you were in
ls -la               # List everything, including hidden files (dotfiles) and permissions
tree -L 2            # Visual tree (brew install tree). Extremely useful for understanding structure.
```

### Common Pitfall
Running a command without checking `pwd` first. You think you're in your project folder but you're actually in `~` or somewhere else. This is how files get created in the wrong place or deleted accidentally.

### Exercise
1. Navigate into `~/terminal-practice/module1`
2. Create a nested structure: `mkdir -p src/components/ui && touch src/components/ui/Button.tsx`
3. Use `tree` or `ls -laR` to verify.
4. Use `cd ..` and `cd -` to practice moving around without getting lost.
5. Run `echo $HOME` and `echo ~` — notice they are usually the same.

### VS Code Integration Note
You can open the current folder in VS Code from terminal with:
```bash
code .
```
(Install the "code" command in VS Code via Command Palette > "Shell Command: Install 'code' command in PATH").

This is one of the highest-ROI terminal-to-editor bridges.

### Deeper Dive Resources (for NotebookLM)
- Official Apple Terminal documentation and zsh man pages (man zsh, man zshoptions).
- Articles explaining PATH, environment variables, and login vs interactive shells.
- Comparisons of zsh vs bash vs fish — understand the tradeoffs even if you stick with zsh.

---

## Module 2: File System Mastery & Safe Operations

### Learning Objectives
- Perform all common file operations confidently and safely.
- Understand permissions at a practical level (without needing to become a Unix expert).
- Build the habit of verifying before destructive actions.

### Core Commands (with safety emphasis)
**Creation & Inspection**
```bash
touch file.txt              # Create empty file or update timestamp
mkdir -p deeply/nested/dir  # Create nested directories safely
ls -la                      # Always inspect before acting
```

**Moving, Copying, Renaming**
```bash
cp original.txt backup.txt
mv oldname.txt newname.txt   # Also used for renaming
mv file.txt folder/          # Move into folder
```

**Viewing Content (better than opening in GUI sometimes)**
```bash
cat file.txt                 # For small files
less file.txt                # Paginated, searchable ( / to search, q to quit)
head -20 file.txt
tail -f logfile.log          # Follow live output (great for servers/logs)
```

**Deletion (the dangerous one)**
```bash
rm file.txt                  # We will alias this to be interactive
rm -rf folder/               # Recursive + force. Extremely dangerous without checks.
```

### The Safety Rails (Install These in ~/.zshrc — Core & Timeless)
These protect you no matter what tool or agent you use. Taken from sound practices and verified as effective.

Add to `~/.zshrc` (use `nano ~/.zshrc` or your preferred editor):

```bash
# Safety first — these have saved many people
setopt rm_star_silent
setopt rm_star_wait
alias rm='rm -i'
setopt noclobber               # Prevent > from overwriting existing files accidentally
alias chmod='chmod --preserve-root'

# Quality of life
alias ll='ls -la'
alias ..='cd ..'
alias gs='git status'
alias gd='git diff'

# History improvements
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
```

After editing: `source ~/.zshrc`

Test the protections.

### Permissions Basics (Practical Level)
```bash
ls -la                       # Look at the permission string: rwxr-xr-x etc.
chmod +x script.sh           # Make executable
# Avoid 777 unless you truly understand why (and even then, be very careful)
```

### Exercise
1. Create a test file and practice `cp`, `mv`, viewing with `less` and `tail -f`.
2. Deliberately try `echo "test" > existingfile.txt` after enabling `noclobber` — see it blocked.
3. Practice safe deletion with the interactive alias.
4. Use `ls -la` to inspect permissions on a few system files and your own files.

### Why This Matters for Any Workflow
When an agent (or you in a hurry) suggests a command, you can instantly evaluate: "Does this respect my current directory? Is it trying to delete recursively without checks? Will it overwrite something important?"

### Deeper Dive Resources (for NotebookLM)
- Classic Unix file permissions explanations (user/group/other, read/write/execute).
- Articles on "defensive shell practices" or "safe rm habits".
- man pages for chmod, chown, ls (the detail sections).

---

## Module 3: Streams, Pipes, Redirection & Text Processing Power

### Learning Objectives
- Master the three standard streams (stdin, stdout, stderr).
- Use pipes (`|`) and redirection (`>`, `>>`, `2>&1`) fluently.
- Appreciate why these are among the most powerful and transferable features in computing.

### Core Concepts
Every command has three streams:
- stdin (0) — input
- stdout (1) — normal output
- stderr (2) — errors and diagnostics

**The magic of pipes:** `command1 | command2` sends the output of the first as input to the second. This is how you compose small, focused tools into powerful workflows.

**Redirection examples:**
```bash
command > file.txt           # stdout to file (overwrite)
command >> file.txt          # append
command 2> errors.txt        # stderr to file
command 2>&1 | less          # combine stderr + stdout and page it
command | tee output.log     # see output on screen AND save to file
```

**Why this is still gold in 2026:**
Even with VS Code and fancy agents, when something fails you often need the raw combined output. Piping errors directly to a local model (llama.cpp) or a script for analysis is extremely powerful and works regardless of the frontend.

### Useful Text Processing Tools (Install via brew as needed)
```bash
grep "pattern" file          # Search (use ripgrep `rg` for speed in large projects)
rg "pattern" . --type ts     # ripgrep (brew install ripgrep) — faster, better defaults
awk, sed                     # Stream editors (powerful but have learning curve)
jq                           # JSON processor (brew install jq)
fd                           # Better find (brew install fd)
```

### Exercise
1. Run a command that produces both output and errors (e.g., a failing build or `ls nonexistent`).
2. Practice capturing: `command 2>&1 | tee combined.log`
3. Use `grep` or `rg` to filter logs.
4. Create a small pipeline: list files → filter by extension → count them.

### Agentic / Modern Workflow Connection
When using any coding agent or local model, being able to feed it clean, contextual output from your actual environment (via pipes) dramatically reduces hallucinations compared to copy-pasting snippets.

### Deeper Dive Resources (for NotebookLM)
- "The Linux Command Line" book by William E. Shotts (free online version available) — excellent chapters on I/O redirection and pipelines.
- Articles on "Unix philosophy" and composing small tools.
- ripgrep vs grep comparisons and advanced usage.

---

## Module 4: Processes, Jobs & Control

### Learning Objectives
- Understand foreground vs background processes.
- Control long-running commands without losing work.
- Kill or inspect processes when things go wrong.

### Key Commands & Shortcuts
```bash
Ctrl + C                   # Interrupt (stop) the current foreground process
Ctrl + Z                   # Suspend (pause) current process → use `fg` to resume or `bg` to background it
jobs                       # List suspended/background jobs
fg %1                      # Bring job 1 to foreground
bg %1                      # Continue job 1 in background
ps aux | grep something    # Find processes
kill PID                   # Terminate by process ID (use cautiously)
```

**In VS Code integrated terminal:** These shortcuts usually work the same.

### Exercise
1. Start a long-running command (e.g., `sleep 60` or a dev server).
2. Suspend it with Ctrl+Z, check `jobs`, resume with `fg`.
3. Practice finding and inspecting processes.

### Deeper Dive Resources
- Articles on job control in shells.
- `man jobs`, `man fg`, `man bg`, `man kill`.

---

## Module 5: Git from the Terminal (Your Safety Net)

Git is one of the most important tools you will ever use. Doing it from the terminal gives you full visibility and control.

### Essential Daily Loop (Do This Religiously)
```bash
git status                 # What changed?
git diff                   # Exact changes (review before committing)
git add .                  # Or be more selective
git commit -m "feat: clear message"
git push
```

**Safety commands:**
```bash
git restore .              # Discard uncommitted changes (great when an agent makes a mess)
git reset --hard HEAD~1    # Undo last commit + changes (use with extreme caution)
git log --oneline -10      # Recent history
```

### Exercise
1. Initialize a practice repo.
2. Make changes, review with diff, commit.
3. Deliberately make a bad change and use `git restore .` to recover cleanly.

### Why Terminal Git Matters
VS Code Git UI is convenient, but when you need to understand exactly what happened or recover from complex states, the terminal (or tools like lazygit) gives precision.

### Deeper Dive Resources
- Official Git documentation and "Pro Git" book (free).
- Articles on "defensive git" or common recovery scenarios.

---

## Module 6: Customization, Dotfiles & Your Personal Environment

### Learning Objectives
- Comfortably edit and maintain your `~/.zshrc`.
- Understand dotfiles and how to manage them portably.
- Add useful customizations without overcomplicating.

### Practical Steps
1. Edit `~/.zshrc` safely (always keep a backup: `cp ~/.zshrc ~/.zshrc.bak.$(date +%Y%m%d)`).
2. Add the safety section from Module 2 + any aliases you actually use.
3. Source it and test.

**Simple dotfiles approach (recommended for most people):**
- Create `~/dotfiles` repo (or use chezmoi if you want more advanced management later).
- Symlink your important configs (`~/.zshrc`, `~/.gitconfig`, etc.).
- This makes setting up new machines or recovering trivial.

### Useful Additions (Add Gradually)
- Better prompt (or install starship: `brew install starship` then `eval "$(starship init zsh)"` in .zshrc)
- Useful aliases and functions you reach for often.
- Completion improvements.

### Exercise
1. Add 3-5 aliases you will actually use (e.g., project shortcuts, safe commands).
2. Set up a basic dotfiles folder and symlink your zshrc.
3. Document in a README inside the dotfiles repo what each piece does.

### Deeper Dive Resources (for NotebookLM)
- Popular dotfiles repositories on GitHub (search "dotfiles" + "macos" + "zsh" sorted by stars) — study how others structure theirs, but keep yours minimal at first.
- Articles on "managing dotfiles with git" or chezmoi vs bare git repo approaches.
- Powerlevel10k or Starship configuration guides (if you want a pretty, informative prompt).

---

## Module 7: Keyboard Fluency & Readline Mastery

This directly addresses your note about only having ~8 shortcuts despite heavy use.

### High-Impact Shortcuts (Memorize These First)
**Line Editing (work in almost any terminal):**
- Ctrl+A : Beginning of line
- Ctrl+E : End of line
- Ctrl+U : Kill (cut) from cursor to start of line
- Ctrl+K : Kill from cursor to end of line
- Ctrl+W : Kill previous word
- Ctrl+Y : Yank (paste) what you just killed
- Ctrl+R : Reverse history search (type partial command to find it)
- Option+Left/Right or Esc+B/F : Move by word

**Terminal / Process:**
- Ctrl+C : Interrupt
- Ctrl+Z : Suspend
- Ctrl+L : Clear screen
- Ctrl+D : EOF / close shell

**macOS Terminal.app specific:**
- Cmd+T : New tab
- Cmd+Shift+[ / ] : Switch tabs
- Cmd+K : Clear screen

### Practice Drill
Type a long, incorrect command. Use the shortcuts to fix it quickly without retyping everything. Do this 5–10 times until it feels natural.

### Deeper Dive Resources
- Apple’s official Terminal keyboard shortcuts page.
- Readline documentation or cheat sheets for Emacs-style editing (what most shells use by default).

---

## Module 8: Working with VS Code + Llama.cpp from the Terminal

### VS Code Integration
```bash
code .                     # Open current folder in VS Code
code -r file.txt           # Open file in existing window
code --diff file1 file2    # Side-by-side diff
```

Use the integrated terminal in VS Code (it respects your zsh config if set up correctly). You can have the best of both worlds: GUI editing + terminal power.

### Llama.cpp Workflows (Core for Your Current Stack)
From your agent.md, you use llama.cpp for GGUF models with Metal.

Typical terminal patterns:
```bash
# Build / update (if needed)
cd ~/llama.cpp
make clean && make -j

# Run inference
./llama-cli -m ~/models/model.gguf -p "Your prompt here" -n 128

# Server mode (for local API)
./llama-server -m ~/models/model.gguf --port 8080

# With MLX (in your quant-env)
conda activate quant-env
python -m mlx_lm.generate --model mlx-community/some-model --prompt "..."
```

These commands are run from terminal. Fluency here lets you script, benchmark, and debug local model usage precisely.

### Exercise
1. Open a project folder from terminal into VS Code.
2. Run a simple llama.cpp inference or server command (adjust to your actual models/paths).
3. Practice switching between VS Code editing and terminal inspection.

### Deeper Dive Resources
- Official llama.cpp GitHub repository documentation and examples.
- VS Code terminal integration and tasks documentation.
- Articles on "terminal-driven development with VS Code".

---

## Module 9: Basic Scripting & Automation for Personal Use

You don't need to become a shell scripting expert, but knowing enough to write small personal scripts is extremely valuable.

### Simple Patterns
```bash
#!/bin/zsh
# backup-project.zsh
cd ~/Projects/my-important-project
git status
git add .
git commit -m "Automated backup $(date)"
git push
echo "Backup done"
```

Make executable: `chmod +x backup-project.zsh`

Run with `./backup-project.zsh` or add to PATH.

### Exercise
Write a small script that does something useful for you (e.g., update brew + node + clean, or a project-specific task) and test it safely.

### Deeper Dive Resources
- "The Linux Command Line" book chapters on scripting.
- Articles on "writing safe shell scripts" (set -euo pipefail, etc.).

---

## Module 10: Debugging & Troubleshooting Mindset (Tool-Agnostic)

When something breaks:
1. Check where you are (`pwd`)
2. Inspect what actually changed (`git status`, `git diff`, `ls -la`)
3. Look at logs with context (`tail -f`, `grep`, pipes)
4. Reproduce the minimal failing case
5. Verify environment (`which command`, `echo $VAR`, `env`)
6. Use version control to recover

This process works whether the issue came from VS Code, an agent, a local model, or your own command.

### Deeper Dive Resources
- Systematic debugging articles for developers.
- "How to ask good questions" when seeking help (include exact commands, output, what you expected, what happened).

---

## Ongoing Practice & Maintenance

- Daily: `pwd && ll` habit + `git status` before leaving a project.
- Weekly: Review and clean up aliases in .zshrc. Remove what you don't use.
- When setting up a new machine or recovering: Your dotfiles repo + this curriculum should get you back to a productive state quickly.
- Every time you feel friction: Ask "Is there a terminal command or small script that would make this faster/safer next time?"

---

## Comprehensive Resources for NotebookLM & Further Depth

This section is intentionally rich. Copy the URLs + short descriptions into NotebookLM along with this guide. Ask it to synthesize curricula, audio explanations, exercises, or comparisons tailored to "VS Code + Llama.cpp on macOS terminal workflows".

**Core Books & Long-Form (Timeless Foundations)**
- "The Linux Command Line" by William E. Shotts (free HTML version available online) — Best single resource for understanding shells, files, pipes, redirection, and basic scripting. Highly recommended as primary deeper dive.
- "Pro Git" book (free) — Excellent for terminal Git mastery beyond basics.

**Practical macOS + zsh Setup Guides (Recent)**
- YouTube: "How I Setup My Mac Terminal To Make It Amazing" / "The Perfect Zsh Setup For 2026" (various creators) — Visual walkthroughs of modern terminal customization.
- Medium/Dev.to articles on Oh My Zsh + Powerlevel10k or Starship for macOS (2025–2026 updates) — Good for prompt and plugin ideas once you have the safety foundation.
- Reddit threads on user-friendly zsh setups and dotfiles for macOS.

**Dotfiles & Customization Examples**
- Popular GitHub dotfiles repositories (search "dotfiles macos zsh" sorted by stars) — Study real-world examples of .zshrc, aliases, and management strategies. Start simple and borrow only what makes sense for you.
- zsh-abbr and other focused plugins (from GitHub) — For power-user abbreviation expansion without heavy frameworks.

**VS Code + Terminal Integration**
- Official VS Code documentation: "Integrated Terminal", "Using the code command", Tasks, and debugging in terminal.
- Articles on "terminal-driven development workflow with VS Code".

**Llama.cpp & Local Models from Terminal**
- Official llama.cpp GitHub repository (documentation, examples, server mode, Metal backend) — Primary source for running GGUF models efficiently on your M-series Mac.
- MLX documentation (Apple's framework) and examples for the quant-env workflow you already use.

**General Power User & Philosophy**
- Articles on Unix philosophy, small sharp tools, and composability via pipes — These explain *why* terminal skills remain powerful even in 2026.
- "Defensive computing" or "safe shell practices" pieces — Reinforce the verification habits in this guide.
- Keyboard shortcut deep dives and readline/Emacs-style editing explanations.

**Your Existing Materials (Still Valuable for Core Concepts)**
- The attached VibeCodingGuide.pdf and Agentic Coding Curriculum PDFs — Extract the timeless parts (terminal commands table, safety rails philosophy, Git loops, file operations) while ignoring tool-specific agent sections that no longer match your current VS Code + Llama.cpp preference.
- Your agent.md — Reference for your stack, permissions, and workspace hygiene rules. The terminal habits here support those guardrails.

**How to Use These with NotebookLM**
Upload this v2 guide + the resources list + key PDFs. Prompt examples:
- "Create a 7-day progressive practice plan focused on terminal + VS Code + Llama.cpp workflows for a Mac user who knows basics but wants fluency and safety."
- "Explain pipes, redirection, and text processing in the context of debugging local LLM inference and agent-generated code."
- "Generate spaced-repetition flashcards for the most important keyboard shortcuts and safety habits."
- "Compare Oh My Zsh vs minimal custom .zshrc approaches and recommend a conservative path for someone who values stability and low maintenance."

---

## Final Notes

This curriculum prioritizes **core, transferable skills** over any specific trendy tool. The safety habits, file system fluency, pipes/redirection mastery, Git discipline, keyboard shortcuts, and verification mindset will serve you whether you're in VS Code with Llama.cpp today, back with a different agent tomorrow, or using something entirely new in 2027.

The terminal is your control layer. Master it once, and it amplifies every other tool you use.

Start with Module 0 and the safety rails in Module 2. Do the exercises. Feed the resources into NotebookLM as you go for deeper explanations tailored to your setup.

If you want me to expand any module into more detailed exercises, create companion scripts, or adjust the tone/focus further, just say the word. This is designed to be a living learning box that grows with your needs.

You've got this. Terminal fluency is one of the highest-leverage skills you can build as a technical power user.
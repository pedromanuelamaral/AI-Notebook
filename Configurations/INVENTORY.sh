#!/bin/bash
set -u
OUT="$HOME/Documents/AI-Files/system-inventory_$(date +%F).txt"
mkdir -p "$(dirname "$OUT")"

section() { printf '\n\n========== %s ==========\n' "$1"; }
cmd() { command -v "$1" >/dev/null 2>&1; }
show_file() {
  [ -f "$1" ] || return
  echo "--- $1 ---"
  sed -E '/(api[_-]?key|token|secret|password|authorization|bearer|credential)/Id' "$1"
}

{
  section "Snapshot"
  date -Iseconds
  echo "User: $USER"
  echo "Home: $HOME"

  section "macOS and hardware"
  sw_vers 2>/dev/null
  uname -a
  system_profiler SPHardwareDataType 2>/dev/null

  section "Shell and PATH"
  echo "Shell: $SHELL"
  echo "Login shell: $(dscl . -read "/Users/$USER" UserShell 2>/dev/null)"
  printf '%s\n' "$PATH" | tr ':' '\n' | nl -ba
  echo "PATH executables and symlinks:"
  IFS=: read -ra dirs <<< "$PATH"
  for d in "${dirs[@]}"; do
    [ -d "$d" ] && find "$d" -maxdepth 1 -type l -exec ls -l {} \; 2>/dev/null
  done
  for f in "$HOME/.zshenv" "$HOME/.zprofile" "$HOME/.zshrc" "$HOME/.zlogin" "$HOME/.bash_profile" "$HOME/.bashrc"; do
    show_file "$f"
  done

  section "Homebrew"
  if cmd brew; then
    brew --version
    echo "--- Formulae ---"; brew list --versions
    echo "--- Casks ---"; brew list --cask
    echo "--- Services ---"; brew services list
    echo "--- Outdated ---"; brew outdated
  fi

  section "Python"
  type -a python python3 pip pip3 2>/dev/null || true
  for p in python python3 python3.11 python3.12 python3.13 python3.14; do
    if cmd "$p"; then
      echo "--- $p ---"
      "$p" --version
      "$p" -m pip --version 2>/dev/null
      "$p" -m pip list --format=freeze 2>/dev/null
      "$p" -m site 2>/dev/null
    fi
  done
  cmd uv && { echo "--- uv ---"; uv --version; uv tool list; }
  cmd pipx && { echo "--- pipx ---"; pipx list; }
  cmd conda && { echo "--- conda ---"; conda --version; conda env list; }
  cmd pyenv && { echo "--- pyenv ---"; pyenv versions; }

  section "Node and JavaScript"
  type -a node npm npx pnpm yarn bun 2>/dev/null || true
  cmd node && node --version
  cmd npm && { npm --version; npm list -g --depth=0; }
  cmd corepack && corepack --version
  [ -d "$HOME/.nvm" ] && { echo "--- nvm versions ---"; find "$HOME/.nvm/versions/node" -maxdepth 1 -mindepth 1 -type d 2>/dev/null; }
  cmd bun && bun --version

  section "Other language tooling"
  cmd rustc && rustc --version
  cmd cargo && { cargo --version; cargo install --list; }
  cmd go && { go version; go env GOPATH GOROOT; }
  cmd java && java -version
  cmd ruby && { ruby -v; gem list --local; }

  section "VS Code"
  cmd code && { code --version; code --list-extensions --show-versions; code --status; }
  show_file "$HOME/Library/Application Support/Code/User/settings.json"
  show_file "$HOME/Library/Application Support/Code/User/keybindings.json"
  echo "--- Profiles ---"
  find "$HOME/Library/Application Support/Code/User/profiles" -maxdepth 2 -type f 2>/dev/null
  echo "--- Extensions ---"
  find "$HOME/.vscode/extensions" -maxdepth 1 -mindepth 1 -type d -printf '%f\n' 2>/dev/null || \
    find "$HOME/.vscode/extensions" -maxdepth 1 -mindepth 1 -type d 2>/dev/null

  section "AI tools, models, and MCP configuration"
  for x in codex claude gemini ollama llama-cli llama-server lmstudio hf; do
    cmd "$x" && { echo "--- $x ---"; "$x" --version 2>&1 | head -20; }
  done
  echo "--- Model directories (names and sizes only) ---"
  for d in "$HOME/models" "$HOME/.cache/huggingface/hub" "$HOME/.ollama/models"; do
    [ -d "$d" ] && { echo "--- $d ---"; du -sh "$d" 2>/dev/null; find "$d" -maxdepth 2 -type f \( -name '*.gguf' -o -name '*.safetensors' -o -name '*.mlx' \) -exec ls -lh {} \; 2>/dev/null; }
  done
  echo "--- AI/MCP config file paths ---"
  find "$HOME/.codex" "$HOME/.claude" "$HOME/.gemini" "$HOME/.continue" "$HOME/.config" \
    -maxdepth 4 -type f \( -iname '*mcp*.json' -o -iname 'config.json' -o -iname 'settings.json' \) \
    2>/dev/null

  section "Git and SSH metadata"
  cmd git && { git --version; git config --global --list | sed -E '/(token|password|secret)/Id'; }
  find "$HOME/.ssh" -maxdepth 1 -type f -not -name '*.pub' -not -name 'known_hosts' -exec basename {} \; 2>/dev/null
  find "$HOME/.ssh" -maxdepth 1 -type f -name '*.pub' -exec basename {} \; 2>/dev/null

  section "Applications and background services"
  find /Applications "$HOME/Applications" -maxdepth 1 -name '*.app' -printf '%f\n' 2>/dev/null || \
    find /Applications "$HOME/Applications" -maxdepth 1 -name '*.app' 2>/dev/null
  echo "--- User LaunchAgents ---"
  find "$HOME/Library/LaunchAgents" -maxdepth 1 -type f -name '*.plist' -printf '%f\n' 2>/dev/null || true
  echo "--- Cron ---"
  crontab -l 2>/dev/null || true

  section "Environment variable names only"
  env | cut -d= -f1 | sort
} > "$OUT" 2>&1

echo "Inventory written to: $OUT"
open "$OUT"

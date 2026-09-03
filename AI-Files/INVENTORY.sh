#!/bin/bash
set -Eeuo pipefail

OUT="${OUT:-${1:-${HOME:-$PWD}/Documents}/AI-Files/system-inventory_$(date +%F_%H%M%S).txt}"
mkdir -p "$(dirname "$OUT")" || { echo "Cannot create output directory" >&2; exit 1; }
umask 077
TMP_OUT="$(mktemp "$(dirname "$OUT")/system-inventory.XXXXXX")" || { echo "Cannot create temp file" >&2; exit 1; }
trap 'rc=$?; if [ "${rc}" -ne 0 ] && [ -n "${TMP_OUT:-}" ] && [ -f "${TMP_OUT}" ]; then rm -f "${TMP_OUT}"; fi; exit "${rc}"' EXIT

section() {
  printf '\n\n========== %s ==========\n' "$1"
}

cmd() {
  command -v "$1" >/dev/null 2>&1
}

redact_file() {
  local file="$1"
  [[ -f "$file" ]] || return 0

  echo "--- $file ---"

  sed -E -f - "$file" 2>/dev/null <<'SED' || true
s/("?(api[_-]?key|token|secret|password|authorization|bearer|credential|access_token|refresh_token|client_secret|private_key|session_key)"?[[:space:]]*:[[:space:]]*"?)([^"]*)("?)/\1[REDACTED]\4/Ig
s/(Authorization[[:space:]]*:[[:space:]]*["']?)Bearer[[:space:]]+[A-Za-z0-9._~+/=-]+/\1[REDACTED]/I
s/(Authorization[[:space:]]*:[[:space:]]*["']?)([A-Za-z0-9._~+/=-]+)/\1[REDACTED]/I
s/(api[_-]?key|token|secret|password|authorization|bearer|credential|access_token|refresh_token|client_secret|private_key|session_key)[[:space:]]*=[[:space:]]*[^[:space:]]+/\1=[REDACTED]/Ig
SED
}

print_if_exists() {
  local p="$1"
  [[ -e "$p" ]] && echo "--- $p ---" && ls -ld "$p" 2>/dev/null || true
}

# Main capture
{
  section "Snapshot"
  date -Iseconds
  echo "User: ${USER:-unknown}"
  echo "Home: ${HOME:-unknown}"
  echo "Hostname: $(hostname 2>/dev/null || echo unknown)"
  echo "OS: $(uname -srm 2>/dev/null || echo unknown)"

  section "macOS and hardware"
  sw_vers 2>/dev/null || true
  uname -a 2>/dev/null || true
  if cmd system_profiler; then
    system_profiler SPHardwareDataType 2>/dev/null || true
    system_profiler SPSoftwareDataType 2>/dev/null || true
  fi

  section "Shell and PATH"
  echo "Shell: ${SHELL:-unknown}"
  if cmd dscl; then
    login_shell=$({ dscl . -read "/Users/${USER}" UserShell 2>/dev/null || dscl . -read "/Local/Default/Users/${USER}" UserShell 2>/dev/null || echo ""; } | awk '{print $2}')
  else
    login_shell=""
  fi
  echo "Login shell: ${login_shell:-unknown}"
  printf '%s\n' "${PATH:-}" | tr ':' '\n' | nl -ba 2>/dev/null || echo "PATH listing failed"
  echo "PATH executables and symlinks:"
  IFS=':' read -ra dirs <<< "${PATH:-}"
  for d in "${dirs[@]}"; do
    [[ -d "$d" ]] || continue
    find "$d" -maxdepth 1 -type l -exec ls -l {} \; 2>/dev/null || true
  done

  for f in \
    "$HOME/.zshenv" "$HOME/.zprofile" "$HOME/.zshrc" "$HOME/.zlogin" \
    "$HOME/.bash_profile" "$HOME/.bashrc" \
    "$HOME/.profile" "$HOME/.config/fish/config.fish"
  do
    redact_file "$f" || true
  done

  section "Homebrew"
  if cmd brew; then
    brew --version 2>/dev/null || true
    echo "--- Formulae ---"
    brew list --versions 2>/dev/null || true
    echo "--- Casks ---"
    brew list --cask 2>/dev/null || true
    echo "--- Services ---"
    brew services list 2>/dev/null || true
    echo "--- Outdated ---"
    brew outdated 2>/dev/null || true
  else
    echo "Homebrew not installed"
  fi

  section "Python"
  type -a python python3 pip pip3 2>/dev/null || true
  for p in python python3 python3.11 python3.12 python3.13 python3.14; do
    if cmd "$p"; then
      echo "--- $p ---"
      "$p" --version 2>/dev/null || true
      "$p" -m pip --version 2>/dev/null || true
      "$p" -m pip list --format=freeze 2>/dev/null || true
      "$p" -m site 2>/dev/null || true
    fi
  done
  if cmd uv; then
    echo "--- uv ---"
    uv --version 2>/dev/null || true
    uv tool list 2>/dev/null || true
  fi
  if cmd pipx; then
    echo "--- pipx ---"
    pipx list 2>/dev/null || true
  fi
  if cmd conda; then
    echo "--- conda ---"
    conda --version 2>/dev/null || true
    conda env list 2>/dev/null || true
  fi
  if cmd pyenv; then
    echo "--- pyenv ---"
    pyenv versions 2>/dev/null || true
  fi

  section "Node and JS"
  type -a node npm npx pnpm yarn bun 2>/dev/null || true
  if cmd node; then node --version 2>/dev/null || true; fi
  if cmd npm; then npm --version 2>/dev/null || true; npm list -g --depth=0 2>/dev/null || true; fi
  if cmd corepack; then corepack --version 2>/dev/null || true; fi
  if [[ -d "$HOME/.nvm" ]]; then
    echo "--- nvm versions ---"
    find "$HOME/.nvm/versions/node" -maxdepth 1 -mindepth 1 -type d 2>/dev/null || true
  fi
  if cmd bun; then bun --version 2>/dev/null || true; fi

  section "Other language tooling"
  if cmd rustc; then rustc --version 2>/dev/null || true; fi
  if cmd cargo; then cargo --version 2>/dev/null || true; cargo install --list 2>/dev/null || true; fi
  if cmd go; then go version 2>/dev/null || true; go env GOPATH GOROOT 2>/dev/null || true; fi
  if cmd java; then java -version 2>&1 || true; fi
  if cmd ruby; then ruby -v 2>/dev/null || true; gem list --local 2>/dev/null || true; fi

  section "VS Code"
  if cmd code; then
    code --version 2>/dev/null || true
    code --list-extensions --show-versions 2>/dev/null || true
    code --status 2>/dev/null || true
  fi

  for f in \
    "$HOME/Library/Application Support/Code/User/settings.json" \
    "$HOME/Library/Application Support/Code/User/keybindings.json" \
    "$HOME/Library/Application Support/Code/User/tasks.json" \
    "$HOME/Library/Application Support/Code/User/state.vscdb"
  do
    redact_file "$f" || true
  done

  echo "--- Profiles ---"
  find "$HOME/Library/Application Support/Code/User/profiles" -maxdepth 2 -type f 2>/dev/null || true

  echo "--- VS Code extension directories ---"
  if [[ -d "$HOME/.vscode/extensions" ]]; then
    find "$HOME/.vscode/extensions" -maxdepth 1 -mindepth 1 -type d 2>/dev/null \
      -exec basename {} \; | sort || true
  fi

  section "AI tools, models, and MCP configuration"
  for x in codex claude gemini ollama llama-cli llama-server lmstudio hf; do
    if cmd "$x"; then
      echo "--- $x ---"
      "$x" --version 2>&1 | head -20 || true
    fi
  done

  echo "--- Model directories (names and sizes only) ---"
  for d in \
    "$HOME/models" \
    "$HOME/.cache/huggingface/hub" \
    "$HOME/.ollama/models" \
    "$HOME/.cache/ollama"
  do
    [[ -d "$d" ]] || continue
    echo "--- $d ---"
    du -sh "$d" 2>/dev/null || true
    find "$d" -maxdepth 2 -type f \( -iname '*.gguf' -o -iname '*.safetensors' -o -iname '*.mlx' \) \
      -exec ls -lh {} \; 2>/dev/null || true
  done

  echo "--- AI/MCP config file paths ---"
  for base in \
    "$HOME/.codex" "$HOME/.claude" "$HOME/.gemini" "$HOME/.continue" \
    "$HOME/.config" "$HOME/Library/Application Support/Code/User/globalStorage"
  do
    [[ -d "$base" ]] || continue
    find "$base" -maxdepth 4 -type f \( \
      -iname '*mcp*.json' -o -iname 'config.json' -o -iname 'settings.json' -o -iname '*.yaml' -o -iname '*.yml' \
    \) 2>/dev/null || true
  done

  section "Git and SSH metadata"
  if cmd git; then
    git --version 2>/dev/null || true
    git config --global --list 2>/dev/null | sed -E '/(token|password|secret|authorization|bearer|client_secret|private_key)/Id' || true
  fi

  echo "--- SSH files ---"
  if [[ -d "$HOME/.ssh" ]]; then
    find "$HOME/.ssh" -maxdepth 1 -type f -not -name '*.pub' -not -name 'known_hosts' -exec basename {} \; 2>/dev/null || true
    find "$HOME/.ssh" -maxdepth 1 -type f -name '*.pub' -exec basename {} \; 2>/dev/null || true
  fi

  section "Applications and background services"
  echo "--- Installed .app bundles ---"
  find /Applications "$HOME/Applications" -maxdepth 1 -name '*.app' 2>/dev/null \
    -exec basename {} \; | sort || true

  echo "--- User LaunchAgents ---"
  find "$HOME/Library/LaunchAgents" -maxdepth 1 -type f -name '*.plist' 2>/dev/null \
    -exec basename {} \; | sort || true

  echo "--- Cron ---"
  crontab -l 2>/dev/null || true

  section "Environment variable names only"
  env | cut -d= -f1 | sort 2>/dev/null || true

  section "Summary"
  echo "Snapshot written to: $TMP_OUT"
} > "$TMP_OUT" 2>&1

mv "$TMP_OUT" "$OUT" || { echo "Failed to move temp output to $OUT" >&2; exit 1; }

echo "Inventory written to: $OUT"
if cmd open; then
  open "$OUT" 2>/dev/null || true
fi

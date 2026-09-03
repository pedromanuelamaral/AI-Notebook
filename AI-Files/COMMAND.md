
# 📦 Package Manager Command Matrix

---

## **aria2c** *(Download Manager)*
- **List Version:** `aria2c --version`
- **Check Outdated:** `brew outdated aria2c`
- **Check Safety:** *(N/A – stateless)*
- **Inspect Cache:** `du -sh ~/.aria2/`
- **General Cleanup:** `rm -rf ~/.aria2/session*`
- **Purge Cache / Failed Downloads:** `rm -rf ~/.aria2/*`
- **Upgrade:** `brew upgrade aria2c`
- **Upgrade Specific Version:** `brew install aria2c@<version>`
- **Self Update:** `brew upgrade aria2c`

---

## **Bun** *(JS Runtime)*
- **List All Installed:** `bun pm ls`
- **Check Outdated:** `bunx npm-check-updates -g`
- **Check Safety:** `bun pm bin`
- **Inspect Cache:** `echo ~/.bun/install/cache`
- **General Cleanup:** `bun pm cache rm`
- **Purge Cache / Failed Downloads:** `bun pm cache rm`
- **Upgrade All:** `bun update`
- **Upgrade Specific Version:** `bun add <package>@<version>`
- **Self Update:** `bun upgrade`

---

## **conda** *(Python Environments)*
- **List All Installed:** `conda list`
- **List Environments:** `conda env list`
- **Check Outdated:** `conda list --outdated`
- **Check Safety:** `conda verify`
- **Inspect Cache:** `conda info`
- **General Cleanup:** `conda clean --all`
- **Purge Cache / Failed Downloads:** `conda clean --index-cache --pkgs --tarballs --temp`
- **Upgrade All:** `conda update --all`
- **Upgrade Specific Version:** `conda install <package>=<version>`
- **Self Update:** `conda update conda`

---

## **cURL** *(HTTP Client)*
- **List Version:** `curl --version`
- **Check Outdated:** `brew outdated curl`
- **Check Safety:** `curl --diagnose https://example.com`
- **Inspect Cache:** *(Stateless)*
- **General Cleanup:** *(N/A)*
- **Purge Cache / Failed Downloads:** `rm -f ~/.curl_hsts`
- **Upgrade:** `brew upgrade curl`
- **Upgrade Specific Version:** `brew install curl@<version>`
- **Self Update:** *(via `brew upgrade curl`)*

---

## **Docker** *(Containers)*
- **List All Images/Containers:** `docker images -a && docker ps -a`
- **Check Outdated:** `docker run --rm -v /var/run/docker.sock:/var/run/docker.sock v2tec/watchtower --check-only`
- **Check Safety:** `docker system info`
- **Inspect Cache:** `docker system df`
- **General Cleanup:** `docker system prune -f`
- **Purge Cache / Failed Downloads:** `docker system prune -a --volumes --force`
- **Upgrade All Active:** `docker ps --format "{{.Image}}" | xargs -n1 docker pull`
- **Pull Specific Image:** `docker pull <image_name>:<tag_version>`
- **Self Update:** *(macOS: Menu Bar GUI)*

---
---
## **Git** *(Version Control)*
- **List Configs/Repos:** `git config --list --show-origin`
- **Check Outdated:** `git fetch --dry-run --all`
- **Check Safety:** `git fsck --full --strict`
- **Inspect Cache:** `git clean -ndx` *(dry run)*
- **General Cleanup:** `git gc --prune=now --aggressive`
- **Purge Cache / Failed Downloads:** `git clean -fdx`
- **Upgrade All Submodules:** `git submodule update --remote --merge`
- **Upgrade Specific Version:** `git reset --hard <commit_hash_or_tag>`
- **Self Update:** `brew upgrade git`

---
---
## **Go** *(Golang)*
- **List All Installed:** `ls $(go env GOPATH)/bin`
- **Check Outdated:** `go list -m -u all`
- **Check Safety:** `go vet ./... && go bug`
- **Inspect Cache:** `go env GOCACHE`
- **General Cleanup:** `go clean -modcache`
- **Purge Cache / Failed Downloads:** `go clean -cache -testcache -fuzzcache`
- **Upgrade All:** `go get -u ./...`
- **Upgrade Specific Version:** `go get <module_path>@v<version>`
- **Self Update:** `brew upgrade go`

---
---
## **Hugging Face CLI** *(hf/huggingface-cli)*
- **List Models:** `huggingface-cli repo list`
- **List Local Cache:** `huggingface-cli scan-cache`
- **Check Outdated:** *(Per-repo: check remote vs. local)*
- **Check Safety:** `huggingface-cli whoami`
- **Inspect Cache:** `huggingface-cli scan-cache`
- **General Cleanup:** `huggingface-cli delete-cache`
- **Purge Cache / Failed Downloads:** `huggingface-cli delete-cache --all`
- **Upgrade Specific Model:** `huggingface-cli pull <repo> --force-download`
- **Self Update:** `pip install --upgrade huggingface_hub` *(or `uv pip install --upgrade huggingface_hub`)*

---
---
## **Homebrew** *(macOS)*
- **List All Installed:** `brew list --versions`
- **Check Outdated:** `brew outdated`
- **Check Safety:** `brew doctor`
- **Inspect Cache:** `du -sh $(brew --cache)`
- **General Cleanup:** `brew cleanup -s`
- **Purge Cache / Failed Downloads:** `rm -rf $(brew --cache)/*`
- **Upgrade All:** `brew upgrade`
- **Upgrade Specific Version:** `brew install <formula>@<version>`
- **Self Update:** `brew update`

---
---
## **NPM** *(Node.js)*
- **List All Installed (Global):** `npm list -g --depth=0`
- **Check Outdated:** `npm outdated -g`
- **Check Safety:** `npm audit`
- **Inspect Cache:** `npm cache verify`
- **General Cleanup:** `npm prune`
- **Purge Cache / Failed Downloads:** `npm cache clean --force`
- **Upgrade All:** `npm update -g`
- **Upgrade Specific Version:** `npm install -g <package_name>@<version>`
- **Self Update:** `npm install -g npm@latest`

---
---
## **Pip / Pip3** *(Python)*
- **List All Installed:** `pip list` / `pip3 list`
- **Check Outdated:** `pip list --outdated` / `pip3 list --outdated`
- **Check Safety:** `pip check` / `pip3 check`
- **Inspect Cache:** `pip cache info` / `pip3 cache info`
- **General Cleanup:** `pip cache purge` / `pip3 cache purge`
- **Purge Cache / Failed Downloads:** `rm -rf ~/Library/Caches/pip`
- **Upgrade All:** `pip list --outdated --format=freeze | cut -d= -f1 | xargs -n1 pip install -U`
- **Upgrade Specific Version:** `pip install <package_name>==<version>`
- **Self Update:** `python3 -m pip install --upgrade pip`

---
---
## **Python** *(Core)*
- **Check Version:** `python --version` / `python3 --version`
- **List Installed Packages:** `python -m pip list`
- **Check Outdated Packages:** `python -m pip list --outdated`
- **Check Integrity:** `python -m pip check`
- **Inspect Site-Packages:** `python -c "import site; print(site.getsitepackages())"`
- **General Cleanup:** `python -m pip cache purge`
- **Find Cache Directory:** `python -c "import pip; print(pip.get_pip_cache_dir())"`
- **Purge Cache:** `rm -rf ~/Library/Caches/pip`
- **Upgrade All Packages:** `python -m pip list --outdated --format=freeze | cut -d= -f1 | xargs -n1 python -m pip install -U`
- **Self Update:** `python -m pip install --upgrade pip`

---
---
## **Ruby Gem** *(Ruby)*
- **List All Installed:** `gem list --local`
- **Check Outdated:** `gem outdated`
- **Check Safety:** `gem pristine --all`
- **Inspect Cache:** `ls ~/.gem/specs/`
- **General Cleanup:** `gem cleanup`
- **Purge Cache / Failed Downloads:** `rm -rf ~/.gem/specs/*`
- **Upgrade All:** `gem update`
- **Upgrade Specific Version:** `gem install <gem_name> -v <version>`
- **Self Update:** `gem update --system`

---
---
## **Scripts** *(Custom/Shell)*
- **List All Scripts:** `ls ~/scripts/` *(or custom path)*
- **Check Syntax Safety:** `bash -n ~/scripts/*.sh`
- **Inspect Cache:** *(N/A – depends on script type)*
- **General Cleanup:** `rm ~/scripts/*.sh~` *(remove backups)*
- **Purge Cache:** `rm -rf ~/scripts/__pycache__/` *(Python)* or `rm -rf ~/scripts/node_modules/` *(Node)*
- **Upgrade:** *(Manual or via `git pull` if in a repo)*
- **Self Update:** *(Manual)*
- **Docker Pull All:** `docker-compose pull` *(or `docker compose pull` for newer versions)*

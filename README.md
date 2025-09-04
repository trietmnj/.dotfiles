# .dotfiles

A streamlined, **idempotent** setup for a Linux/WSL development environment using **Oh My Fish**, **tmux**, and **Neovim**—plus language toolchains (Rust, Node.js), R, TeX Live, and **Python via uv**.

> Target: Ubuntu/WSL (works on Debian-based).
> Assumes your dotfiles repo layout is compatible with `stow` (e.g., `fish/`, `nvim/`, `tmux/`, etc.).

---

## 1. System Prep

Update base system and install common tooling:

```bash
sudo apt update
sudo apt install -y \
  build-essential curl git unzip ca-certificates \
  ripgrep fd-find universal-ctags \
  stow
```

- `ripgrep`, `fd-find`, and `universal-ctags` are used by many Neovim configs.j
- `unzip` fixes failures like `Could not find executable "unzip"` during tool installs.

Install fonts from `fonts/` and set Windows Terminal to use a Nerd Font (e.g., FiraCode NF).

---

## 2. Shell: Fish + Oh My Fish

2a. Install **Oh My Fish**:

```bash
curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
```

2b. Set Fish as the default shell:

```bash
chsh -s /usr/bin/fish
```

2c. Set theme **neolambda**:

```fish
omf install neolambda
omf theme neolambda
```

---

## 3. tmux + TPM

3a. Install **TPM** (Tmux Plugin Manager):

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

3b. Ensure `~/.tmux.conf` includes:

```tmux
set -g @plugin 'tmux-plugins/tpm'
run -b '~/.tmux/plugins/tpm/tpm'
```

3c. Install plugins inside tmux:

```text
tmux
Ctrl + b   I
```

---

## 4. Neovim + Tooling

4a. Install dependencies:

```bash
sudo apt install -y gcc ripgrep fd-find universal-ctags unzip
```

4b. Install formatters & plugin bridges:

```bash
cargo install stylua        # Lua formatter
npm install -g neovim       # Node bridge for NVim
```

> If `cargo` not found, see [7.1 Rust](#71-rust) first.

4c. Install Treesitter grammars (inside Neovim):

```vim
:TSInstall <language>
```

---

## 5. Windows Clipboard (win32yank) for WSL

5a. Copy `win32yank-x64/` to Windows (e.g., `C:\Applications\win32yank-x64\`).

5b. Ensure executable permissions from WSL:

```bash
chmod +x /mnt/c/Applications/win32yank-x64/win32yank.exe
```

5c. Point Neovim config to correct clipboard provider.

---

## 6. Dotfile Symlinks with GNU Stow

From your dotfiles repo root:

```bash
./install.sh
```

Restow after changes:

```bash
stow -R -v fish nvim tmux
```

Unlink:

```bash
stow -D -v fish nvim tmux
```

---

## 7. Languages & Runtimes

### 7.1 Rust

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"
```

### 7.2 Node.js (22.x)

```bash
sudo apt remove -y nodejs || true
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt install -y nodejs

# Optional yarn through corepack
npm install -g corepack
corepack enable
```

### 7.3 Python (uv)

**uv** replaces most uses of `pip`, `pipx`, and `virtualenv` with a single, fast tool.

7.3a. Install **uv**:

```bash
curl -Ls https://astral.sh/uv/install.sh | sh
```

Make sure `~/.local/bin` is on your PATH (Fish):

```fish
set -U fish_user_paths $HOME/.local/bin $fish_user_paths
```

7.3b. Neovim Python provider (isolated venv):

```bash
uv venv ~/.venvs/nvim
source ~/.venvs/nvim/bin/activate
uv pip install -U pip setuptools wheel pynvim
deactivate
```

In your `init.lua` (or `init.vim`) point NVim to this provider:

```lua
vim.g.python3_host_prog = os.getenv("HOME") .. "/.venvs/nvim/bin/python"
```

7.3c. Per‑project workflow with uv:

```bash
# create a project venv
uv venv .venv
# install deps (pyproject.toml / requirements.txt supported)
uv pip install -r requirements.txt
# run scripts via the project venv
uv run python your_script.py
```

7.3d. One‑shot tools with **uvx** (no global installs):

```bash
# Linters/formatters
uvx ruff --version
uvx black --version

# Tests
uvx pytest -q

# Vim script linter
uvx --from vim-vint vint --version
```

> Tips:
> • Use `uv run` to execute commands inside the project venv without activating it.
> • `uv lock` can generate a lockfile for reproducible installs if you’re using `pyproject.toml`.

### 7.4 R

```bash
sudo apt install -y r-base libcurl4-openssl-dev libssl-dev libxml2-dev
R -q -e 'install.packages(c("languageserver","lintr","styler","jsonlite"), repos="https://cloud.r-project.org")'
```

In R:

```r
install.packages("xml2")
install.packages("roxygen2")
install.packages("lintr")
```

`nvim-R` requires `latexmk`, which needs `tlmgr`

```bash
sudo tlmgr install latexmk
```

### 7.5 Java

```bash
sudo apt install -y openjdk-21-jdk
```

---

## 8. LaTeX / TeX Live

### 8a. Install via TUG (recommended)

```bash
cd /tmp
wget https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
tar xzf install-tl-unx.tar.gz
cd install-tl-*
./install-tl --no-interaction --texdir="$HOME/texlive/2025" --texuserdir="$HOME/texmf"
```

Add to PATH (Fish):

```fish
set -Ux PATH $HOME/texlive/2025/bin/x86_64-linux $PATH
```

Update and install latexmk:

```bash
tlmgr update --self
tlmgr install latexmk
```

### 8b. Change mirror

```bash
tlmgr option repository https://mirror.ctan.org/systems/texlive/tlnet
```

### 8c. Usage

Clean intermediate files

```bash
latexmk -c
```

---

## 9. Troubleshooting & Maintenance

- **Package failures**:
  ```bash
  sudo apt update --fix-missing
  sudo apt -f install
  ```
- **Oh My Fish not found** → run `exec fish`
- **Stylua fails** → ensure Rust + unzip installed
- **Treesitter errors** → `:TSUpdate` inside NVim
- **Clipboard issues (WSL)** → check `chmod +x` and config path
- **uv tips**:
  - `uv tool` state lives under `~/.cache/uv`; clear if needed.
  - Use `uv pip list` to inspect env packages.
  - Prefer `uv run` and `uvx` over activating environments.

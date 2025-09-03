# .dotfiles

A streamlined, **idempotent** setup for a Linux/WSL development environment using **Oh My Fish**, **tmux**, and **Neovim**—plus language toolchains (Rust, Node.js), R, and TeX Live.

> Target: Ubuntu/WSL (works on Debian-based).
> Assumes your dotfiles repo layout is compatible with `stow` (e.g., `fish/`, `nvim/`, `tmux/`, etc.).

---

## Table of Contents

1. [System Prep](#system-prep)
2. [Shell: Fish + Oh My Fish](#shell-fish--oh-my-fish)
3. [tmux + TPM](#tmux--tpm)
4. [Neovim + Tooling](#neovim--tooling)
5. [Windows Clipboard (win32yank) for WSL](#windows-clipboard-win32yank-for-wsl)
6. [Dotfile Symlinks with GNU Stow](#dotfile-symlinks-with-gnu-stow)
7. [Languages & Runtimes](#languages--runtimes)
   - [Rust](#rust)
   - [Node.js (LTS/Current)](#nodejs-ltscurrent)
   - [Python basics](#python-basics)
   - [R](#r)
   - [Java](#java)
8. [LaTeX / TeX Live](#latex--tex-live)
9. [Troubleshooting & Maintenance](#troubleshooting--maintenance)

---

## System Prep

Update base system and install common tooling:

```bash
sudo apt update
sudo apt install -y \
  build-essential curl git unzip ca-certificates \
  ripgrep fd-find universal-ctags \
  stow
```

- `ripgrep`, `fd-find`, and `universal-ctags` are used by many Neovim configs.
- `unzip` fixes failures like `Could not find executable "unzip"` during tool installs.

---

## Shell: Fish + Oh My Fish

Install **Oh My Fish** and set Fish default:

```bash
# Install Oh My Fish
curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish

# Make fish your default shell (path may vary; confirm with `which fish`)
chsh -s /usr/bin/fish
```

Set the theme to **neolambda**:

```fish
# In fish
omf install neolambda
omf theme neolambda
```

> Tip: If `omf` not found, start a new Fish session or `exec fish`.

---

## tmux + TPM

Install **TPM** (Tmux Plugin Manager):

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Ensure your `~/.tmux.conf` includes:

```tmux
set -g @plugin 'tmux-plugins/tpm'
# ... your other plugins
run -b '~/.tmux/plugins/tpm/tpm'
```

Install tmux plugins:

```text
tmux
# then press: Ctrl + b   I
```

---

## Neovim + Tooling

Install Neovim support tools (you already installed `ripgrep`, `fd-find`, `universal-ctags`, `unzip` above).

### Formatters & LSP glue
```bash
# Lua formatter used by many NVim setups
cargo install stylua

# Node bridge for Neovim plugins
npm install -g neovim
```

> If `cargo` not found, see [Rust](#rust) section first.

### Treesitter grammars (inside Neovim)
Open Neovim and install languages:

```vim
:TSInstall <language>
```

> Run after your config loads; install only what you need (`lua`, `python`, `r`, `bash`, `markdown`, etc.).

---

## Windows Clipboard (win32yank) for WSL

If you use WSL and want system clipboard yanks in NVim:

1. Copy the `win32yank-x64/` folder from this repo to **Windows** (e.g., `C:\Applications\win32yank-x64\`).
2. Ensure executable bit (from WSL):
   ```bash
   chmod +x /mnt/c/Applications/win32yank-x64/win32yank.exe
   ```
3. Point your Neovim/fish config to the correct path:
   - Example (NVim): set `g:clipboard` provider or ensure your `provider#clipboard` points to that `.exe`.
4. Common error fixed:
   `Invalid value for argument cmd: '/mnt/c/Apps/win32yank-x64/win32yank.exe' is not executable`
   → Use the **exact** path you installed and ensure `chmod +x`.

---

## Dotfile Symlinks with GNU Stow

From your dotfiles repo root:

```bash
# Example: link fish, nvim, and tmux configs into $HOME
stow -v fish
stow -v nvim
stow -v tmux

# To restow (overwrite) after changes:
stow -R -v fish nvim tmux

# To unlink:
stow -D -v fish nvim tmux
```

> You generally **don’t** need to export `STOW_FOLDERS`; `stow` acts on the current directory.

---

## Languages & Runtimes

### Rust
```bash
# Install rustup and default toolchain
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"
```

### Node.js (LTS/Current)

Use **NodeSource** to install Node 22.x (drop older instructions to avoid conflicts):

```bash
# Remove conflicting distro node if present
sudo apt remove -y nodejs || true

# Install Node.js 22.x
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt install -y nodejs

# (Optional) Yarn
npm install -g corepack
corepack enable
# Now `yarn` available via corepack (managed by Node)
```

### Python basics

If you don’t need conda, this is sufficient for editor tooling:

```bash
sudo apt install -y python3-pip python3.10-venv
pip3 install --user neovim vim-vint
```

> Prefer per-project virtualenvs (e.g., with `python3 -m venv .venv && source .venv/bin/activate`) for app/dev work.

> If you **do** want Anaconda, install it separately (but avoid mixing conda and system `pip` in the same env).

### R

Install R and dev headers:

```bash
sudo apt install -y r-base libcurl4-openssl-dev libssl-dev libxml2-dev
```

Set CRAN repo (optional but recommended for reproducibility):

```bash
sudo sh -c 'echo "options(repos = c(CRAN = \"https://cloud.r-project.org\"))" >> /etc/R/Rprofile.site'
```

Install R language server (for NVim LSP):

```bash
sudo R -q -e 'install.packages("languageserver", repos="https://cloud.r-project.org")'
```

Useful extras in an R session:

```r
install.packages("xml2")
install.packages("roxygen2")
install.packages("lintr")
```

### Java

Install modern JDK:

```bash
sudo apt install -y openjdk-21-jdk
```

---

## LaTeX / TeX Live

You have two common paths:

### A) **TeX Live via TUG (recommended, up-to-date)**

**Per-user** install (avoids unsafe permissions):

```bash
# Download installer
cd /tmp
wget https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
tar xzf install-tl-unx.tar.gz
cd install-tl-*

# Non-interactive per-user install into $HOME/texlive
./install-tl --no-interaction --texdir="$HOME/texlive/2025" --texuserdir="$HOME/texmf"
```

Add TeX Live to your PATH (Fish):

```fish
set -Ux PATH $HOME/texlive/2025/bin/x86_64-linux $PATH
```

Make tlmgr tools visible:

```bash
tlmgr path add
```

Install `latexmk` and friends:

```bash
tlmgr update --self
tlmgr install latexmk
```

Switch mirrors / repository:

```bash
tlmgr option repository https://mirror.ctan.org/systems/texlive/tlnet
```

**Usage tips**

```bash
# Clean intermediate files in the current LaTeX project
latexmk -c

# (NVim) If you use vimtex, \ll starts continuous compilation
```

> Avoid `sudo chmod -R 777 /usr/local/texlive/` — use per-user install above or manage group permissions if system-wide is required.

### B) **Minimal distro install**

If you prefer Ubuntu packages:

```bash
sudo apt install -y texlive-base latexmk biber
```

> `tlmgr` is not supported with Ubuntu packages. Use TUG method if you need `tlmgr`.

---

## Troubleshooting & Maintenance

- **Package install failures**
  ```bash
  sudo apt update --fix-missing
  sudo apt -f install
  ```
- **Oh My Fish not found** → Start a new shell: `exec fish`
- **Stylua install fails** → Ensure `unzip` is installed (covered above) and Rust toolchain is present.
- **Neovim Treesitter errors** → `:TSUpdate`, or pin a stable parser version.
- **Clipboard in WSL** → Confirm the exact path to `win32yank.exe` and `chmod +x` it; ensure NVim config references the correct path.
- **Re-run safety**
  All steps are safe to re-run; at worst you’ll see “already installed” messages.

---

## Appendix: Optional Extras

- **bash-language-server** (for bash LSP in NVim):
  ```bash
  npm install -g bash-language-server
  ```
- **R formatter & lint helpers**:
  ```r
  install.packages(c("styler", "formatR"))
  ```

---

## Done 🎉

- Shell: Fish + OMF `neolambda`
- Terminal: tmux + TPM
- Editor: Neovim with Treesitter, Stylua, Node bridge
- Toolchains: Rust, Node 22, Python, R, Java
- TeX Live: per-user via TUG with `tlmgr` + `latexmk`


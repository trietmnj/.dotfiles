# GEMINI.md - Instructional Context for .dotfiles

This directory contains a streamlined, idempotent development environment setup primarily targeting Ubuntu/WSL. It uses **GNU Stow** to manage symlinks for various configurations.

## Project Overview

- **Core Shell:** Fish Shell with Oh My Fish (OMF) and the `neolambda` theme.
- **Editor:** Neovim configured with `lazy.nvim` for plugin management and `mason.nvim` for LSP/tooling.
- **Terminal Multiplexer:** Tmux with Tmux Plugin Manager (TPM) and the Dracula theme.
- **Language Runtimes:** Managed via `uv` (Python), `rustup` (Rust), `conda`/`micromamba`, and `nvm`/`nodejs`.
- **Operating System:** Optimized for Linux/WSL (Debian-based).

## Directory Structure

- `stow-folders/`: Contains the actual configuration files organized by tool for GNU Stow.
    - `fish/`: Fish shell configs (`config.fish`, `functions/`, `conf.d/`).
    - `nvim/`: Neovim configuration (`init.lua`, `lua/`, `plugin/`).
    - `tmux/`: Tmux configuration (`.tmux.conf`).
    - `r/`: R configuration (`.Rprofile`).
- `fonts/`: Nerd Fonts for terminal icons and styling.
- `win32yank-x64/`: Clipboard provider for WSL to share clipboard with Windows.
- `install.sh`: Master script to link all configurations using `stow`.
- `clean-env`: Utility script to unlink (unstow) configurations.
- `mupdf.sh`: Helper for using MuPDF within WSL, handling path conversions.

## Building and Running (Setup Instructions)

### 1. Initial Setup
Run the main installation script to symlink all dotfiles to your home directory:
```bash
./install.sh
```

### 2. Fish Shell
Install Oh My Fish and the theme:
```bash
curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
omf install neolambda
omf theme neolambda
```

### 3. Tmux
Install TPM and plugins:
```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# Inside tmux, press 'prefix + I' to install plugins.
```

### 4. Neovim
Ensure dependencies are installed (`ripgrep`, `fd`, `unzip`, `gcc`). Plugins will auto-install on first launch via `lazy.nvim`.
To manually sync plugins:
```bash
nvim --headless "+Lazy! sync" +qa
```

### 5. Python Provider (via uv)
Recommended setup for Neovim's Python support:
```bash
uv venv ~/.venvs/nvim
source ~/.venvs/nvim/bin/activate
uv pip install -U pip setuptools wheel pynvim
deactivate
```

## Development Conventions

- **Idempotency:** The `install.sh` script is designed to be safe to run multiple times (it unstows before stowing).
- **Modularity:** Neovim config is split into `lua/modules/` (core logic) and `lua/plugins/` (plugin specs).
- **LSP Management:** Use `:Mason` inside Neovim to manage language servers and formatters.
- **Path Handling:** Scripts like `mupdf.sh` demonstrate a pattern for bridging WSL and Windows paths.
- **R Development:** `.Rprofile` is configured with `lintr` defaults for consistent coding style.

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
Ensure dependencies are installed (`ripgrep`, `fd`, `unzip`, `gcc`, `universal-ctags`). Plugins will auto-install on first launch via `lazy.nvim`.
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

# context-mode — MANDATORY routing rules

You have context-mode MCP tools available. These rules are NOT optional — they protect your context window from flooding. A single unrouted command can dump 56 KB into context and waste the entire session.

## BLOCKED commands — do NOT attempt these

### curl / wget — BLOCKED
Any shell command containing `curl` or `wget` will be intercepted and blocked. Do NOT retry.
Instead use:
- `mcp__context-mode__ctx_fetch_and_index(url, source)` to fetch and index web pages
- `mcp__context-mode__ctx_execute(language: "javascript", code: "const r = await fetch(...)")` to run HTTP calls in sandbox

### Inline HTTP — BLOCKED
Any shell command containing `fetch('http`, `requests.get(`, `requests.post(`, `http.get(`, or `http.request(` will be intercepted and blocked. Do NOT retry with shell.
Instead use:
- `mcp__context-mode__ctx_execute(language, code)` to run HTTP calls in sandbox — only stdout enters context

### WebFetch / web browsing — BLOCKED
Direct web fetching is blocked. Use the sandbox equivalent.
Instead use:
- `mcp__context-mode__ctx_fetch_and_index(url, source)` then `mcp__context-mode__ctx_search(queries)` to query the indexed content

## REDIRECTED tools — use sandbox equivalents

### Shell (>20 lines output)
Shell is ONLY for: `git`, `mkdir`, `rm`, `mv`, `cd`, `ls`, `npm install`, `pip install`, and other short-output commands.
For everything else, use:
- `mcp__context-mode__ctx_batch_execute(commands, queries)` — run multiple commands + search in ONE call
- `mcp__context-mode__ctx_execute(language: "shell", code: "...")` — run in sandbox, only stdout enters context

### read_file (for analysis)
If you are reading a file to **edit** it → read_file is correct (edit needs content in context).
If you are reading to **analyze, explore, or summarize** → use `mcp__context-mode__ctx_execute_file(path, language, code)` instead. Only your printed summary enters context.

### grep / search (large results)
Search results can flood context. Use `mcp__context-mode__ctx_execute(language: "shell", code: "grep ...")` to run searches in sandbox. Only your printed summary enters context.

## Tool selection hierarchy

1. **GATHER**: `mcp__context-mode__ctx_batch_execute(commands, queries)` — Primary tool. Runs all commands, auto-indexes output, returns search results. ONE call replaces 30+ individual calls.
2. **FOLLOW-UP**: `mcp__context-mode__ctx_search(queries: ["q1", "q2", ...])` — Query indexed content. Pass ALL questions as array in ONE call.
3. **PROCESSING**: `mcp__context-mode__ctx_execute(language, code)` | `mcp__context-mode__ctx_execute_file(path, language, code)` — Sandbox execution. Only stdout enters context.
4. **WEB**: `mcp__context-mode__ctx_fetch_and_index(url, source)` then `mcp__context-mode__ctx_search(queries)` — Fetch, chunk, index, query. Raw HTML never enters context.
5. **INDEX**: `mcp__context-mode__ctx_index(content, source)` — Store content in FTS5 knowledge base for later search.

## Output constraints

- Keep responses under 500 words.
- Write artifacts (code, configs, PRDs) to FILES — never return them as inline text. Return only: file path + 1-line description.
- When indexing content, use descriptive source labels so others can `search(source: "label")` later.

## ctx commands

| Command | Action |
|---------|--------|
| `ctx stats` | Call the `stats` MCP tool and display the full output verbatim |
| `ctx doctor` | Call the `doctor` MCP tool, run the returned shell command, display as checklist |
| `ctx upgrade` | Call the `upgrade` MCP tool, run the returned shell command, display as checklist |

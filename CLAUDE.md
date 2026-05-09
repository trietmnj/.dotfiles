# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

A GNU Stow-based dotfiles manager for a Linux/WSL2 environment. Config files live under `stow-folders/<tool>/` mirroring the structure they'll have when symlinked into `~`.

## Key Commands

```bash
# Symlink all dotfiles to ~
./install.sh

# Unstow everything (unlink symlinks)
./clean-env

# Sync Neovim plugins headlessly
nvim --headless "+Lazy! sync" +qa
```

`install.sh` is idempotent — it unstows then restows each package, safe to run repeatedly.

## Repo Structure

- `stow-folders/fish/` — Fish shell: `config.fish`, `conf.d/` (env/theme init), `functions/` (custom commands)
- `stow-folders/nvim/` — Neovim: `init.lua` bootstraps lazy.nvim; `lua/modules/` = core settings/keymaps; `lua/plugins/` = one file per plugin group
- `stow-folders/tmux/` — `.tmux.conf` with TPM (Dracula theme)
- `stow-folders/claude/` — Claude Code `settings.json` with hooks and MCP plugin config
- `stow-folders/r/` — `.Rprofile`
- `stow-folders/gemini/` — Gemini CLI config
- `fonts/` — Dank Mono Nerd Font (install on Windows host, not inside WSL)
- `win32yank-x64/` — Clipboard bridge between WSL and Windows

## Neovim Architecture

Plugin specs are split into `lua/plugins/<category>.lua` (ai, dap, dvc, editing, formatting, git, jupyter, latex, lsp, navigation, r, telescope, treesitter, trouble, ui, utils, which-key). Core configuration (globals, keymaps, theme, Telescope wrappers) lives in `lua/modules/`. LSPs and formatters are managed via `:Mason` at runtime — not configured statically.

## Adding a New Tool's Dotfiles

1. Create `stow-folders/<toolname>/` with the config mirroring its `~`-relative path.
2. Run `./install.sh` — the loop picks up all directories automatically.

## WSL-Specific Notes

- **Clipboard:** `win32yank.exe` bridges WSL↔Windows clipboard. Requires Visual C++ Redistributable on the Windows host.
- **Windows binary failures:** Re-register binfmt: `echo ':WSLInterop:M::MZ::/init:PF' | sudo tee /proc/sys/fs/binfmt_misc/register`
- **Fish `open` function:** Temporarily `cd`s to `C:` to silence the UNC path warning from `cmd.exe`.

## Claude Code Settings

`stow-folders/claude/.claude/settings.json` controls global Claude Code behavior:
- Read-only Bash commands (ls, cat, grep, find, git read ops) are pre-allowed.
- The `context-mode` MCP plugin is enabled — use `ctx_batch_execute`/`ctx_execute`/`ctx_execute_file` instead of Bash for commands producing >20 lines of output.
- Obsidian and Zotero MCP tools are read-allowed without prompts.

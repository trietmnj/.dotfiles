# .dotfiles

A streamlined, **idempotent** setup for a Linux/WSL development environment using **Oh My Fish**, **tmux**, and **Neovim**—plus language toolchains (Rust, Node.js, Go), R, TeX Live, and **Python via uv**.

> Target: Ubuntu/WSL (works on Debian-based).
> Assumes your dotfiles repo layout is compatible with `stow` (e.g., `stow-folders/fish/`, `stow-folders/nvim/`, etc.).

---

## 1. System Prep

Update base system and install core toolchains:

```bash
sudo apt update
sudo apt install -y \
  build-essential curl git unzip ca-certificates \
  ripgrep fd-find universal-ctags \
  stow xsel golang-go r-base
```

- **Runtimes:** `golang-go` and `r-base` are required for Mason to install their respective LSPs.
- **Utilities:** `ripgrep` is required for Telescope's grep features. `xsel` is a reliable Linux-native clipboard fallback.

### Fonts & Icons
1.  **Install Fonts:** Open the `fonts/` directory in Windows. Right-click and **Install** the `Dank Mono Nerd Font` files.
2.  **Terminal Setup:** In Windows Terminal, go to **Settings > Profiles > Ubuntu > Appearance** and set **Font face** to `DankMono Nerd Font`. This is required for icons in Neovim (Airline, NERDTree) and the Fish prompt.

---

## 2. Shell: Fish + Oh My Fish

2a. Install **Oh My Fish**:

```bash
curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
```

2b. Set Fish as default: `chsh -s /usr/bin/fish`.

2c. Setup **neolambda** theme:

```fish
omf install neolambda
omf theme neolambda
```

---

## 3. tmux + TPM

3a. Install **TPM**:

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

3b. Install plugins inside tmux: Press `Ctrl + b` then `I` (capital I).

---

## 4. Neovim (v0.11+)

Plugins are managed by `lazy.nvim`. On first launch, they will auto-install.

### Python Provider (uv)
Highly recommended for speed and isolation:

```bash
uv venv ~/.venvs/nvim
source ~/.venvs/nvim/bin/activate
uv pip install -U pynvim
deactivate
```

### Note on Treesitter & LSP
This configuration is optimized for **Neovim v0.11+**. It uses the new `require("nvim-treesitter").setup` and `vim.lsp.config` APIs.

---

## 5. WSL Interop & Clipboard

### Windows Binary Execution (Fix "Exec format error")
If Windows binaries (like `explorer.exe` or `win32yank.exe`) fail to run, re-register the interop handler:

```bash
echo ':WSLInterop:M::MZ::/init:PF' | sudo tee /proc/sys/fs/binfmt_misc/register
```

### win32yank Setup
1.  Ensure `win32yank.exe` is executable: `chmod +x ~/.dotfiles/win32yank-x64/win32yank.exe`.
2.  **Requirement:** You must install the [Visual C++ Redistributable](https://aka.ms/vs/17/release/vc_redist.x64.exe) on the **Windows host** for this binary to run.

---

## 6. Git Token (Permanent Login)

To save your GitHub Personal Access Token (PAT) permanently on this private computer:

```bash
git config --global credential.helper store
git pull  # Enter your username and PAT when prompted
```
Git will save these to `~/.git-credentials` and won't ask again.

---

## 7. Dotfile Symlinks (GNU Stow)

From the repo root:

```bash
./install.sh
```

The script is idempotent—it will unstow and restow to ensure links are clean.

---

## 8. Languages & Runtimes

- **Rust:** `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`
- **Node.js:** `curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash - && sudo apt install -y nodejs`
- **Python:** Managed via `uv`. Use `uv run` or `uvx` for tool isolation.

---

## 9. Troubleshooting

- **"open ." fails:** Ensure WSL Interop is registered (see Section 5).
- **No Icons:** Ensure Nerd Font is set in terminal settings (see Section 1).
- **LSP Failures:** Check `:Mason` inside Neovim. Ensure `go` and `R` are installed on the system.
- **UNC Path Warning:** The custom `open` function in Fish handles this by jumping to `C:` temporarily to silence `cmd.exe`.
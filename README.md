# .dotfiles

Configuration to quickly set up development environment.

---

## Quick Setup

### 1. Setup Fish

1a. Install and configure Fish:

```bash
curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
```

1b. Set Fish as the default shell:

```bash
chsh -s /usr/bin/fish
```

1c. Use theme `neolambda` from **Oh My Fish**.

---

### 2. Setup Tmux

2a. Install Tmux Plugin Manager:

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

2b. Setup Tmux plugins:

```text
tmux
Ctrl + b + I
```

---

### 3. Setup Neovim

3a. Install dependencies:

```bash
sudo apt install -y gcc ripgrep fd-find universal-ctags unzip
```

Install Rust and dependencies:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"
```

Install formatting and Neovim support:

```bash
cargo install stylua
npm install -g neovim
```

3b. Update Node.js for GitHub Copilot:

```bash
sudo apt remove -y nodejs
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo bash -
sudo apt-get install -y nodejs
```

3c. Install Treesitter packages inside Neovim:

```vim
:TSInstall <language>
```

---

### 4. Setup win32yank-x64 (Clipboard Integration)

Copy `win32yank-x64/` from project root to:

```text
/mnt/c/Applications/
```

---

### 5. Configure Fish, Neovim, and Tmux with Stow

```bash
sudo apt update && sudo apt install -y stow
export STOW_FOLDERS=/home/tmnj/.dotfiles/
```

---

### 6. Setup Additional Tools

Install ripgrep, Node.js, Yarn, and Anaconda:

```bash
curl -sL https://deb.nodesource.com/setup_16.x -o /tmp/nodesource_setup.sh
sudo bash /tmp/nodesource_setup.sh
sudo apt update
sudo apt install -y nodejs
npm install --global yarn
yarn global add neovim

curl https://repo.anaconda.com/archive/Anaconda3-2024.02-1-Linux-x86_64.sh --output anaconda.sh
bash anaconda.sh
```

Python and Neovim:

```bash
sudo apt install python3-pip python3.10-venv
pip3 install vim-vint neovim
```

Java:

```bash
sudo apt install default-jre default-jdk
```

LaTeX (base):

```bash
sudo apt install texlive-base
tlmgr init-usertree
tlmgr install latexmk
```

R setup folders:

```bash
mkdir -p ~/R/x86_64-pc-linux-gnu-library/4.1
sudo apt install libxml2-dev libcurl4-openssl-dev libssl-dev r-base
```

---

## R

Install R and dependencies:

```bash
sudo apt install -y r-base libcurl4-openssl-dev libssl-dev libxml2-dev
```

Install R language server:

```bash
sudo R -q -e 'install.packages("languageserver", repos="https://cloud.r-project.org")'
```

In R terminal:

```R
install.packages("xml2")
install.packages("roxygen2")
install.packages("lintr")
```

Biber:

```bash
sudo apt install biber
```

---

## LaTeX

`latexmk` is the CLI workhorse.

### 1. Install via TUG

Follow instructions: [https://www.tug.org/texlive/quickinstall.html](https://www.tug.org/texlive/quickinstall.html)

### 2. Permissions

```bash
sudo chmod -R 777 /usr/local/texlive/
```

### 3. Update Scripts

```bash
tlmgr update texlive-scripts
```

### 4. Usage

- Clean up intermediate files:

```bash
latexmk -c
```

- Start auto-compiling: `\ll`
- Open with MuPDF

### 5. Change tlmgr Repository

```bash
tlmgr option repository https://mirror.ctan.org/systems/texlive/tlnet
```

### 6. Install and Update Packages

```bash
tlmgr install <package>
tlmgr update --self
tlmgr install <package>
```

Find packages: [https://ctan.org/](https://ctan.org/)

### 7. Manual Installation Example

```bash
cd /tmp
wget https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
zcat < install-tl-unx.tar.gz | tar xf -
cd install-tl-*
sudo perl ./install-tl --no-interaction
tlmgr install latexmk
```

---

## Debugging

Clean out cache:

```bash
sudo apt clean
sudo apt autoremove
```

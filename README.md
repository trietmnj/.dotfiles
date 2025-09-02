# .dotfiles

Configuration to quickly set up development environment

## Quick setup

1. Setup fish

    1a. Install and configure fish

    ```bash
    curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
    ````

    1c. Set `fish` as the default shell

    ```bash
    chsh -s /usr/bin/fish
    ```

    1d. Use theme `neolambda` from `Oh My Fish`

2. Setup tmux

    2a. Install `tmux plugin manager`

    ```bash
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    ```

    2b. Setup tmux along with Oh My Fish and Darcula

    ```
        tmux
        Ctrl + b + I
    ```

3. Setup nvim

    3a. Setup dependencies for neovim

    ```bash
        sudo apt install -y gcc ripgrep fd-find universal-ctags
    ```

    Install Rust

    ```bash
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
    ```

    3b. Update `nodejs` for Copilot

    ```bash
        sudo apt remove -y nodejs
        curl -fsSL https://deb.nodesource.com/setup_22.x | sudo bash -
        sudo apt-get install -y nodejs
    ```

5. Setup win32yank-x64 for copying from terminal

    5a. Copy `win32yank-x64/` from project root to /mnt/c/Applications/

6. Configure `fish`, `neovim`, and `tmux`
    6a. Setup `stow`

    ```bash
        sudo apt update && sudo apt install stow
        export STOW_FOLDERS=/home/tmnj/.dotfiles/
    ```

7. Install `ripgrep` for fast greping through repo

```bash
    curl -sL https://deb.nodesource.com/setup_16.x -o /tmp/nodesource_setup.sh
    sudo bash /tmp/nodesource_setup.sh
    sudo apt update
    sudo apt install nodejs
    npm install --global yarn
    yarn global add neovim

    curl https://repo.anaconda.com/archive/Anaconda3-2024.02-1-Linux-x86_64.sh --output anaconda.sh
    bash anaconda.sh
    sudo apt install python3-pip
    pip3 install vim-vint
    pip3 install neovim
    apt install python3.10-venv

    sudo apt install default-jre
    sudo apt install default-jdk

    sudo apt install texlive-base
    tlmgr init-usertree
    tlmgr install latexmk

    mkdir -p ~/R/x86_64-pc-linux-gnu-library/4.1
    sudo apt install libxml2-dev libcurl4-openssl-dev libssl-dev

    sudo apt install r-base

In an R terminal
    install.package("xml2")
    install.package("roxygen2")
    install.package("lintr")

    sudo apt install biber
```

Setup Latex from the Tex User Group

https://www.tug.org/texlive/

```
    cd /tmp
    wget https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
    zcat < install-tl-unx.tar.gz | tar xf -
cd into installation folder, replace *  with actual folder name
    cd install-tl-*
    sudo perl ./install-tl --no-interaction
    tlmgr install latexmk
```

Debugging - clean out cache
```
sudo apt clean
sudo apt autoremove
```

# Using latex
latexmk is the CLI workhorse
```
1. Install via TUG
https://www.tug.org/texlive/quickinstall.html

2. Loosen access permission in isntallation folder
sudo chmod -R 777 /usr/local/texlive/

3. Update texlive-scripts
tlmgr update texlive-scripts

    Clean up intermediate files generated for latex rendering
latexmk -c

\ll to start autocompiling
Open file with MuPDF

    change tlmgr repo
tlmgr option repository https://mirror.ctan.org/systems/texlive/tlnet

    install package
tlmgr install <package>

    update package manager
tlmgr update --self


Find packages on CTAN
    https://ctan.org/


texlive-scripts
```

# Setup guide
Clone into home folder

Install and configure stow
```
    sudo apt install stow
    export STOW_FOLDERS=/home/tmnj/.dotfiles/
    stow fish
    stow nvim
    stow tmux
```

Install and configure fish
````
curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
````

Setup tmux along with Oh My Fish and Darcula
```
    tmux
    Ctrl + b + I
```

Setup dependencies for neovim
```
    sudo apt install gcc
    sudo apt install r-base
    sudo apt install ripgrep
    sudo apt install fd-find
    sudo apt install universal-ctags

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
Clean up intermediate files generated for latex rendering
    latexmk -c
```

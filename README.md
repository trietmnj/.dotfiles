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

    sudo apt install default-jre
    sudo apt install default-jdk

    sudo apt install texlive-base
    tlmgr init-usertree
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

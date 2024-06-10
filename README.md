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

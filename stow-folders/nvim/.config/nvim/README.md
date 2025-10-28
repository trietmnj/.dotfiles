```
change ~/.vim/plugged/vimtex/general.vim line 23 to:
    \ || (!executable(l:exe) && !(l:exe ==# '~/.dotfiles/mupdf.sh')

If there is an issue with :COQdeps, try
    apt-get install python3-venv

Make sure to reinstall nodejs and npm.
```

# Working with latex
Start/stop autocompilation with \ll
Open pdf with mupdf and refresh with r
vimtex setup with texlive which provides tlmgr to manage packages
    Install latex packages with tlmgr install <package>

# Jupyter notebooks in neovim

Make sure to install uvx


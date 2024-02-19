```
change ~/.vim/plugged/vimtex/general.vim line 23 to:
    \ || (!executable(l:exe) && !(l:exe ==# '~/.dotfiles/mupdf.sh')

If there is an issue with :COQdeps, try
    apt-get install python3-venv

Make sure to reinstall nodejs and npm.
```

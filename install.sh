#!/bin/bash 
for folder in stow-folders/*/; do
    pkg=$(basename "$folder")
    stow -d stow-folders -t ~ -D "$pkg"
    stow -d stow-folders -t ~ "$pkg"
done

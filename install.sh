#!/bin/bash 
set -euo pipefail
pushd "$DOTFILES" || exit 1
for folder in stow-folders/*/; do
    pkg=$(basename "$folder")
    stow -d stow-folders -t ~ -D "$pkg"
    stow -d stow-folders -t ~ "$pkg"
done
popd

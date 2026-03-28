## Gemini Added Memories
- Setup Neovim stable AppImage (v0.11.6) in ~/.local/bin/nvim.
- Configured Neovim Python provider using uv in ~/.venvs/nvim with pynvim installed.
- Installed Tmux Plugin Manager (TPM) in ~/.tmux/plugins/tpm and installed configured plugins (Dracula).
- Stowed dotfiles using GNU Stow from ~/.dotfiles/stow-folders for fish, nvim, r, and tmux.
- Verified Oh My Fish installation with the 'neolambda' theme.
- The Seeking Alpha MCP tools (Article_Details, News_Data) fail with large integer IDs due to scientific notation conversion. Workaround: Use `curl` to fetch `https://seeking-alpha-finance.p.rapidapi.com/v1/articles/data` directly and parse the JSON locally.
- Always save raw investment analysis, writeups, and returns data locally (e.g., in 'data/raw' or 'data/author_performance') to ensure persistence and accessibility across sessions.
- The 'activate_skill' tool only accepts the 'name' parameter. Do not provide a 'prompt' or any other additional properties.
- All literature, handbook, and book reviews should be saved in the Obsidian vault at the path: 'phd/01_Literature/review/'

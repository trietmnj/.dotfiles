-------------------------------------------------
-- Globals
-------------------------------------------------
-- VimTeX
vim.g.tex_flavor = "latex"
vim.g.vimtex_quickfix_mode = 0
vim.opt.conceallevel = 1
vim.g.tex_conceal = "abdmg"
vim.g.vimtex_view_general_viewer = vim.g.vimtex_view_general_viewer or "~/.dotfiles/mupdf.sh"
vim.g.vimtex_view_general_options = "@pdf"

-- UltiSnips (if you re-enable it later)
vim.g.UltiSnipsExpandTrigger = "<tab>"
vim.g.UltiSnipsJumpForwardTrigger = "<tab>"
vim.g.UltiSnipsJumpBackwardTrigger = "<S-tab>"

-- WSL clipboard (using xsel for reliability)
if vim.fn.has("wsl") == 1 then
	vim.g.clipboard = {
		name = "wslclipboard",
		copy = {
			["+"] = "xsel --nodetach -i -b",
			["*"] = "xsel --nodetach -i -p",
		},
		paste = {
			["+"] = "xsel -o -b",
			["*"] = "xsel -o -p",
		},
		cache_enabled = 1,
	}
end

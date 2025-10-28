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

-- WSL clipboard
if vim.fn.has("wsl") == 1 then
	vim.g.clipboard = {
		name = "wslclipboard",
		copy = {
			["+"] = "/mnt/c/Applications/win32yank-x64/win32yank.exe -i --crlf",
			["*"] = "/mnt/c/Applications/win32yank-x64/win32yank.exe -i --crlf",
		},
		paste = {
			["+"] = "/mnt/c/Applications/win32yank-x64/win32yank.exe -o --lf",
			["*"] = "/mnt/c/Applications/win32yank-x64/win32yank.exe -o --lf",
		},
		cache_enabled = 1,
	}
end

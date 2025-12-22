-- lua/modules/keymaps.lua
local M = {}

function M.setup()
	local map = vim.keymap.set
	local opts = { noremap = true, silent = true }

	-- Format + reindent current buffer (try LSP first, fallback to gg=G)
	map("n", "<leader>ff", function()
		if vim.lsp and vim.lsp.buf and vim.lsp.buf.format then
			pcall(vim.lsp.buf.format, { async = false })
		else
			vim.cmd("normal! gg=G")
		end
	end, vim.tbl_extend("force", opts, { desc = "Format + reindent file" }))
	map("v", "<leader>ff", "gq", vim.tbl_extend("force", opts, { desc = "Reflow selection" }))

	-- Buffer navigation
	map("n", "<CR>", "<cmd>bnext<CR>", vim.tbl_extend("force", opts, { desc = "Next buffer" }))
	map("n", "<C-m>", "<cmd>bnext<CR>", vim.tbl_extend("force", opts, { desc = "Next buffer" })) -- <C-m> == <CR>
	map("n", "<C-n>", "<cmd>bprevious<CR>", vim.tbl_extend("force", opts, { desc = "Previous buffer" }))
	map("n", "<C-x>", "<cmd>bp|bd #<CR>", vim.tbl_extend("force", opts, { desc = "Close buffer" }))

	-- Quality-of-life motions (correct direction)
	map("n", "Y", "y$", opts) -- make Y behave like C
	map("n", "n", "nzzzv", opts) -- keep cursor centered
	map("n", "N", "Nzzzv", opts)
	map("n", "J", "mzJ`z", opts) -- join without losing cursor position

	-- Insert-mode undo breakpoints
	map("i", ",", ",<C-g>u", opts)
	map("i", ".", ".<C-g>u", opts)
	map("i", "!", "!<C-g>u", opts)
	map("i", "?", "?<C-g>u", opts)

	-- Vista (outline)
	map("n", "<C-s>", "<cmd>Vista!!<CR>", vim.tbl_extend("force", opts, { desc = "Toggle Vista" }))

	-- Cheatsheet (leave as-is; these call your Vimscript functions)
	map("n", "<leader>cs", "<cmd>call CheatSheetCommand()<CR>", opts)
	map("n", "<leader>cc", "<cmd>call CheatSheetCursor()<CR>", opts)

	-- Git helpers
	map("n", "<leader>gh", "<cmd>diffget //3<CR>", opts)
	map("n", "<leader>gu", "<cmd>diffget //2<CR>", opts)
	map("n", "<leader>gs", "<cmd>G<CR>", opts)

	-- Prevent stray remap: ensure "~" in insert mode is literal
	map("i", "~", "~", opts)

	-- Tabular mappings (escape backslash in \zs)
	map("n", "<leader>a=", ":Tabularize /=<CR>", opts)
	map("v", "<leader>a=", ":Tabularize /=<CR>", opts)
	map("n", "<leader>a:", ":Tabularize /:\\zs<CR>", opts)
	map("v", "<leader>a:", ":Tabularize /:\\zs<CR>", opts)

	-- Quick block-visual entry
	map("n", "<F4>", "<C-v>", opts)

	-- rename symbol using LSP
	map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
end

return M

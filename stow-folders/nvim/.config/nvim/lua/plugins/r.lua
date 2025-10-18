-- lua/plugins/r.lua
return {
	{
		"R-nvim/R.nvim",
		ft = { "r", "rmd", "rnoweb", "quarto" }, -- load ONLY for these
		lazy = true, -- important: don't load globally
		init = function()
			-- Add R-related filetype mappings (doesn't affect *.tf)
			vim.filetype.add({
				extension = {
					r = "r",
					R = "R",
					rmd = "rmd",
					Rmd = "Rmd",
					rnoweb = "rnoweb",
					qmd = "quarto", -- optional if you use .qmd
				},
			})
		end,
		config = function()
			-- Extra guard: if somehow invoked on a non-R buffer, bail early.
			local ok_ft = { r = true, rmd = true, rnoweb = true, quarto = true }
			if not ok_ft[vim.bo.filetype] then
				return
			end

			require("r").setup({
				R_args = { "--quiet", "--no-save" },
				min_editor_width = 72,
				rconsole_width = 78,
				hook = {
					on_filetype = function()
						-- Double-guard inside hook too
						local ft = vim.bo.filetype
						if not ok_ft[ft] then
							return
						end

						-- Buffer-local maps only for R-like buffers
						local opts = { buffer = true, remap = true, silent = true }
						vim.keymap.set(
							"n",
							"<localleader>r",
							"<Plug>RDSendLine",
							vim.tbl_extend("force", opts, { desc = "R: send line" })
						)
						vim.keymap.set(
							"v",
							"<localleader>r",
							"<Plug>RSendSelection",
							vim.tbl_extend("force", opts, { desc = "R: send selection" })
						)
						vim.keymap.set(
							"n",
							"<localleader>R",
							"<Plug>RStart",
							vim.tbl_extend("force", opts, { desc = "R: start session" })
						)
						-- Optional:
						-- vim.keymap.set("n", "<localleader>q", "<Plug>RClose",      vim.tbl_extend("force", opts, { desc = "R: quit" }))
					end,
				},
			})
		end,
	},

	-- Only load completion sources in R buffers
	{
		"ncm2/ncm2",
		event = "InsertEnter",
		cond = function()
			return vim.bo.filetype:match("^r") ~= nil
		end,
	},

	{ "gaalcaras/ncm-R", ft = { "r", "rmd", "rnoweb" }, lazy = true },

	{ "roxma/vim-hug-neovim-rpc", lazy = true }, -- stays lazy; R.nvim will require it when needed

	{ "ncm2/ncm2-ultisnips", lazy = true },
}

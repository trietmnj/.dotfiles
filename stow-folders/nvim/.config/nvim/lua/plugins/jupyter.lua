-- lua/plugins/jupyter.lua
return {
	{
		"GCBallesteros/jupytext.nvim",
		lazy = false, -- open .ipynb via jupytext, not as JSON
		config = function()
			require("jupytext").setup({
				style = "hydrogen",
				output_extension = "auto",
				force_ft = nil,
			})
		end,
	},
	{
		"benlubas/molten-nvim",
		version = "^1.0.0",
		build = ":UpdateRemotePlugins",
		init = function()
			vim.g.molten_output_win_max_height = 12
		end,
		config = function()
			-- Buffer-local keymaps for Python/Quarto/Markdown only
			local molten_fts = { python = true, markdown = true, quarto = true, qmd = true }

			local aug = vim.api.nvim_create_augroup("MoltenKeymaps", { clear = true })
			vim.api.nvim_create_autocmd("FileType", {
				group = aug,
				pattern = { "python", "markdown", "quarto", "qmd" },
				callback = function(ev)
					if not molten_fts[vim.bo[ev.buf].filetype] then
						return
					end
					local opts = { buffer = ev.buf, silent = true, noremap = true }

					vim.keymap.set(
						"n",
						"<localleader>mi",
						":MoltenInit<CR>",
						{ silent = true, desc = "Initialize the plugin" }
					)
					vim.keymap.set(
						"n",
						"<localleader>ml",
						":MoltenEvaluateLine<CR>",
						vim.tbl_extend("force", opts, { desc = "Molten: eval line" })
					)
					vim.keymap.set(
						"n",
						"<localleader>mR",
						":MoltenReevaluateCell<CR>",
						vim.tbl_extend("force", opts, { desc = "Molten: re-eval cell" })
					)
					vim.keymap.set(
						"n",
						"<localleader>me",
						":MoltenEvaluateOperator<CR>",
						vim.tbl_extend("force", opts, { desc = "Molten: eval operator" })
					)
					vim.keymap.set(
						"v",
						"<localleader>mr",
						":<C-u>MoltenEvaluateVisual<CR>gv",
						vim.tbl_extend("force", opts, { desc = "Molten: eval visual" })
					)
					vim.keymap.set(
						"n",
						"<localleader>rd",
						":MoltenDelete<CR>",
						{ silent = true, desc = "molten delete cell" }
					)
					vim.keymap.set(
						"n",
						"<localleader>oh",
						":MoltenHideOutput<CR>",
						{ silent = true, desc = "hide output" }
					)
					vim.keymap.set(
						"n",
						"<localleader>os",
						":noautocmd MoltenEnterOutput<CR>",
						{ silent = true, desc = "show/enter output" }
					)
				end,
			})
		end,
	},
}

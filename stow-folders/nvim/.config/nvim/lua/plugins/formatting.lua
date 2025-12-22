-- lua/plugins/formatting.lua
return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		formatters_by_ft = {
			javascript = { "prettier" },
			javascriptreact = { "prettier" },
			typescript = { "prettier" },
			typescriptreact = { "prettier" },
			json = { "prettier" },
			css = { "prettier" },
			scss = { "prettier" },
			html = { "prettier" },
			yaml = { "prettier" },
			markdown = { "prettier" },
		},
	},
	config = function(_, opts)
		require("conform").setup(opts)

		vim.keymap.set("n", "<leader>f", function()
			require("conform").format({
				async = false,
				timeout_ms = 5000,
			})
		end, { desc = "Format (Prettier)" })
	end,
}

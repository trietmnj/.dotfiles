-- lua/plugins/jupyter.lua
-- lua/plugins/jupytext.lua (or inline in your plugins list)
return {
	"GCBallesteros/jupytext.nvim",
	-- IMPORTANT: load it eagerly so .ipynb doesn't open as JSON
	lazy = false,
	config = function()
		require("jupytext").setup({
			style = "hydrogen",
			output_extension = "auto", -- let jupytext choose (".py" for py notebooks)
			force_ft = nil, -- only set if you force markdown/quarto filetype
		})
	end,
}

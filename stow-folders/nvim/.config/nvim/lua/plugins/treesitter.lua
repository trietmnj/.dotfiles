-- lua/plugins/treesitter.lua
return {

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      -- Required if you want `textobjects = { enable = true }`
      { "nvim-treesitter/nvim-treesitter-textobjects", lazy = true },

      -- Rainbow parentheses: pick ONE of these (rainbow2 is the maintained fork)
      -- { "HiPhish/nvim-ts-rainbow2", lazy = true },  -- recommended
      -- { "p00f/nvim-ts-rainbow", lazy = true },      -- legacy, archived
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "c",
          "lua",
          "vim",
          "vimdoc",
          "query",
          "rust",
          "go",
          "typescript",
          "python",
          "r",
        },

        -- Core
        highlight = { enable = true, disable = { "note" } },
        indent = { enable = true },

        -- From your base config
        context_commentstring = { enable = true, enable_autocmd = false },

        -- Extras you enabled
        incremental_selection = { enable = true },
        textobjects = { enable = true },

        -- Keep rainbow only if you’ve installed one of the rainbow plugins above
        rainbow = {
          enable = true,
          extended_mode = true,
          max_file_lines = nil,
          colors = { "#97e023", "#78DCE8", "#dfd561", "#fa8419", "#9c64fe" },
        },
      })
    end,
  },

  -- Optional dev tool
  { "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" },

}

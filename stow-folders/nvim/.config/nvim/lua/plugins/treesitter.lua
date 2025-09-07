-- lua/plugins/treesitter.lua
return {

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    branch = "master",
    lazy = false,
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { },
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

          -- r requirements
          "markdown", "markdown_inline", "r", "rnoweb", "yaml", "latex", "csv",
        },

        highlight = { enable = true, disable = { "note" } },
        indent = { enable = true },
        context_commentstring = { enable = true, enable_autocmd = false },
        incremental_selection = { enable = true },

      })
    end,
  },

    -- Rainbow Delimiters (after TS)
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      local rd = require("rainbow-delimiters")
      vim.g.rainbow_delimiters = {
        -- Global strategy works well for most; vimscript uses local for speed
        strategy = {
          [""]  = rd.strategy["global"],
          vim   = rd.strategy["local"],
        },
        -- Default query name; you can override per filetype if needed
        query = {
          [""]    = "rainbow-delimiters",
          -- latex = "rainbow-blocks",
        },
        -- Priority lets it win over theme highlights if needed
        priority = {
          [""] = 110,
          lua  = 210,
        },
        -- Use the provided highlight groups (override these in your colors if you want custom colors)
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      }
    end,
  },

  -- Optional dev tool
  { "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" },

}

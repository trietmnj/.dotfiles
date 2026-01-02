-- plugins/ai.lua

return {
    -- 1. The Speed King: Supermaven
    {
        "supermaven-inc/supermaven-nvim",
        event = "InsertEnter",
        opts = {
          keymaps = {
            accept_suggestion = "<Tab>",
            clear_suggestion = "<C-]>",
          },
          ignore_filetypes = { "bigfile" }, -- Don't slow down on massive logs
          color = {
            suggestion_color = "#808080",
          }
        },
    },

  -- 2. The High-Performance UI: blink.cmp
    {
        "saghen/blink.cmp",
        version = "v0.*", -- or 'v1.*' if you want the latest
        dependencies = {
          "supermaven-inc/supermaven-nvim",
          { "saghen/blink.compat", opts = {} }, -- THE MISSING PIECE
        },
        opts = {
          keymap = { preset = "default" },
          sources = {
            default = { "lsp", "path", "snippets", "buffer", "supermaven" },
            providers = {
              supermaven = {
                name = "supermaven",
                module = "blink.compat.source", -- Now this module will be found
                score_offset = 100,
                async = true,
              },
            },
          },
        },
      },

    -- -- 3. The Cursor Experience: Avante.nvim (Streaming Chat)
    -- {
    --     "yetone/avante.nvim",
    --     event = "VeryLazy",
    --     lazy = false,
    --     version = false,
    --     opts = {
    --       provider = "copilot", -- Ensure this matches your speed preference
    --     },
    --     -- This 'build' step is CRITICAL for Avante speed/performance
    --     build = "make",
    --     dependencies = {
    --       "nvim-treesitter/nvim-treesitter",
    --       "stevearc/dressing.nvim",
    --       "nvim-lua/plenary.nvim",
    --       "MunifTanjim/nui.nvim", --- THIS IS THE MISSING MODULE
    --       "nvim-tree/nvim-web-devicons",
    --       "zbirenbaum/copilot.lua",
    --       {
    --         "MeanderingProgrammer/render-markdown.nvim",
    --         opts = { file_types = { "markdown", "Avante" } },
    --         ft = { "markdown", "Avante" },
    --       },
    --     },
    -- },
}

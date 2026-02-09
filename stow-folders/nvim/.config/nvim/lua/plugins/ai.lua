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
}

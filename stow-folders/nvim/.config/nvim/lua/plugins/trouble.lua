-- lua/plugins/trouble.lua
return {

  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    dependencies = {
            "nvim-tree/nvim-web-devicons",
            "nvim-treesitter/nvim-treesitter",
        },
    opts = {},
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>" },
      { "<leader>xw", "<cmd>TroubleToggle lsp_workspace_diagnostics<cr>" },
      { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<cr>" },
      { "<leader>xl", "<cmd>Trouble loclist toggle<cr>" },
    },
  },

}

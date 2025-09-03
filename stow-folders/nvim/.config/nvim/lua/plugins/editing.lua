-- plugins/editing.lua
return {

  { "AndrewRadev/splitjoin.vim", keys = { { "gS", "<Plug>SplitjoinSplit" }, { "gJ", "<Plug>SplitjoinJoin" } } },

  { "LucHermitte/lh-vim-lib",    lazy = true },

  {
    "LucHermitte/lh-brackets",
    event = "InsertEnter",
    dependencies = { "LucHermitte/lh-vim-lib" }, -- fixes missing lh#* functions
  },

  -- { "rhysd/vim-grammarous", cmd = "GrammarousCheck" },

  { "matze/vim-move",       event = "VeryLazy" },

  {
    "godlygeek/tabular",
    cmd = "Tabularize",
    config = function()
      local map = vim.keymap.set
      map("n", "<leader>a=", ":Tabularize /=<CR>", { noremap = true, silent = true, desc = "Align by =" })
      map("v", "<leader>a=", ":Tabularize /=<CR>", { noremap = true, silent = true, desc = "Align by =" })
      map("n", "<leader>a:", ":Tabularize /:\\zs<CR>", { noremap = true, silent = true, desc = "Align by :" })
      map("v", "<leader>a:", ":Tabularize /:\\zs<CR>", { noremap = true, silent = true, desc = "Align by :" })
    end,
  },

  { "tpope/vim-commentary",                        keys = { "gc", "gcc" } },

  { "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },

  {
    "echasnovski/mini.nvim",
    version = false,
    event = "VeryLazy",
    config = function() require("mini.comment").setup() end,
  },

}

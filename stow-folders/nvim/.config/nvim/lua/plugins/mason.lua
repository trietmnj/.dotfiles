-- plugins/mason.lua
return {
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    event = "VeryLazy",
    opts = {}, -- let lazy call setup({})
  },
  {
    "williamboman/mason-lspconfig.nvim",
    event = "VeryLazy",
    opts = {
      ensure_installed = { "lua_ls", "pyright", "rust_analyzer" },
      automatic_installation = true,
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
    opts = {
      ensure_installed = {
        "lua-language-server", "pyright", "rust-analyzer",
        "stylua", "black", "ruff",
      },
      run_on_start = true,
      start_delay = 3000,
      debounce_hours = 5,
    },
  },
}

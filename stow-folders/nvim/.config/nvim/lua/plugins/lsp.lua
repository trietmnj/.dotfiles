-- lua/plugins/lsp.lua
return {
  -- Mason core
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    event = "VeryLazy",
    opts = {
      ui = {
        icons = {
          package_installed   = "✓",
          package_pending     = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  -- Mason <-> lspconfig bridge (installs servers)
  {
    "williamboman/mason-lspconfig.nvim",
    event = "VeryLazy",
    opts = {
      ensure_installed = {
        "lua_ls", "pyright", "rust_analyzer", "bashls", "vimls",
        "r_language_server", "texlab", "jsonls", "gopls", "ts_ls",
      },
      automatic_installation = true,
    },
  },

  -- Extra tools via Mason
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
    opts = {
      ensure_installed = {
        -- LSP (Mason package names)
        "lua-language-server", "pyright", "rust-analyzer",
        "bash-language-server", "vim-language-server",
        "r-languageserver", "texlab",
        -- Tools
        "stylua", "black", "ruff", "shellcheck",
        "editorconfig-checker", "shfmt", "vint",
      },
      auto_update   = true,
      run_on_start  = true,
      start_delay   = 3000,
      debounce_hours = 5,
    },
  },

  -- LSP setups (no setup_handlers)
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    dependencies = {
      { "ms-jpq/coq_nvim", branch = "coq" },
      { "ms-jpq/coq.artifacts", branch = "artifacts" },
    },
    config = function()
      vim.lsp.log.set_level("error")
      vim.g.coq_settings = { auto_start = "shut-up" }

      local lspconfig = require("lspconfig")
      local coq       = require("coq")
      local flags     = { debounce_text_changes = 150 }

      local function bmap(buf, mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = buf, silent = true, noremap = true, desc = desc })
      end

      local on_attach = function(_, bufnr)
        vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
        bmap(bufnr, "n", "ga", vim.lsp.buf.code_action,    "LSP code action")
        bmap(bufnr, "n", "gd", vim.lsp.buf.definition,     "LSP definition")
        bmap(bufnr, "n", "gD", vim.lsp.buf.declaration,    "LSP declaration")
        bmap(bufnr, "n", "gr", vim.lsp.buf.references,     "LSP references")
        bmap(bufnr, "n", "gi", vim.lsp.buf.implementation, "LSP implementation")
        bmap(bufnr, "n", "K",  vim.lsp.buf.hover,          "LSP hover")
        bmap(bufnr, "n", "<leader>rn", vim.lsp.buf.rename, "LSP rename")
      end

      -- Per-server setups (COQ capabilities applied)
      lspconfig.gopls.setup(coq.lsp_ensure_capabilities({
        cmd = { "gopls", "serve" },
        filetypes = { "go", "gomod" },
        settings = {
          gopls = {
            experimentalPostfixCompletions = true,
            analyses = { unusedparams = true, shadow = true },
            staticcheck = true,
          },
        },
        on_attach = on_attach, flags = flags,
      }))

      lspconfig.rust_analyzer.setup(coq.lsp_ensure_capabilities({
        settings = {
          ["rust-analyzer"] = {
            assist    = { importGranularity = "module", importPrefix = "self" },
            cargo     = { loadOutDirsFromCheck = true },
            procMacro = { enable = true },
          },
        },
        on_attach = on_attach, flags = flags,
      }))

      lspconfig.pyright.setup(coq.lsp_ensure_capabilities({
        settings = {
          python = {
            analysis = { autoSearchPaths = true, useLibraryCodeForTypes = true },
            -- keep only if you truly need a fixed interpreter:
            pythonPath = "/home/linuxbrew/.linuxbrew/bin/python3.11",
          },
        },
        on_attach = on_attach, flags = flags,
      }))

      lspconfig.lua_ls.setup(coq.lsp_ensure_capabilities({
        settings = {
          Lua = {
            runtime     = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace   = { library = vim.api.nvim_get_runtime_file("", true) },
            telemetry   = { enable = false },
          },
        },
        on_attach = on_attach, flags = flags,
      }))

      lspconfig.r_language_server.setup(coq.lsp_ensure_capabilities({
        filetypes = { "r", "rmd", "quarto", "rnoweb" },
        settings  = { r = { lsp = { diagnostics = true } } },
        on_attach = on_attach, flags = flags,
      }))

      lspconfig.ts_ls.setup(coq.lsp_ensure_capabilities({
        on_attach = on_attach, flags = flags,
      }))

      -- Simple defaults for others you ensure via Mason (bashls, vimls, jsonls, texlab)
      for _, srv in ipairs({ "bashls", "vimls", "jsonls", "texlab" }) do
        if lspconfig[srv] then
          lspconfig[srv].setup(coq.lsp_ensure_capabilities({
            on_attach = on_attach, flags = flags,
          }))
        end
      end
    end,
  },
}

-- lua/plugins/lsp.lua
return {
    -- downloads/updates LSP servers, linters, formatters, DAPs into a Mason directory
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        event = "VeryLazy",
        opts = {
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        },
    },

    -- Automate tools installation (just installs binaries; does NOT configure LSP)
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        event = "VimEnter",
        dependencies = { "williamboman/mason.nvim" },
        opts = {
            ensure_installed = {
                -- LSP servers (Mason tool names)
                "lua-language-server",
                "pyright",
                "rust-analyzer",
                "bash-language-server",
                "vim-language-server",
                "r-languageserver",
                "gopls",

                -- Formatters / linters / misc
                "black",
                "shellcheck",
                "editorconfig-checker",
                "shfmt",
                "vint",
            },
            auto_update = true,
            run_on_start = true,
            start_delay = 3000,
            debounce_hours = 5,
        },
    },

    -- Optional: still useful to ensure Mason installs by lspconfig-id mapping,
    -- but we no longer use it to *configure* servers.
    {
        "williamboman/mason-lspconfig.nvim",
        event = "VeryLazy",
        opts = {
            ensure_installed = {
                "vimls",
                "texlab",
                "lua_ls",
                "pyright",
                "rust_analyzer",
                "bashls",
                "r_language_server",
                "jsonls",
                "gopls",
                "ts_ls",
            },
            automatic_installation = false,
        },
    },

    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            { "ms-jpq/coq_nvim",      branch = "coq" },
            { "ms-jpq/coq.artifacts", branch = "artifacts" },
        },
        config = function()
            local coq = require("coq")
            local lspconfig = require("lspconfig")
            local util = require("lspconfig.util")

            local capabilities = coq.lsp_ensure_capabilities(vim.lsp.protocol.make_client_capabilities())
            local flags = { debounce_text_changes = 150 }

            -- Keymaps / buffer-local settings whenever ANY LSP attaches
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true }),
                callback = function(ev)
                    local bufnr = ev.buf
                    local client = vim.lsp.get_client_by_id(ev.data.client_id)

                    -- Safety: if the same server name attaches twice, stop the newer one
                    if client and client.name then
                        for _, c in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
                            if c.id ~= client.id and c.name == client.name then
                                client.stop()
                                return
                            end
                        end
                    end

                    local function bmap(mode, lhs, rhs, desc)
                        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, noremap = true, desc = desc })
                    end

                    vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
                    bmap("n", "ga", vim.lsp.buf.code_action, "LSP code action")
                    bmap("n", "gd", vim.lsp.buf.definition, "LSP definition")
                    bmap("n", "gD", vim.lsp.buf.declaration, "LSP declaration")
                    bmap("n", "gr", vim.lsp.buf.references, "LSP references")
                    bmap("n", "gi", vim.lsp.buf.implementation, "LSP implementation")
                    bmap("n", "K", vim.lsp.buf.hover, "LSP hover")
                    bmap("n", "<leader>rn", vim.lsp.buf.rename, "LSP rename")
                end,
            })

            local function pyright_cmd()
                local cmd = vim.fn.stdpath("data") .. "/mason/bin/pyright-langserver"
                if vim.fn.executable(cmd) == 0 then
                    cmd = vim.fn.exepath("pyright-langserver")
                end
                if cmd == "" or vim.fn.executable(cmd) == 0 then
                    error("pyright-langserver not found (check :Mason and PATH)")
                end
                return { cmd, "--stdio" }
            end

            -- LUA
            lspconfig.lua_ls.setup({
                capabilities = capabilities,
                flags = flags,
                settings = {
                    Lua = {
                        runtime = { version = "LuaJIT" },
                        diagnostics = { globals = { "vim" } },
                        workspace = { library = vim.api.nvim_get_runtime_file("", true) },
                        telemetry = { enable = false },
                    },
                },
            })

            -- PYRIGHT
            lspconfig.pyright.setup({
                cmd = pyright_cmd(),
                capabilities = capabilities,
                flags = flags,
                root_dir = function(fname)
                    return util.root_pattern("pyproject.toml", "setup.cfg", "setup.py", ".git")(fname)
                        or util.path.dirname(fname)
                end,
                on_new_config = function(config, root_dir)
                    local sep = package.config:sub(1, 1)
                    local venv = root_dir .. sep .. ".venv"
                    local py = venv .. (sep == "\\" and "\\Scripts\\python.exe" or "/bin/python")
                    if vim.fn.filereadable(py) == 1 then
                        config.settings = config.settings or {}
                        config.settings.python = config.settings.python or {}
                        config.settings.python.venvPath = root_dir
                        config.settings.python.venv = ".venv"
                        config.settings.python.pythonPath = py
                    end
                end,
                settings = {
                    python = { analysis = { autoSearchPaths = true, useLibraryCodeForTypes = true } },
                },
            })

            -- R (manual start)
            lspconfig.r_language_server.setup({
                capabilities = capabilities,
                flags = flags,
                filetypes = { "r", "rmd", "quarto", "rnoweb" },
                single_file_support = false,
                autostart = false,
                settings = { r = { lsp = { diagnostics = true } } },
            })

            -- GO
            lspconfig.gopls.setup({
                capabilities = capabilities,
                flags = flags,
                settings = {
                    gopls = {
                        experimentalPostfixCompletions = true,
                        analyses = { unusedparams = true, shadow = true },
                        staticcheck = true,
                    },
                },
            })

            -- RUST
            lspconfig.rust_analyzer.setup({
                capabilities = capabilities,
                flags = flags,
                settings = {
                    ["rust-analyzer"] = {
                        assist = { importGranularity = "module", importPrefix = "self" },
                        cargo = { loadOutDirsFromCheck = true },
                        procMacro = { enable = true },
                    },
                },
            })

            -- TERRAFORM
            lspconfig.terraformls.setup({
                capabilities = capabilities,
                flags = flags,
                root_dir = function(fname)
                    return util.root_pattern("*.tf")(fname)
                        or util.root_pattern(".git")(fname)
                        or util.path.dirname(fname)
                end,
                on_attach = function(client)
                    client.server_capabilities.semanticTokensProvider = nil
                end,
            })

            -- Simple ones
            lspconfig.yamlls.setup({ capabilities = capabilities, flags = flags })
            lspconfig.clangd.setup({ capabilities = capabilities, flags = flags })
            lspconfig.bashls.setup({ capabilities = capabilities, flags = flags })
            lspconfig.vimls.setup({ capabilities = capabilities, flags = flags })
            lspconfig.jsonls.setup({ capabilities = capabilities, flags = flags })
            lspconfig.texlab.setup({ capabilities = capabilities, flags = flags })
            lspconfig.ts_ls.setup({
                cmd = { "typescript-language-server", "--stdio" },
                filetypes = {
                    "typescript",
                    "typescriptreact",
                    "javascript",
                    "javascriptreact",
                },

                capabilities = capabilities,
                flags = flags,
                on_attach = function(client)
                    client.server_capabilities.documentFormattingProvider = false
                    client.server_capabilities.documentRangeFormattingProvider = false
                end,
            })
        end,
    },
}

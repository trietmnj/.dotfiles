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
                "ruff-lsp",
                "rust-analyzer",
                "bash-language-server",
                "vim-language-server",
                "r-languageserver",
                "gopls",

                -- Formatters / linters / misc
                "black",
                "ruff",
                "debugpy",
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
                "ruff",
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
            -- Use the new 0.11+ API for configurations
            local lsp = vim.lsp
            local util = require("lspconfig.util")

            local capabilities = coq.lsp_ensure_capabilities(lsp.protocol.make_client_capabilities())
            local flags = { debounce_text_changes = 150 }

            -- Keymaps / buffer-local settings whenever ANY LSP attaches
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true }),
                callback = function(ev)
                    local bufnr = ev.buf
                    local client = vim.lsp.get_client_by_id(ev.data.client_id)

                    -- Safety: if the same server name attaches twice, stop the newer one
                    if client and client.name then
                        for _, c in ipairs(lsp.get_clients({ bufnr = bufnr })) do
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
                    -- Disable keywordprg so K uses LSP hover correctly
                    vim.bo[bufnr].keywordprg = ""
                    
                    bmap("n", "ga", lsp.buf.code_action, "LSP code action")
                    bmap("n", "gd", lsp.buf.definition, "LSP definition")
                    bmap("n", "gD", lsp.buf.declaration, "LSP declaration")
                    bmap("n", "gr", lsp.buf.references, "LSP references")
                    bmap("n", "gi", lsp.buf.implementation, "LSP implementation")
                    bmap("n", "K", lsp.buf.hover, "LSP hover")
                    bmap("n", "<C-k>", lsp.buf.hover, "LSP hover (fallback)")
                    bmap("n", "<leader>rn", lsp.buf.rename, "LSP rename")
                end,
            })

            -- LUA
            vim.lsp.config("lua_ls", {
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
            vim.lsp.config("pyright", {
                capabilities = capabilities,
                flags = flags,
                settings = {
                    python = {
                        analysis = {
                            autoSearchPaths = true,
                            useLibraryCodeForTypes = true,
                            diagnosticMode = "workspace",
                        },
                    },
                },
                root_dir = function(fname)
                    return util.root_pattern("pyproject.toml", "setup.cfg", "setup.py", ".git", "requirements.txt")(fname)
                end,
            })

            -- RUFF (Linting)
            vim.lsp.config("ruff", {
                capabilities = capabilities,
                flags = flags,
                on_attach = function(client)
                    -- Disable hover in favor of Pyright
                    client.server_capabilities.hoverProvider = false
                end,
            })
            vim.lsp.enable({ "pyright", "ruff" })

            -- R (manual start)
            vim.lsp.config("r_language_server", {
                capabilities = capabilities,
                flags = flags,
                filetypes = { "r", "rmd", "quarto", "rnoweb" },
                single_file_support = false,
                autostart = false,
                settings = { r = { lsp = { diagnostics = true } } },
            })

            -- GO
            vim.lsp.config("gopls", {
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
            vim.lsp.config("rust_analyzer", {
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
            vim.lsp.config("terraformls", {
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
            vim.lsp.enable("yamlls", { capabilities = capabilities, flags = flags })
            vim.lsp.enable("clangd", { capabilities = capabilities, flags = flags })
            vim.lsp.enable("bashls", { capabilities = capabilities, flags = flags })
            vim.lsp.enable("vimls", { capabilities = capabilities, flags = flags })
            vim.lsp.enable("jsonls", { capabilities = capabilities, flags = flags })
            vim.lsp.enable("texlab", { capabilities = capabilities, flags = flags })
            vim.lsp.enable("ts_ls", {
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

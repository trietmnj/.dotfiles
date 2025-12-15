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
                    package_installed   = "✓",
                    package_pending     = "➜",
                    package_uninstalled = "✗",
                },
            },
        },
    },

    -- Automate tools installation
    -- convenience layer on top of Mason.
    -- ensures installed/updated on startup
    -- (with debounce and delays so it doesn’t hammer your CPU/network)
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        event = "VeryLazy",
        dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
        opts = {
            ensure_installed = {
                -- LSP servers (tool names, not lspconfig ids)
                "lua-language-server", "pyright", "rust-analyzer",
                "bash-language-server", "vim-language-server",
                "r-languageserver", "gopls",

                -- "texlab", "ts_ls", "stylua", "ruff",

                -- Formatters / linters / misc
                "black", "shellcheck",
                "editorconfig-checker", "shfmt", "vint",
            },
            auto_update      = true,
            run_on_start     = true,
            start_delay      = 3000,
            debounce_hours   = 5,
        },
    },

    -- Mason ↔ lspconfig bridge (install by lspconfig id)
    -- The “bridge” that maps Mason’s tool names ↔ nvim-lspconfig’s server IDs
    {
        "williamboman/mason-lspconfig.nvim",
        event = { "BufReadPre" },
        opts = {
            -- Keep these stable ids; TS is handled dynamically in the lspconfig block
            ensure_installed = {
                "vimls", "texlab",

                "lua_ls", "pyright", "rust_analyzer", "bashls",
                "r_language_server", "jsonls", "gopls",
                "ts_ls"
            },
            automatic_installation = false,
        },
    },

    -- LSP setups
    -- official collection of ready-made configurations for LSP servers
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            { "ms-jpq/coq_nvim",      branch = "coq" },
            { "ms-jpq/coq.artifacts", branch = "artifacts" },
        },
        config = function()
            local lspconfig = require("lspconfig")
            local coq       = require("coq")
            local util      = require("lspconfig.util")
            local flags     = { debounce_text_changes = 150 }

            -- tiny helpers
            local function bmap(buf, mode, lhs, rhs, desc)
                vim.keymap.set(mode, lhs, rhs, { buffer = buf, silent = true, noremap = true, desc = desc })
            end

            local function on_attach(_, bufnr)
                vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
                bmap(bufnr, "n", "ga", vim.lsp.buf.code_action, "LSP code action")
                bmap(bufnr, "n", "gd", vim.lsp.buf.definition, "LSP definition")
                bmap(bufnr, "n", "gD", vim.lsp.buf.declaration, "LSP declaration")
                bmap(bufnr, "n", "gr", vim.lsp.buf.references, "LSP references")
                bmap(bufnr, "n", "gi", vim.lsp.buf.implementation, "LSP implementation")
                bmap(bufnr, "n", "K", vim.lsp.buf.hover, "LSP hover")
                bmap(bufnr, "n", "<leader>rn", vim.lsp.buf.rename, "LSP rename")
            end

            -- SAFE existence check (bypasses lspconfig __index)
            local function has_server(name)
                if not name then return false end
                if rawget(lspconfig, name) ~= nil then return true end
                return require("lspconfig.configs")[name] ~= nil
            end

            local function setup(name, cfg)
                -- if has_server(name) then
                --     lspconfig[name].setup(coq.lsp_ensure_capabilities(vim.tbl_extend("force", {
                --         on_attach = on_attach, flags = flags,
                --     }, cfg or {})))
                -- else
                --     vim.notify(("lspconfig: server '%s' not found; skipping"):format(name), vim.log.levels.WARN)
                -- end
                lspconfig[name].setup(coq.lsp_ensure_capabilities(vim.tbl_extend("force", {
                    on_attach = on_attach, flags = flags,
                }, cfg or {})))
            end

            -- Core servers you have
            setup("lua_ls", {
                settings = {
                    Lua = {
                        runtime     = { version = "LuaJIT" },
                        diagnostics = { globals = { "vim" } },
                        workspace   = { library = vim.api.nvim_get_runtime_file("", true) },
                        telemetry   = { enable = false },
                    },
                },
            })

            setup("pyright", {
                root_dir = util.root_pattern("pyproject.toml", "setup.cfg", "setup.py", ".git"),
                on_new_config = function(config, root_dir)
                    -- auto-pick project .venv if present
                    local sep, venv = package.config:sub(1, 1), root_dir .. package.config:sub(1, 1) .. ".venv"
                    local py = venv .. (sep == "\\" and "\\Scripts\\python.exe" or "/bin/python")
                    if vim.fn.filereadable(py) == 1 then
                        config.settings                   = config.settings or {}
                        config.settings.python            = config.settings.python or {}
                        config.settings.python.venvPath   = root_dir
                        config.settings.python.venv       = ".venv"
                        config.settings.python.pythonPath = py
                    end
                end,
                settings = { python = { analysis = { autoSearchPaths = true, useLibraryCodeForTypes = true } } },
            })

            setup("r_language_server", {
                filetypes           = { "r", "rmd", "quarto", "rnoweb" },
                settings            = { r = { lsp = { diagnostics = true } } },
                single_file_support = false,
                autostart           = false,
            })

            local function on_attach_dedupe(client, bufnr)
                for _, c in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
                    if c.name == "gopls" and c.id ~= client.id then
                        c.stop()
                    end
                end
                on_attach(client, bufnr)
            end

            setup("gopls", {
                on_attach = on_attach_dedupe,
                cmd = { "gopls" },
                filetypes = { "go", "gomod" },
                settings = {
                    gopls = {
                        experimentalPostfixCompletions = true,
                        analyses = { unusedparams = true, shadow = true },
                        staticcheck = true,
                    },
                },
            })

            setup("rust_analyzer", {
                settings = {
                    ["rust-analyzer"] = {
                        assist    = { importGranularity = "module", importPrefix = "self" },
                        cargo     = { loadOutDirsFromCheck = true },
                        procMacro = { enable = true },
                    },
                },
            })

            setup("terraformls", {
                root_dir = function(fname)
                    local util = require("lspconfig.util")
                    return util.root_pattern("*.tf")(fname)
                        or util.root_pattern(".git")(fname)
                        or util.path.dirname(fname)
                end,
                on_attach = function(client, bufnr)
                    on_attach(client, bufnr)
                    client.server_capabilities.semanticTokensProvider = nil
                end,
            })

            setup("yamlls")
            setup("clangd")

            -- Already in your list:
            for _, s in ipairs({ "bashls", "vimls", "jsonls", "texlab" }) do setup(s) end

            -- TypeScript/JavaScript: pick whichever your lspconfig exposes
            local ts = (has_server("ts_ls") and "ts_ls") or (has_server("tsserver") and "tsserver") or nil
            if ts then setup(ts) else vim.notify("No TS LSP (ts_ls/tsserver) found in lspconfig", vim.log.levels.WARN) end

            -- Optional: only if lspconfig actually registers 'air'
            if has_server("air") then
                lspconfig.air.setup({
                    filetypes = { "r", "rmd", "quarto", "rnoweb" },
                    on_attach = function(client, bufnr)
                        on_attach(client, bufnr)
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            buffer = bufnr,
                            callback = function() vim.lsp.buf.format() end,
                            desc = "Air: format R on save",
                        })
                    end,
                    flags = flags,
                })
            end
        end,
    },

}

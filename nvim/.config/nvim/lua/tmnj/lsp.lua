local nvim_lsp = require('lspconfig')
vim.api.nvim_exec([[let g:coq_settings = { 'auto_start': 'shut-up' }]], true)
local coq = require("coq")

local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap = true, silent = true }
    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'ga', '<Cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-l>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

    -- Set some keybinds conditional on server capabilities
    -- if client.resolved_capabilities.document_formatting then
    --     buf_set_keymap("n", "ff", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    -- elseif client.resolved_capabilities.document_range_formatting then
    --     buf_set_keymap("n", "ff", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
    -- end
    if client.server_capabilities.document_formatting then
        buf_set_keymap("n", "ff", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    elseif client.server_capabilities.document_range_formatting then
        buf_set_keymap("n", "ff", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
    end

    -- Set autocommands conditional on server_capabilities
    -- if client.resolved_capabilities.document_highlight then
    --     vim.api.nvim_exec([[
    --   hi LspReferenceRead cterm=bold ctermbg=DarkMagenta guibg=LightYellow
    --   hi LspReferenceText cterm=bold ctermbg=DarkMagenta guibg=LightYellow
    --   hi LspReferenceWrite cterm=bold ctermbg=DarkMagenta guibg=LightYellow
    --   augroup lsp_document_highlight
    --     autocmd! * <buffer>
    --     autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
    --     autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    --   augroup END
    -- ]]   , false)
    -- end

    -- require 'completion'.on_attach(client)
end

function goimports(timeoutms)
    local context = { source = { organizeImports = true } }
    vim.validate { context = { context, "t", true } }

    local params = vim.lsp.util.make_range_params()
    params.context = context

    -- See the implementation of the textDocument/codeAction callback
    -- (lua/vim/lsp/handler.lua) for how to do this properly.
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, timeout_ms)
    if not result or next(result) == nil then return end
    local actions = result[1].result
    if not actions then return end
    local action = actions[1]

    -- textDocument/codeAction can return either Command[] or CodeAction[]. If it
    -- is a CodeAction, it can have either an edit, a command or both. Edits
    -- should be executed first.
    if action.edit or type(action.command) == "table" then
        if action.edit then
            vim.lsp.util.apply_workspace_edit(action.edit)
        end
        if type(action.command) == "table" then
            vim.lsp.buf.execute_command(action.command)
        end
    else
        vim.lsp.buf.execute_command(action)
    end
end

vim.lsp.set_log_level("error")

-- lsp_installer
-- local lsp_installer = require("nvim-lsp-installer")
-- lsp_installer.setup({
--     automatic_installation = true, -- automatically detect which servers to install (based on which servers are set up via lspconfig)
--     ui = {
--         icons = {
--             server_installed = "✓",
--             server_pending = "➜",
--             server_uninstalled = "✗"
--         }
--     }
-- })

-- lsp_installer.on_server_ready(function(server)
--     local opts = {}

--     -- (optional) Customize the options passed to the server
--     -- if server.name == "tsserver" then
--     --     opts.root_dir = function() ... end
--     -- end

--     if server.name == "rust_analyzer" then
--         require("rust-tools").setup {
--             -- The "server" property provided in rust-tools setup function are the
--             -- settings rust-tools will provide to lspconfig during init.            --
--             -- We merge the necessary settings from nvim-lsp-installer (server:get_default_options())
--             -- with the user's own settings (opts).
--             server = vim.tbl_deep_extend("force", server:get_default_options(), opts),
--         }
--         server:attach_buffers()
--         -- Only if standalone support is needed
--         require("rust-tools").start_standalone_if_required()
--     else
--     -- This setup() function is exactly the same as lspconfig's setup function (:help lspconfig-quickstart)
--         server:setup(opts)
--     end
--     vim.cmd [[ do User LspAttachBuffers ]]
-- end)


-- Setup lspconfig.
-- local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities.textDocument.completion.completionItem.snippetSupport = true

local servers = {
    'jedi_language_server',
    -- 'pyright',
    -- 'rust_analyzer',
    'tsserver',
    -- 'svelte',
    -- 'tailwindcss',
    -- 'vimls',
    'jsonls',
    -- 'html',
    -- 'dockerls',
    -- 'lemminx',
    -- 'sumneko_lua',
    'gopls',
    -- 'cssls',
    -- 'solargraph',
    'omnisharp',
    'csharp_ls',
    'clangd'
}
for _, lsp in pairs(servers) do
    if lsp == 'gopls' then
        nvim_lsp[lsp].setup(coq.lsp_ensure_capabilities({
            cmd = { 'gopls', 'serve' },
            filetypes = { "go", "gomod" },
            -- root_dir = root_pattern("go.mod", ".git"),
            -- for postfix snippets and analyzers
            -- capabilities = capabilities,
            settings = {
                gopls = {
                    experimentalPostfixCompletions = true,
                    analyses = {
                        unusedparams = true,
                        shadow = true,
                    },
                    staticcheck = true,
                },
            },
            on_attach = on_attach,
        }))
    elseif lsp == 'rust_analyzer' then
        nvim_lsp[lsp].setup(coq.lsp_ensure_capabilities({
            -- capabilities = capabilities,
            on_attach = on_attach,
            settings = {
                ["rust-analyzer"] = {
                    assist = {
                        importGranularity = "module",
                        importPrefix = "self",
                    },
                    cargo = {
                        loadOutDirsFromCheck = true
                    },
                    procMacro = {
                        enable = true
                    },
                }
            }
        }))
    else
        nvim_lsp[lsp].setup(coq.lsp_ensure_capabilities({
            -- capabilities = capabilities,
            on_attach = on_attach,
        }))
    end
end

-- nvim_lsp['sumneko_lua'].setup(coq.lsp_ensure_capabilities( {
--     -- capabilities = capabilities,
--     on_attach = on_attach,
-- }))

-- treesitter
require 'nvim-treesitter.configs'.setup {
    indent = { enable = true },
    highlight = { enable = true },
    incremental_selection = { enable = true },
    textobjects = { enable = true },
    rainbow = {
        enable = true,
        -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
        extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        max_file_lines = nil, -- Do not enable for files with more than n lines, int
        colors = {
            '#97e023',
            '#78DCE8',
            '#dfd561',
            '#fa8419',
            '#9c64fe'
        }, -- table of hex strings
        -- termcolors = {} -- table of colour name strings
    },
    context_commentstring = {
        enable = true
    }
}

require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

require("mason-lspconfig").setup({
    ensured_installed = {"jedi_language_server", "jsonls" }
})

vim.keymap.set('i', '<Tab>', 'copilot#Accept("\\<CR>")', {
          expr = true,
          replace_keycodes = false
        })
        -- vim.g.copilot_no_tab_map = true
        --

-- map <C-0> to open the copilot panel
vim.keymap.set('n', '<C-y>', ':Copilot panel <CR>', { silent = false })


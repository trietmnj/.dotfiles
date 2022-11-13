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

    if client.server_capabilities.document_formatting then
        buf_set_keymap("n", "ff", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    elseif client.server_capabilities.document_range_formatting then
        buf_set_keymap("n", "ff", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
    end
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

local servers = {
    'jedi_language_server',
    -- 'pyright',
    'rust_analyzer',
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
    'csharp_ls'
}
local nvim_lsp = require('lspconfig')
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
-- require 'nvim-treesitter.configs'.setup {
--     ensure_installed = { "c", "rust", "go", "typescript" },
--     indent = { enable = true },
--     highlight = { enable = true },
--     incremental_selection = { enable = true },
--     textobjects = { enable = true },
--     rainbow = {
--         enable = true,
--         -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
--         extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
--         max_file_lines = nil, -- Do not enable for files with more than n lines, int
--         colors = {
--             '#97e023',
--             '#78DCE8',
--             '#dfd561',
--             '#fa8419',
--             '#9c64fe'
--         }, -- table of hex strings
--         -- termcolors = {} -- table of colour name strings
--     },
--     context_commentstring = {
--         enable = true
--     }
-- }

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

local nvim_lsp = require('lspconfig')

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'ga', '<Cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
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
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "ff", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("n", "ff", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      hi LspReferenceRead cterm=bold ctermbg=DarkMagenta guibg=LightYellow
      hi LspReferenceText cterm=bold ctermbg=DarkMagenta guibg=LightYellow
      hi LspReferenceWrite cterm=bold ctermbg=DarkMagenta guibg=LightYellow
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

nvim_lsp.gopls.setup{
	cmd = {'gopls', 'serve'},
    filetypes = { "go", "gomod" },
    -- root_dir = root_pattern("go.mod", ".git"),
	-- for postfix snippets and analyzers
	capabilities = capabilities,
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
	-- on_attach = on_attach,
}

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

-- Setup nvim-cmp.
local cmp = require'cmp'
cmp.setup({
    snippet = {
        expand = function(args)
            -- For `vsnip` user.
            -- vim.fn["vsnip#anonymous"](args.body)

            -- For `luasnip` user.
            require('luasnip').lsp_expand(args.body)

            -- For `ultisnips` user.
            -- vim.fn["UltiSnips#Anon"](args.body)
        end,
    },
    mapping = {
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },

    sources = {
        { name = 'nvim_lsp' },

        -- For vsnip user.
        -- { name = 'vsnip' },

        -- For luasnip user.
        { name = 'luasnip' },

        -- For ultisnips user.
        -- { name = 'ultisnips' },

        { name = 'buffer' },
    }
})

-- lsp_installer
local lsp_installer = require("nvim-lsp-installer")
lsp_installer.settings {
    ui = {
        icons = {
            server_installed = "✓",
            server_pending = "➜",
            server_uninstalled = "✗"
        }
    }
}

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

require("nvim-lsp-installer").setup {}
require("rust-tools").setup {
    -- server = { on_attach = on_attach }
}

-- local lspconfig = require("lspconfig")
nvim_lsp.tsserver.setup {}
nvim_lsp.svelte.setup {}
nvim_lsp.tailwindcss.setup {}
nvim_lsp.vimls.setup {}
nvim_lsp.jsonls.setup {}
nvim_lsp.html.setup {}
nvim_lsp.dockerls.setup {}
nvim_lsp.lemminx.setup {}
nvim_lsp.rust_analyzer.setup{}

-- treesitter
require'nvim-treesitter.configs'.setup {
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

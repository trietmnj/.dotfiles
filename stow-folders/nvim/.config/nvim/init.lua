-- init.lua

-------------------------------------------------
-- Bootstrap lazy.nvim
-------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim", lazypath
    })
end
vim.opt.rtp:prepend(lazypath)

-------------------------------------------------
-- Core options / leader
-------------------------------------------------
vim.g.mapleader = " "

-------------------------------------------------
-- Globals migrated from vimscript
-------------------------------------------------
-- VimTeX
vim.g.tex_flavor = "latex"
vim.g.vimtex_quickfix_mode = 0
vim.opt.conceallevel = 1
vim.g.tex_conceal = "abdmg"
vim.g.vimtex_view_general_viewer = vim.g.vimtex_view_general_viewer or "~/.dotfiles/mupdf.sh"
vim.g.vimtex_view_general_options = "@pdf"

-- UltiSnips (if you re-enable it later)
vim.g.UltiSnipsExpandTrigger = "<tab>"
vim.g.UltiSnipsJumpForwardTrigger = "<tab>"
vim.g.UltiSnipsJumpBackwardTrigger = "<S-tab>"

-- WSL clipboard
if vim.fn.has("wsl") == 1 then
    vim.g.clipboard = {
        name = "wslclipboard",
        copy = {
            ["+"] = "/mnt/c/Applications/win32yank-x64/win32yank.exe -i --crlf",
            ["*"] = "/mnt/c/Applications/win32yank-x64/win32yank.exe -i --crlf",
        },
        paste = {
            ["+"] = "/mnt/c/Applications/win32yank-x64/win32yank.exe -o --lf",
            ["*"] = "/mnt/c/Applications/win32yank-x64/win32yank.exe -o --lf",
        },
        cache_enabled = 1,
    }
end

-------------------------------------------------
-- Small utilities
-------------------------------------------------
-- Trim trailing whitespace on save
local function trim_whitespace()
    local view = vim.fn.winsaveview()
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.winrestview(view)
end

-- Go: format on save (use the modern API)
local function format_on_save()
    pcall(vim.lsp.buf.format, { async = false })
end

-- Autocmds
local aug = vim.api.nvim_create_augroup("AUTO", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", { group = aug, pattern = "*", callback = trim_whitespace })
vim.api.nvim_create_autocmd("BufWritePre", { group = aug, pattern = "*.go", callback = format_on_save })

-------------------------------------------------
-- Plugins (converted from Plug → lazy.nvim)
-------------------------------------------------
require("lazy").setup({
    -- Dependencies / utilities
    { "nvim-lua/plenary.nvim", lazy = true },
    { "nvim-lua/popup.nvim",   lazy = true },

    -- Telescope + extensions
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            -- Optional, fast sorter (will be loaded with pcall)
            {
                "nvim-telescope/telescope-fzy-native.nvim",
                build = "make",
                cond = function()
                    return vim.fn.executable(
                        "make") == 1
                end
            },
            -- Optional git worktrees
            { "ThePrimeagen/git-worktree.nvim" },
        },
        config = function()
            require("tmnj.telescope").setup()
        end,
    },

    -- Navigation / motion
    { "unblevable/quick-scope",         event = "VeryLazy" },
    {
        "ggandor/lightspeed.nvim",
        event = "VeryLazy",
        config = function()
            require("lightspeed").setup({
                ignore_case = true,
                exit_after_idle_msecs = { unlabeled = 1000, labeled = nil },
                jump_to_unique_chars = { safety_timeout = 400 },
                match_only_the_start_of_same_char_seqs = true,
                force_beacons_into_match_width = false,
                substitute_chars = { ["\r"] = "¬" },
                special_keys = {
                    next_match_group = "<space>",
                    prev_match_group = "<tab>",
                },
                limit_ft_matches = 4,
                repeat_ft_with_target_char = false,
            })
        end,
    },
    { "ThePrimeagen/harpoon",           event = "VeryLazy" },

    -- UI / Themes
    { "tanvirtin/monokai.nvim",         lazy = true },
    { "vim-airline/vim-airline",
        event = "VeryLazy" ,
        dependencies = { "liuchengxu/vista.vim" }
    },
    { "vim-airline/vim-airline-themes", event = "VeryLazy" },
    { "ryanoasis/vim-devicons",         lazy = true }, -- font icons (vim plugin)
    { "nvim-tree/nvim-web-devicons",    lazy = true },
    { "Xuyuanp/nerdtree-git-plugin",    dependencies = { "preservim/nerdtree" }, lazy = true },
    { "airblade/vim-gitgutter",         event = "BufReadPre" },
    { "Yggdroot/indentLine",            event = "VeryLazy" },
    { "gko/vim-coloresque",             ft = { "css", "scss", "sass", "less" } },
    {
        "norcalli/nvim-colorizer.lua",
        event = "BufReadPre",
        config = function() require("colorizer").setup() end,
    },

    -- LSP + tooling
    { "neovim/nvim-lspconfig",        event = "BufReadPre" },
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        event = "VeryLazy",
        config = function() require("mason").setup() end,
    },

    {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
      },
      event = "VeryLazy",
      -- Lazy will call require("mason-tool-installer").setup(opts)
      opts = {
        ensure_installed = {
          -- LSPs
          "lua-language-server",
          "pyright",
          "rust-analyzer",
          -- Formatters/linters
          "stylua",
          "black",
          "ruff",
        },
        run_on_start = true,
        start_delay = 3000,  -- ms
        debounce_hours = 5,
      },
    },

    {
        "williamboman/mason-lspconfig.nvim",
        event = "VeryLazy",
        config = function() require("mason-lspconfig").setup() end,
    },
    {
        "folke/neodev.nvim",
        ft = "lua",
        config = function()
            require("neodev").setup({})
        end
    },

    -- Completion (your choice: COQ + artifacts/thirdparty)
    { "ms-jpq/coq_nvim",              branch = "coq",                                                                     event = "InsertEnter" },
    { "ms-jpq/coq.artifacts",         branch = "artifacts",                                                               event = "VeryLazy" },
    { "ms-jpq/coq.thirdparty",        branch = "3p",                                                                      event = "VeryLazy" },

    -- Utils
    { "mattn/emmet-vim",              ft = { "html", "css", "sass", "scss", "javascript", "typescript", "vue", "svelte" } },
    { "hashivim/vim-terraform",       ft = { "tf", "terraform" } },
    { "simrat39/rust-tools.nvim",     ft = "rust" },
    { "rust-lang/rust.vim",           ft = "rust" },
    { "leafOfTree/vim-svelte-plugin", ft = "svelte" },

    -- Trouble (v3 API)
    {
        "folke/trouble.nvim",
        branch = "main",
        cmd = "Trouble",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {},
        keys = {
            { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",              desc = "Diagnostics (workspace)" },
            { "<leader>xw", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Diagnostics (buffer)" },
            { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>",      desc = "Symbols" },
            { "<leader>xq", "<cmd>Trouble qflist toggle<cr>",                   desc = "Quickfix list" },
            { "<leader>xl", "<cmd>Trouble loclist toggle<cr>",                  desc = "Location list" },
        },
    },

    -- Debugger
    { "mfussenegger/nvim-dap", lazy = true },

    -- Window/layout
    { "szw/vim-maximizer",     keys = { { "<leader>z", ":MaximizerToggle<CR>", desc = "Toggle maximize" } } },

    -- Trees / syntax / code nav
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require("nvim-treesitter.configs").setup({
                highlight = { enable = true },
                indent = { enable = true },
                context_commentstring = { enable = true, enable_autocmd = false },
            })
        end,
    },
    { "nvim-treesitter/playground",                  cmd = "TSPlaygroundToggle" },
    { "preservim/nerdtree",                          cmd = "NERDTreeToggle" },
    { "tiagofumo/vim-nerdtree-syntax-highlight",     lazy = true },
    { "ThePrimeagen/git-worktree.nvim",              lazy = true },
    { "liuchengxu/vista.vim",                        cmd = "Vista" },

    -- Editing
    { "AndrewRadev/splitjoin.vim",                   keys = { { "gS", "<Plug>SplitjoinSplit" }, { "gJ", "<Plug>SplitjoinJoin" } } },
    { "LucHermitte/lh-vim-lib",                      lazy = true },
    { "LucHermitte/lh-brackets",                     event = "InsertEnter" },
    { "rhysd/vim-grammarous",                        cmd = "GrammarousCheck" },
    { "matze/vim-move",                              event = "VeryLazy" },
    { "godlygeek/tabular",                           cmd = "Tabularize" },

    -- Comments
    { "tpope/vim-commentary",                        keys = { "gc", "gcc" } },
    { "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },
    {
        "echasnovski/mini.nvim",
        version = false,
        event = "VeryLazy",
        config = function()
            -- Enable only what you need:
            require("mini.comment").setup()
        end,
    },

    -- Git
    { "tpope/vim-fugitive",      cmd = { "Git", "G", "Gdiffsplit", "Gvdiffsplit" } },
    { "tpope/vim-rhubarb",       lazy = true },
    { "BitsuMamo/cheat-sh-nvim", cmd = { "Cheat" } },

    -- LaTeX
    {
        "lervag/vimtex",
        ft = { "tex", "plaintex", "latex" },
        init = function()
            -- keep your viewer settings defined above
        end,
    },

    -- Snippets
    { "honza/vim-snippets",       lazy = true },

    -- AI
    { "github/copilot.vim",       event = "InsertEnter" },

    -- R (as in your list)
    { "jalvesaq/Nvim-R",          ft = { "r", "rmd", "rnoweb", "rhelp" } },
    { "ncm2/ncm2",                event = "InsertEnter" },
    { "gaalcaras/ncm-R",          ft = { "r", "rmd", "rnoweb" } },
    { "roxma/vim-hug-neovim-rpc", lazy = true },
    { "ncm2/ncm2-ultisnips",      lazy = true },
})

-------------------------------------------------
-- Your own Lua modules (optional)
-------------------------------------------------
pcall(require, "tmnj") -- keep your personal config if you have lua/tmnj/init.lua

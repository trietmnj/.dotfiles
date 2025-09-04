-- lua/plugins/ui.lua
return {
    { "tanvirtin/monokai.nvim", lazy = true },

    {
        "vim-airline/vim-airline",
        event = "VeryLazy",
        dependencies = {
          "vim-airline/vim-airline-themes",
          "liuchengxu/vista.vim",
        },
        init = function()
          -- Theme
          vim.g.airline_theme = "molokai"

          -- Enable tabline & powerline glyphs
          vim.g["airline#extensions#tabline#enabled"] = 1
          vim.g.airline_powerline_fonts = 1

          -- Symbols table
        vim.g.airline_symbols = {
            space = "\u{00A0}",
            crypt = "🔒",
            maxlinenr = "",
            paste = "Þ",
            whitespace = "Ξ",
            branch  = "",
            colnr   = " :",
            readonly= "",
            linenr  = " :",
            dirty   = "⚡",
            notexists = "?",
        }

          -- Powerline separators & icons (these override the simple unicode ones)
          vim.g.airline_left_sep        = ""
          vim.g.airline_left_alt_sep    = ""
          vim.g.airline_right_sep       = ""
          vim.g.airline_right_alt_sep   = ""

        end,
    },

    { "nvim-tree/nvim-web-devicons", lazy = true }, -- Lua devicons

    -- show git diff in sign column
    { "airblade/vim-gitgutter",      event = "BufReadPre" },

    -- show indent lines
    { "Yggdroot/indentLine",         event = "VeryLazy" },

    -- color schemes for different file types
    { "gko/vim-coloresque",          ft = { "css", "scss", "sass", "less" } },

    -- show color codes in their actual color e.g., #FF0000
    {
        "catgoose/nvim-colorizer.lua",
        event = "BufReadPre",
        config = function() require("colorizer").setup() end,
    },
}

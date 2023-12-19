-- init.lua
local opts =  {
    highlight_hovered_item = true,
    auto_preview = false,
    show_numbers = true,
    -- show_relative_numbers = true,
    show_symbol_details = true,
}

require("symbols-outline").setup({opts})

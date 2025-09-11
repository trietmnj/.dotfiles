-- lua/plugins/trouble.lua
return {
    {
        -- temp fix
        "h-michael/trouble.nvim",
        branch = "fix/decoration-provider-api",
        -- "folke/trouble.nvim",
        cmd = "Trouble",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {
            multiline = false,
            auto_preview = false,
        },
        keys = {
            { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (workspace)" },
            { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Diagnostics (buffer)" },
            { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (document)" },
            { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix" },
            { "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "Location List" },
            -- optional: LSP picker (defs/refs/impls/etc) in a right split
            { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP (defs/refs/…)" },
        },
    },
}

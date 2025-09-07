-- lua/plugins/trouble.lua
return {
    {
        "folke/trouble.nvim",
        cmd = "Trouble",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            "nvim-treesitter/nvim-treesitter",
        },
        init = function()
            -- Disable Treesitter inside Trouble buffers to avoid the crash
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "trouble",
                callback = function(args)
                    pcall(vim.treesitter.stop, args.buf)
                end,
            })
        end,
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

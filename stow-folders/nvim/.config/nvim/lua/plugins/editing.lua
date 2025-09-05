-- plugins/editing.lua
return {
    -- Split/Join
    {
        "AndrewRadev/splitjoin.vim",
        keys = { { "gS", "<Plug>SplitjoinSplit" }, { "gJ", "<Plug>SplitjoinJoin" } },
    },

    -- Tabular alignment
    {
        "godlygeek/tabular",
        cmd = "Tabularize",
        config = function()
            local map = vim.keymap.set
            local opts = { noremap = true, silent = true }
            map("n", "<leader>a=", ":Tabularize /=<CR>", vim.tbl_extend("force", opts, { desc = "Align by =" }))
            map("v", "<leader>a=", ":Tabularize /=<CR>", vim.tbl_extend("force", opts, { desc = "Align by =" }))
            map("n", "<leader>a:", ":Tabularize /:\\zs<CR>", vim.tbl_extend("force", opts, { desc = "Align by :" }))
            map("v", "<leader>a:", ":Tabularize /:\\zs<CR>", vim.tbl_extend("force", opts, { desc = "Align by :" }))
        end,
    },

    -- Treesitter-aware comment strings helper (lazy)
    { "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },

    -- Mini suite (modern Lua replacements)
    --  mini.pairs    - autopairs brackets/quotes/etc.
    --  mini.comment  - commenting (replaces tpope/vim-commentary)
    --  mini.surround - surround textobjects (optional, but recommended)
    --  mini.move    - move lines/blocks up/down
    {
        "echasnovski/mini.nvim",
        version = false,
        event = "VeryLazy",
        config = function()
            require("mini.pairs").setup()

            -- Commenting (drop tpope/vim-commentary to avoid overlap)
            require("mini.comment").setup({
                options = {
                    -- Integrate with ts-context-commentstring for language-aware comments
                    custom_commentstring = function()
                        local ok, internal = pcall(require, "ts_context_commentstring.internal")
                        if ok then
                            local cs = internal.calculate_commentstring()
                            if cs and cs ~= "" then return cs end
                        end
                        return nil
                    end,
                },
            })

            require("mini.move").setup()
        end,
    },

}

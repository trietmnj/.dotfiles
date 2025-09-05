-- lua/plugins/r.lua
return {

    {
        "R-nvim/R.nvim",
        ft = { "r", "rmd", "rnoweb", "quarto" },
        lazy = false,
        init = function()
            vim.filetype.add({ extension = { r = "r", R = "r", rmd = "rmd", Rmd = "rmd" } })
        end,
        config = function()
          require("r").setup({
            R_args = { "--quiet", "--no-save" },
            hook = {
              on_filetype = function()
                vim.keymap.set("n", "<localleader>r", "<Plug>RDSendLine",
                { buffer = true, remap = true, desc = "R: send line" })
                vim.keymap.set("v", "<localleader>r", "<Plug>RSendSelection",
                { buffer = true, remap = true, desc = "R: send selection" })
                vim.keymap.set("n", "<localleader>R", "<Plug>RStart",
                { buffer = true, remap = true, desc = "R: start session" })
                -- add more if you like:
                -- vim.keymap.set("n", "<localleader>q", "<Plug>RClose", { buffer = true, remap = true, desc = "R: quit" })
              end,
            },
            min_editor_width = 72,
            rconsole_width   = 78,
          })
        end,
    },

    { "ncm2/ncm2",           event = "InsertEnter" },

    { "gaalcaras/ncm-R",     ft = { "r", "rmd", "rnoweb" } },

    { "roxma/vim-hug-neovim-rpc", lazy = true },

    { "ncm2/ncm2-ultisnips", lazy = true },

}

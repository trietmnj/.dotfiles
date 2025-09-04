-- lua/plugins/r.lua
return {
    {
        "R-nvim/R.nvim",
        ft = { "r", "rmd", "rnoweb", "quarto" },
        -- lazy = false, -- uncomment if you prefer eager load
        config = function()
          require("r").setup({
            R_args = { "--quiet", "--no-save" },
            hook = {
              on_filetype = function()
                vim.api.nvim_buf_set_keymap(0, "n", "<CR>", "<Plug>RDSendLine", {})
                vim.api.nvim_buf_set_keymap(0, "v", "<CR>", "<Plug>RSendSelection", {})
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

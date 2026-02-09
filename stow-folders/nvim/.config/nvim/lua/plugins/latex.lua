-- lua/plugins/latex.lua
return {
    {
        "lervag/vimtex",
        ft = { "tex", "plaintex", "latex" },
        init = function()
            vim.g.tex_flavor = "latex"
            vim.g.vimtex_quickfix_mode = 0
            vim.opt.conceallevel = 1
            vim.g.tex_conceal = "abdmg"
            vim.g.vimtex_view_general_viewer = vim.g.vimtex_view_general_viewer or "~/.dotfiles/mupdf.sh"
            vim.g.vimtex_view_general_options = "@pdf"

            -- Wrap lines in TeX buffers (your snippet)
            local grp = vim.api.nvim_create_augroup("WrapLineInTeXFile", { clear = true })
            vim.api.nvim_create_autocmd("FileType", {
                group = grp,
                pattern = { "tex", "plaintex", "latex" },
                callback = function() vim.opt_local.wrap = true end,
            })
        end,
    },
}

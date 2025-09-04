-- lua/plugins/nerdtree.lua
return {
  {
    "preservim/nerdtree",
    cmd = { "NERDTreeToggle", "NERDTreeFind", "NERDTree" },
    dependencies = {
      "ryanoasis/vim-devicons",
      "Xuyuanp/nerdtree-git-plugin",
      "tiagofumo/vim-nerdtree-syntax-highlight",
    },
    init = function()
      vim.g.WebDevIconsUnicodeDecorateFolderNodes = 1
      vim.g.DevIconsEnableFoldersOpenClose = 1
      vim.g.WebDevIconsNerdTreeAfterGlyphPadding = "  "
      vim.g.NERDTreeGitStatusUseNerdFonts = 1
    end,
    keys = {
      { "<C-t>", "<cmd>NERDTreeToggle<CR>", mode = "n", desc = "NERDTree: Toggle" },
      {
        "<C-f>",
        function()
          local p = vim.fn.expand("%:p")
          if p ~= "" and vim.fn.filereadable(p) == 1 then
            vim.cmd("NERDTreeFind")
          else
            vim.cmd("NERDTreeToggle")
          end
        end,
        mode = "n",
        desc = "NERDTree: Find file",
      },
    },
  },
}

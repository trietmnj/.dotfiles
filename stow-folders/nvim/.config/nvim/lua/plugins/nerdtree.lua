-- lua/plugins/nerdtree.lua
return {
  {
    "preservim/nerdtree",
    cmd = "NERDTreeToggle",
    keys = {
      { "<leader>n", ":NERDTreeToggle<CR>", desc = "Toggle NERDTree" },
    },
  },

  {
    "Xuyuanp/nerdtree-git-plugin",
    dependencies = { "preservim/nerdtree" },
    lazy = true,
  },

  {
    "tiagofumo/vim-nerdtree-syntax-highlight",
    dependencies = { "preservim/nerdtree" },
    lazy = true,
  },

}

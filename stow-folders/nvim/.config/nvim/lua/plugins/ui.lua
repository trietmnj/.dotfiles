-- plugins/ai.lua
return {
  { "tanvirtin/monokai.nvim", lazy = true },
  {
    "vim-airline/vim-airline",
    event = "VeryLazy",
    dependencies = {
      "vim-airline/vim-airline-themes",
      -- load vista first or disable airline's vista extension:
      "liuchengxu/vista.vim",
    },
    -- If you don't use Vista, disable airline vista ext instead:
    -- init = function() vim.g["airline#extensions#vista#enabled"] = 0 end,
  },
  { "ryanoasis/vim-devicons",      lazy = true }, -- Vim devicons (fonts)
  { "nvim-tree/nvim-web-devicons", lazy = true }, -- Lua devicons
  { "Xuyuanp/nerdtree-git-plugin", dependencies = { "preservim/nerdtree" }, lazy = true },
  { "airblade/vim-gitgutter",      event = "BufReadPre" },
  { "Yggdroot/indentLine",         event = "VeryLazy" },
  { "gko/vim-coloresque",          ft = { "css", "scss", "sass", "less" } },
  {
    "norcalli/nvim-colorizer.lua",
    event = "BufReadPre",
    config = function() require("colorizer").setup() end,
  },
}

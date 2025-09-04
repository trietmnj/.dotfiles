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
  { "nvim-tree/nvim-web-devicons", lazy = true }, -- Lua devicons
    -- show git diff in sign column
  { "airblade/vim-gitgutter",      event = "BufReadPre" },
    -- show indent lines
  { "Yggdroot/indentLine",         event = "VeryLazy" },
    -- color schemes for different file types
  { "gko/vim-coloresque",          ft = { "css", "scss", "sass", "less" } },

  -- show color codes in their actual color e.g., #FF0000
  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    config = function() require("colorizer").setup() end,
  },
}

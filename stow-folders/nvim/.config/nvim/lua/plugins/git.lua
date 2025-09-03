-- plugins/git.lua
return {
  { "tpope/vim-fugitive",      cmd = { "Git", "G", "Gdiffsplit", "Gvdiffsplit" } },
  { "tpope/vim-rhubarb",       lazy = true },
  { "BitsuMamo/cheat-sh-nvim", cmd = { "Cheat" } },
}

-- plugins/r.lua
return {
  { "jalvesaq/Nvim-R",     ft = { "r", "rmd", "rnoweb", "rhelp" } },
  { "ncm2/ncm2",           event = "InsertEnter" },
  { "gaalcaras/ncm-R",     ft = { "r", "rmd", "rnoweb" } },
  { "roxma/vim-hug-neovim-rpc", lazy = true },
  { "ncm2/ncm2-ultisnips", lazy = true },
}

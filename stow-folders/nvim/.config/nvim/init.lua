-- init.lua

-------------------------------------------------
-- Small utilities
-------------------------------------------------
-- Trim trailing whitespace on save
local function trim_whitespace()
    local view = vim.fn.winsaveview()
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.winrestview(view)
end

-- Go: format on save (use the modern API)
local function format_on_save()
    pcall(vim.lsp.buf.format, { async = false })
end

-- Autocmds
local aug = vim.api.nvim_create_augroup("AUTO", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", { group = aug, pattern = "*", callback = trim_whitespace })
vim.api.nvim_create_autocmd("BufWritePre", { group = aug, pattern = "*.go", callback = format_on_save })

-------------------------------------------------
-- Core options / leader
-------------------------------------------------
vim.g.mapleader = " "

-------------------------------------------------
-- Setup lazy.nvim for package management
-------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim", lazypath
    })
end
vim.opt.rtp:prepend(lazypath)

-- load everything in lua/plugins/**
require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
})

-------------------------------------------------
-- Your own Lua modules (optional)
-------------------------------------------------
pcall(require, "modules")

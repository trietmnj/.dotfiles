-- init.lua

-------------------------------------------------
-- Logging
-------------------------------------------------
-- vim.lsp.set_log_level("WARN")

-------------------------------------------------
-- Autocmds
-------------------------------------------------
local aug = vim.api.nvim_create_augroup("AUTO", { clear = true })

-- Trim trailing whitespace on save
local function trim_whitespace()
    local view = vim.fn.winsaveview()
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.winrestview(view)
end
vim.api.nvim_create_autocmd("BufWritePre", { group = aug, pattern = "*", callback = trim_whitespace })

-- Go: format on save (use the modern API)
local function format_on_save()
    pcall(vim.lsp.buf.format, { async = false })
end
vim.api.nvim_create_autocmd("BufWritePre", { group = aug, pattern = "*.go", callback = format_on_save })

-- Kill r_language_server if it attaches to a non-R buffer
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client or client.name ~= "r_language_server" then
            return
        end
        local ft = vim.bo[args.buf].filetype
        if not ({ r = true, rmd = true, quarto = true, rnoweb = true })[ft] then
            vim.schedule(function()
                vim.lsp.stop_client(client.id)
            end)
        end
    end,
})

-- Disable semantic tokens for terraformls, even if Neovim started them first
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client or client.name ~= "terraformls" then return end

        -- 1) Remove capability so new semantic tokens won't start
        client.server_capabilities.semanticTokensProvider = nil

        -- 2) Stop any token provider that already started
        local buf = args.buf
        -- the new API path:
        if client.semantic_tokens then
            pcall(function() client.semantic_tokens:clear(buf) end)
            pcall(function() client.semantic_tokens:stop(buf) end)
        end
    end,
})

-------------------------------------------------
-- Leaders
-------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-------------------------------------------------
-- Setup lazy.nvim for package management
-------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim",
        lazypath,
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
-- Load modules
-------------------------------------------------
require("modules").setup()

-- lua/tmnj/keymaps.lua
local M = {}

function M.setup()

    local map = vim.keymap.set
    local opts = { noremap = true, silent = true }

    map("n", "<leader>ff", function()
    if vim.lsp.buf.format then
      pcall(vim.lsp.buf.format, { async = false })
    else
      vim.cmd("normal! gg=G")
    end
    end, opts)
    map("n", "<CR>",  ":bnext<CR>", { desc = "Next buffer" })
    map("n", "<C-m>", ":bnext<CR>", { desc = "Next buffer" })
    map("n", "<C-n>", ":bprev<CR>", { desc = "Previous buffer" })
    map("n", "<C-x>", ":bp <bar> bd #<CR>", { desc = "Close buffer" })

end

return M

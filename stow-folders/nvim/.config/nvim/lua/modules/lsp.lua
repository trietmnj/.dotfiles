-- lua/modules/lsp.lua
-- All LSP setup is now handled in: lua/plugins/lsp.lua
-- This module is kept for light editor glue only.

local M = {}

function M.setup()
  -- TeX: wrap lines in TeX buffers
  local grp = vim.api.nvim_create_augroup("WrapLineInTeXFile", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    group = grp,
    pattern = "tex",
    callback = function()
      vim.opt_local.wrap = true
    end,
  })
end

return M

-- lua/plugins/dvc.lua

-- Local DVC integration natively via Neovim terminal splits
vim.api.nvim_create_user_command("DVCStatus", "split | term dvc status", {})
vim.api.nvim_create_user_command("DVCPull", "split | term dvc pull", {})
vim.api.nvim_create_user_command("DVCPush", "split | term dvc push", {})
vim.api.nvim_create_user_command("DVCCheckout", "split | term dvc checkout", {})

-- DVCAdd defaults to the current file buffer if no argument is provided
vim.api.nvim_create_user_command("DVCAdd", function(opts)
  local target = opts.args
  if target == "" then
    target = vim.fn.expand("%")
  end
  vim.cmd("split | term dvc add " .. vim.fn.shellescape(target))
end, { nargs = "?" })

-- Return empty table for lazy.nvim since no external plugin is needed
return {}

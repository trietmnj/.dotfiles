-- lua/tmnj/navitation.lua
-- ================================
-- Lightspeed setup
-- ================================
require('lightspeed').setup({
  ignore_case = true,
  exit_after_idle_msecs = { unlabeled = 1000, labeled = nil },

  --- s/x ---
  jump_to_unique_chars = { safety_timeout = 400 },
  match_only_the_start_of_same_char_seqs = true,
  force_beacons_into_match_width = false,
  substitute_chars = { ['\r'] = '¬' },
  special_keys = {
    next_match_group = '<space>',
    prev_match_group = '<tab>',
  },

  --- f/t ---
  limit_ft_matches = 4,
  repeat_ft_with_target_char = false,
})

-- ================================
-- Helpers
-- ================================
local function clean_no_name_empty_buffers()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buflisted then
      local name = vim.api.nvim_buf_get_name(bufnr)
      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      local is_empty = (#lines == 0) or (#lines == 1 and lines[1] == '')
      if name == '' and is_empty then
        pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
      end
    end
  end
end

local qf_state = { quickfix = false, loclist = false }
local function toggle_qf_list(global)
  if global then
    if qf_state.quickfix then
      vim.cmd('cclose')
    else
      vim.cmd('copen')
    end
    qf_state.quickfix = not qf_state.quickfix
  else
    if qf_state.loclist then
      vim.cmd('lclose')
    else
      vim.cmd('lopen')
    end
    qf_state.loclist = not qf_state.loclist
  end
end

-- ================================
-- Keymaps
-- ================================
local map = vim.keymap.set
local opts = { silent = true }

-- Quickfix / Location list navigation
map('n', '<C-j>', '<cmd>cnext<CR>zz',  vim.tbl_extend('force', opts, { desc = 'Quickfix: next' }))
map('n', '<C-k>', '<cmd>cprev<CR>zz',  vim.tbl_extend('force', opts, { desc = 'Quickfix: prev' }))
map('n', '<leader>j', '<cmd>lnext<CR>zz', vim.tbl_extend('force', opts, { desc = 'Loclist: next' }))
map('n', '<leader>k', '<cmd>lprev<CR>zz', vim.tbl_extend('force', opts, { desc = 'Loclist: prev' }))

-- Toggle quickfix / loclist
map('n', '<C-q>', function() toggle_qf_list(true) end,  vim.tbl_extend('force', opts, { desc = 'Toggle quickfix window' }))
map('n', '<leader>q', function() toggle_qf_list(false) end, vim.tbl_extend('force', opts, { desc = 'Toggle loclist window' }))

-- Buffer management
map('n', '<leader>bd', function()
  -- Delete all listed buffers, then try to jump to alternate buffer, then cleanup
  vim.cmd('%bdelete')
  pcall(vim.cmd, 'edit #')
  clean_no_name_empty_buffers()
end, vim.tbl_extend('force', opts, { desc = 'Delete all buffers (reopen last) + clean scratch' }))

map('n', '<Enter>', '<cmd>bnext<CR>', vim.tbl_extend('force', opts, { desc = 'Next buffer' }))
map('n', '<C-n>',   '<cmd>bprev<CR>', vim.tbl_extend('force', opts, { desc = 'Prev buffer' }))
map('n', '<C-x>',   '<cmd>bp|bd #<CR>', vim.tbl_extend('force', opts, { desc = 'Close current buffer' }))

-- Insert-mode completion-friendly arrows
map('i', '<Down>', function()
  return vim.fn.pumvisible() == 1 and '<C-n>' or '<Down>'
end, { expr = true, silent = true, desc = 'Move down / next item when popup visible' })

map('i', '<Up>', function()
  return vim.fn.pumvisible() == 1 and '<C-p>' or '<Up>'
end, { expr = true, silent = true, desc = 'Move up / prev item when popup visible' })

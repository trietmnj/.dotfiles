vim.g.mapleader = ' '
local map = vim.api.nvim_set_keymap
map('n', 'y$', 'Y', { noremap = true })
map('n', 'nzzzv', 'n', { noremap = true })
map('n', 'Nzzzv', 'N', { noremap = true })
map('n', 'mzJ`z', 'J', { noremap = true })
map('i', ',<c-g>u', ',', { noremap = true })
map('i', '.<c-g>u', '.', { noremap = true })
map('i', '!<c-g>u', '!', { noremap = true })
map('i', '?<c-g>u', '?', { noremap = true })

map('n', '<C-s>', ':Vista!!<CR>', { noremap = true })
-- map('n', '<leader>ff', ':lua vim.lsp.buf.format({ async = true })<CR>', { noremap = false })
vim.keymap.set({ 'n', 'v' }, '<leader>ff', vim.lsp.buf.format, { noremap = false })

-- cheatsheet
map('n', '<leader>cs', ':call CheatSheetCommand()<CR>', { noremap = true })
map('n', '<leader>cc', ':call CheatSheetCursor()<CR>', { noremap = true })

-- Git
map('n', '<leader>gh', ':diffget //3<CR>', { noremap = true })
map('n', '<leader>gu', ':diffget //2<CR>', { noremap = true })
map('n', '<leader>gs', ':G<CR>', { noremap = true })

-- Harpoon
local hm = require("harpoon.mark")
local hu = require("harpoon.ui")
vim.keymap.set('n', '<leader>gh', hm.add_file, { noremap = true, silent = true })
vim.keymap.set('n', '<C-e>', hu.toggle_quick_menu, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>y', function() return hu.nav_file(1) end, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>u', function() return hu.nav_file(2) end, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>i', function() return hu.nav_file(3) end, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>o', function() return hu.nav_file(4) end, { noremap = true, silent = true })

-- don't know why this is remapped to something other than ~
vim.keymap.set('i', '~', '~', { noremap = true, silent = true })

-- Tabular
map('n', '<leader>a=', ':Tabularize /=<CR>', { noremap = true })
map('v', '<leader>a=', ':Tabularize /=<CR>', { noremap = true })
map('n', '<leader>a:', ':Tabularize /:\zs<CR>', { noremap = true })
map('v', '<leader>a:', ':Tabularize /:\zs<CR>', { noremap = true })

-- block visual
map('n', '<F4>', '<C-v>', { noremap = true })

-- turning :W to save file too
vim.api.nvim_create_user_command('W', function()
    vim.cmd('w') -- Save the file
    print("File saved! Use :w next time.")
end, {})

-- " TODO change from under_score to camelCase
-- vmap <leader>=++ :s#_\(\l\)#\u\1#g<CR>
-- function toggle_case_visual()
--     -- Get the start and end positions of the visual selection
--     local start_line, start_col, end_line, end_col = unpack(vim.fn.getpos("'<") + vim.fn.getpos("'>") - 1)
--     -- Get the visually selected text
--     local selected_text = vim.fn.getline(start_line, end_line):sub(start_col, end_col)
--     -- Check if the selected text contains underscores
--     if string.find(selected_text, '_') then
--         -- Convert underscore_case to camelCase
--         selected_text = selected_text:gsub('_(%l)', function(match) return match:sub(2):upper() end)
--     else
--         -- Convert camelCase to underscore_case
--         selected_text = selected_text:gsub('%u', function(match) return '_' .. match:lower() end)
--     end
--     -- Replace the visually selected text with the converted text
--     vim.fn.setline(start_line, vim.fn.getline(start_line):sub(1, start_col - 1) .. selected_text .. vim.fn.getline(end_line):sub(end_col + 1))
--     -- Set the cursor position to the end of the replacement text
--     vim.fn.cursor(end_line, start_col + #selected_text)
-- end
-- map('x', '<leader>++', [[:call v:lua.toggle_case_visual()<CR>]], { noremap = false })

local map = vim.api.nvim_set_keymap
map('n', 'y$', 'Y', { noremap = true })
map('n', 'nzzzv', 'n', { noremap = true })
map('n', 'Nzzzv', 'N', { noremap = true })
map('n', 'mzJ`z', 'J', { noremap = true })
map('i', ',<c-g>u', ',', { noremap = true })
map('i', '.<c-g>u', '.', { noremap = true })
map('i', '!<c-g>u', '!', { noremap = true })
map('i', '?<c-g>u', '?', { noremap = true })

map('n', '<c-s>', ':TagbarToggle<CR>', { noremap = true })
map('n', '<leader>ff', ':lua vim.lsp.buf.format({ async = true })<CR>', { noremap = false })
-- map('v', '<leader>=++', ':s#_\(\l\)#\u\1#g<CR>', { noremap = false })
map('n', '<leader>cs', ':call CheatSheetCommand()<CR>', { noremap = true })
map('n', '<leader>cc', ':call CheatSheetCursor()<CR>', { noremap = true })

-- nnoremap Y y$
-- nnoremap n nzzzv
-- nnoremap N Nzzzv
-- nnoremap J mzJ`z
-- inoremap , ,<c-g>u
-- inoremap . .<c-g>u
-- inoremap ! !<c-g>u
-- inoremap ? ?<c-g>u

-- " nnoremap <C-s> :SymbolsOutline<CR>
-- nnoremap <C-s> :TagbarToggle<CR>
-- " nmap <leader>ff :lua vim.lsp.buf.formatting()<CR>
-- " nmap <leader>ff :lua vim.lsp.buf.formatting()<CR>
-- nmap <leader>ff :lua vim.lsp.buf.format { async = true }<CR>

-- " nmap <leader>. :bnext<CR>
-- " nmap <leader>, :bp<CR>
-- " nmap <leader>n :bp <bar> bd #<CR>

-- " change from under_score to camelCase
-- vmap <leader>=++ :s#_\(\l\)#\u\1#g<CR>

-- " Use Cheat Sheat using command line
-- nnoremap <leader>cs :call CheatSheetCommand()<CR>
-- nnoremap <leader>cc :call CheatSheetCursor()<CR>

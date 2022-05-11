nnoremap Y y$
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u

" nnoremap <C-s> :SymbolsOutline<CR>
nnoremap <C-s> :TagbarToggle<CR>
nmap <leader>ff :lua vim.lsp.buf.formatting()<CR>

" nmap <leader>. :bnext<CR>
" nmap <leader>, :bp<CR>
" nmap <leader>n :bp <bar> bd #<CR>

" change from under_score to camelCase
vmap <leader>=++ :s#_\(\l\)#\u\1#g<CR>

" Use Cheat Sheat using command line
nnoremap <leader>cs :call CheatSheetCommand()<CR>
nnoremap <leader>cc :call CheatSheetCursor()<CR>

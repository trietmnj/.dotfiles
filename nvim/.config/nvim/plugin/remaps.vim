nnoremap Y y$
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u

nnoremap <C-s> :SymbolsOutline<CR>
nmap ff :lua vim.lsp.buf.formatting()<CR>
nmap <leader>b :bnext<CR>
nmap <leader>v :bp<CR>
nmap <leader>c :bp <bar> bd #<CR>
" change from under_score to camelCase
vmap <leader>=++ :s#_\(\l\)#\u\1#g<CR>

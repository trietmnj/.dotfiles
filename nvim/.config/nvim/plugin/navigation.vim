nnoremap <C-j> :cnext<CR>zz
nnoremap <C-k> :cprev<CR>zz
nnoremap <leader>j :lnext<CR>zz
nnoremap <leader>k :lprev<CR>zz

" delete all buffers, open nerdtree
" nnoremap <leader>bd :%bd <bar> NERDTree<CR>
nnoremap <leader>bd :%bdelete<bar>e #<bar>call CleanNoNameEmptyBuffers()<CR>

nnoremap <C-q> :call ToggleQFList(1)<CR>
nnoremap <leader>q :call ToggleQFList(0)<CR>

let g:_qf_l = 0
let g:_qf_g = 0

fun! ToggleQFList(global)
    if a:global
        if g:_qf_g == 1
            let g:_qf_g = 0
            cclose
        else
            let g:_qf_g = 1
            copen
        end
    else
        if g:_qf_l == 1
            let g:_qf_l = 0
            lclose
        else
            let g:_qf_l = 1
            lopen
        end
    endif
endfun

" Enter should be the same as C-m
" nmap <C-m> :bnext<CR>
nmap <Enter> :bnext<CR>
nmap <C-n> :bprev<CR>
nmap <C-x> :bp <bar> bd #<CR>

" inoremap  <Up>     <NOP>
" inoremap  <Down>   <NOP>
" inoremap  <Left>   <NOP>
" inoremap  <Right>  <NOP>
" noremap   <Up>     <NOP>
" noremap   <Down>   <NOP>
" noremap   <Left>   <NOP>
" noremap   <Right>  <NOP>
"
inoremap <expr> <down> ((pumvisible())?("\<C-n>"):("\<down>"))
inoremap <expr> <up> ((pumvisible())?("\<C-p>"):("\<up>"))

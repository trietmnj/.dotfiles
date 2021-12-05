nnoremap <C-j> :cnext<CR>zz
nnoremap <C-k> :cprev<CR>zz
nnoremap <leader>j :lnext<CR>zz
nnoremap <leader>k :lprev<CR>zz

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

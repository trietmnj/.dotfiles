nnoremap <silent><leader>a :lua require("harpoon.mark").add_file()<CR>
nnoremap <silent><C-e> :lua require("harpoon.ui").toggle_quick_menu()<CR>
nnoremap <silent><leader>tc :lua require("harpoon.cmd-ui").toggle_quick_menu()<CR>

nnoremap <silent><leader>y :lua require("harpoon.ui").nav_file(1)<CR>
nnoremap <silent><leader>u :lua require("harpoon.ui").nav_file(2)<CR>
nnoremap <silent><leader>i :lua require("harpoon.ui").nav_file(3)<CR>
nnoremap <silent><leader>o :lua require("harpoon.ui").nav_file(4)<CR>
nnoremap <silent><leader>pp :lua require("harpoon.ui").nav_file(5)<CR>
" nnoremap <silent><C-@> :lua require("harpoon.ui").nav_file(2)<CR>
" nnoremap <silent><C-K> :lua require("harpoon.ui").nav_file(3)<CR>
" nnoremap <silent><C-L> :lua require("harpoon.ui").nav_file(4)<CR>
" nnoremap <silent><leader>tu :lua require("harpoon.term").gotoTerminal(1)<CR>
" nnoremap <silent><leader>te :lua require("harpoon.term").gotoTerminal(2)<CR>
" nnoremap <silent><leader>cu :lua require("harpoon.term").sendCommand(1, 1)<CR>
" nnoremap <silent><leader>ce :lua require("harpoon.term").sendCommand(1, 2)<CR>

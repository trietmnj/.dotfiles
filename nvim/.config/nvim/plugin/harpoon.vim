nnoremap <silent><leader>a :lua require("harpoon.mark").add_file()<CR>
nnoremap <silent><C-e> :lua require("harpoon.ui").toggle_quick_menu()<CR>
nnoremap <silent><leader>tc :lua require("harpoon.cmd-ui").toggle_quick_menu()<CR>

nnoremap <silent><C-H> :lua require("harpoon.ui").nav_file(1)<CR>
nnoremap <silent><C-J> :lua require("harpoon.ui").nav_file(2)<CR>
nnoremap <silent><C-K> :lua require("harpoon.ui").nav_file(3)<CR>
nnoremap <silent><C-L> :lua require("harpoon.ui").nav_file(4)<CR>
" nnoremap <silent><leader>tu :lua require("harpoon.term").gotoTerminal(1)<CR>
" nnoremap <silent><leader>te :lua require("harpoon.term").gotoTerminal(2)<CR>
" nnoremap <silent><leader>cu :lua require("harpoon.term").sendCommand(1, 1)<CR>
" nnoremap <silent><leader>ce :lua require("harpoon.term").sendCommand(1, 2)<CR>

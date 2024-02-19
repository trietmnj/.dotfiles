set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent

" https://github.com/neovim/neovim/wiki/FAQ#how-to-use-the-windows-clipboard-from-wsl
set clipboard=unnamedplus

set exrc
set guicursor=
set relativenumber
set number
set nohlsearch
set hidden
set noerrorbells
set nowrap
set ignorecase
set smartcase
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set termguicolors
set scrolloff=8
set noshowmode
set completeopt=menuone,noinsert,noselect
set signcolumn=yes
set cmdheight=2
set updatetime=50
set shortmess+=c
set colorcolumn=80
" set omnifunc
set foldmethod=indent
set foldlevelstart=20

set encoding=UTF-8
set mouse=a

autocmd FileType javascript setlocal ts=2 sts=2 sw=2
autocmd FileType javascriptreact setlocal ts=2 sts=2 sw=2
autocmd FileType typescript setlocal ts=2 sts=2 sw=2
autocmd FileType typescriptreact setlocal ts=2 sts=2 sw=2
autocmd FileType svelte setlocal ts=2 sts=2 sw=2
autocmd FileType terraform setlocal ts=2 sts=2 sw=2
autocmd FileType css setlocal ts=2 sts=2 sw=2
autocmd FileType json setlocal ts=2 sts=2 sw=2
" autocmd FileType tex setlocal tw=79 fo=cqt
au BufRead,BufNewFile *.tex setlocal tw=79 fo=cqt
autocmd FileType r setlocal ts=2 sts=2 sw=2
autocmd FileType rmd setlocal ts=2 sts=2 sw=2

" autocmd Syntax c,cpp,xml,html,xhtml,
"             \ go,rust,python,javascript,javascriptreact,
"             \ typescript,typescriptreact,css,json,svelte setlocal foldmethod=indent
" autocmd Syntax c,cpp,xml,html,xhtml,perl,
"             \ go,rust,python,javascript,javascriptreact,
"             \ typescript,typescriptreact,css,json,svelte normal zR

" ls-brackets
let g:usemarks = 0
let g:cb_disable_default = { '{': 'n' }

let g:rainbow_active = 1

let g:marker_define_jump_mappings = 0

" svelte
let g:svelte_preprocessors = ['typescript', "ts"]

let g:git_messenger_include_diff='current'

set completeopt=menu,menuone,noselect

let R_assign = 0

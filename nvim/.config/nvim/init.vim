call plug#begin('~/.vim/plugged')

" navigation
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'unblevable/quick-scope'
Plug 'ggandor/lightspeed.nvim'
" Plug 'chentau/marks.nvim'
Plug 'ThePrimeagen/harpoon'

" Themes
Plug 'tanvirtin/monokai.nvim'
" Plug 'sickill/vim-monokai'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'airblade/vim-gitgutter'
Plug 'Yggdroot/indentLine'
" Plug 'luochen1990/rainbow'
Plug 'p00f/nvim-ts-rainbow'
Plug 'gko/vim-coloresque'

" Intellisense
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'
Plug 'mattn/emmet-vim'
" Plug 'L3MON4D3/LuaSnip'
" vim-doge doesn't work
" Plug 'kkoomen/vim-doge', { 'do': { -> doge#install() } }
" nvim-lsp-installer can install gopls too
" Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
" Plug 'ray-x/guihua.lua', {'do': 'cd lua/fzy && make' }
" Plug 'ray-x/navigator.lua'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/trouble.nvim'
Plug 'hashivim/vim-terraform'

" debugger
" https://puremourning.github.io/vimspector/configuration.html#docker-example
" Plug 'puremourning/vimspector'
" Plug 'szw/vim-maximizer'

" trees
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'nvim-treesitter/playground'
Plug 'preservim/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'simrat39/symbols-outline.nvim'
Plug 'ThePrimeagen/git-worktree.nvim'
" Plug 'jamestthompson3/nvim-remote-containers'

" editing
Plug 'AndrewRadev/splitjoin.vim'
Plug 'tpope/vim-surround'
Plug 'LucHermitte/lh-vim-lib'
Plug 'LucHermitte/lh-brackets'
Plug 'rhysd/vim-grammarous'
" Plug 'folke/which-key.nvim'
Plug 'matze/vim-move'

" gc comments
Plug 'tpope/vim-commentary'
" git
Plug 'tpope/vim-fugitive'
Plug 'BitsuMamo/cheat-sh-nvim'
Plug 'tpope/vim-rhubarb'

call plug#end()

lua << EOF
require('tmnj')
EOF

let mapleader = " "

fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

augroup AUTO
    autocmd!
    autocmd BufWritePre * : call TrimWhitespace()
augroup END

autocmd BufWritePre *.go lua vim.lsp.buf.formatting()

if has('wsl')
    let g:clipboard = {
          \   'name': 'wslclipboard',
          \   'copy': {
          \      '+': '/mnt/c/Apps/win32yank-x64/win32yank.exe -i --crlf',
          \      '*': '/mnt/c/Apps/win32yank-x64/win32yank.exe -i --crlf',
          \    },
          \   'paste': {
          \      '+': '/mnt/c/Apps/win32yank-x64/win32yank.exe -o --lf',
          \      '*': '/mnt/c/Apps/win32yank-x64/win32yank.exe -o --lf',
          \   },
          \   'cache_enabled': 1,
          \ }
endif

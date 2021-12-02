call plug#begin('~/.vim/plugged')

" navigation
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'unblevable/quick-scope'
Plug 'justinmk/vim-sneak'

" Themes
Plug 'tanvirtin/monokai.nvim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'airblade/vim-gitgutter'
Plug 'Yggdroot/indentLine'

" Intellisense
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'
Plug 'mattn/emmet-vim'
Plug 'L3MON4D3/LuaSnip'
" vim-doge doesn't work
" Plug 'kkoomen/vim-doge', { 'do': { -> doge#install() } }
" Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
" Plug 'ray-x/guihua.lua', {'do': 'cd lua/fzy && make' }
" Plug 'ray-x/navigator.lua'

" debugger
" https://puremourning.github.io/vimspector/configuration.html#docker-example
Plug 'puremourning/vimspector'
Plug 'szw/vim-maximizer'

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

" gc comments
Plug 'tpope/vim-commentary'
" git
Plug 'tpope/vim-fugitive'
Plug 'BitsuMamo/cheat-sh-nvim'

call plug#end()

lua require'nvim-treesitter.configs'.setup { indent = { enable = true }, highlight = { enable = true }, incremental_selection = { enable = true }, textobjects = { enable = true }}
lua require('tmnj')

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
autocmd BufWritePre *.go lua goimports(1000)


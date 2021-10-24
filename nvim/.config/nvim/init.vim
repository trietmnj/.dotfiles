call plug#begin('~/.vim/plugged')

" navigation
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

" Themes
Plug 'tanvirtin/monokai.nvim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'
Plug 'Xuyuanp/nerdtree-git-plugin'

" gc comments
Plug 'tpope/vim-commentary'

" git
Plug 'tpope/vim-fugitive'

" LSP
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
" Plug 'kabouzeid/nvim-lspinstall'
" Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'
Plug 'mattn/emmet-vim'

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

call plug#end()

lua require'nvim-treesitter.configs'.setup { indent = { enable = true }, highlight = { enable = true }, incremental_selection = { enable = true }, textobjects = { enable = true }}
" lua require('nvim-treesitter.configs').setup { highlight = { enable = false }}
lua require('tmnj')

colorscheme monokai
highlight Normal guibg=none

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


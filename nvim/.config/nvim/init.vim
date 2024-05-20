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
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'airblade/vim-gitgutter'
Plug 'Yggdroot/indentLine'
Plug 'p00f/nvim-ts-rainbow'
Plug 'norcalli/nvim-colorizer.lua'

" Intellisense
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'williamboman/mason.nvim'
Plug 'WhoIsSethDaniel/mason-tool-installer.nvim'

Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}

" Utils
Plug 'mattn/emmet-vim'
" Plug 'ray-x/navigator.lua'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/trouble.nvim'
Plug 'hashivim/vim-terraform'
Plug 'simrat39/rust-tools.nvim'
Plug 'rust-lang/rust.vim'
Plug 'leafOfTree/vim-svelte-plugin'


" debugger
" https://puremourning.github.io/vimspector/configuration.html#docker-example
" Plug 'puremourning/vimspector'
Plug 'szw/vim-maximizer'
Plug 'mfussenegger/nvim-dap'

" trees
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'nvim-treesitter/playground'
Plug 'preservim/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ThePrimeagen/git-worktree.nvim'
Plug 'preservim/tagbar'
Plug 'simrat39/symbols-outline.nvim'

" editing
Plug 'AndrewRadev/splitjoin.vim'
Plug 'tpope/vim-surround'
Plug 'LucHermitte/lh-vim-lib'
Plug 'LucHermitte/lh-brackets'
Plug 'rhysd/vim-grammarous'
Plug 'matze/vim-move'

" gc comments
Plug 'tpope/vim-commentary'
Plug 'JoosepAlviste/nvim-ts-context-commentstring'

" git
Plug 'tpope/vim-fugitive'
Plug 'BitsuMamo/cheat-sh-nvim'
Plug 'tpope/vim-rhubarb'

" snip
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<S-tab>'
Plug 'honza/vim-snippets'

" AI
Plug 'github/copilot.vim'

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

" autocmd BufWritePre *.go lua vim.lsp.buf.formatting()

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

" let g:coq_settings = { 'auto_start': v:true }
let g:coq_settings = { 'auto_start': 'shut-up' }

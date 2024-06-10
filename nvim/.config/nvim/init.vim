call plug#begin('~/.vim/plugged')

" navigation
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'unblevable/quick-scope'
Plug 'ggandor/lightspeed.nvim'
Plug 'ThePrimeagen/harpoon'

" Themes
Plug 'tanvirtin/monokai.nvim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'airblade/vim-gitgutter'
Plug 'Yggdroot/indentLine'
" Plug 'p00f/nvim-ts-rainbow' " bracket coloring
Plug 'gko/vim-coloresque'
Plug 'norcalli/nvim-colorizer.lua'

" Intellisense
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'williamboman/mason.nvim'
Plug 'WhoIsSethDaniel/mason-tool-installer.nvim'
" Plug 'ray-x/guihua.lua', {'do': 'cd lua/fzy && make' }
" Plug 'ray-x/navigator.lua'

Plug 'ms-jpq/coq_nvim'
Plug 'ms-jpq/coq.artifacts'
Plug 'ms-jpq/coq.thirdparty'

" Utils
Plug 'mattn/emmet-vim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/trouble.nvim'
Plug 'hashivim/vim-terraform'
Plug 'simrat39/rust-tools.nvim'
Plug 'rust-lang/rust.vim'
Plug 'leafOfTree/vim-svelte-plugin'
Plug 'folke/neodev.nvim'
" Plug 'MunifTanjim/nui.nvim'

" debugger
" https://puremourning.github.io/vimspector/configuration.html#docker-example
" Plug 'puremourning/vimspector'
Plug 'mfussenegger/nvim-dap'

" windows layout
" Plug 'camspiers/animate.vim'
" Plug 'camspiers/lens.vim'
Plug 'szw/vim-maximizer'

" trees
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'nvim-treesitter/playground'
Plug 'preservim/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ThePrimeagen/git-worktree.nvim'
Plug 'liuchengxu/vista.vim'

" editing
Plug 'AndrewRadev/splitjoin.vim'
Plug 'tpope/vim-surround'
Plug 'LucHermitte/lh-vim-lib'
Plug 'LucHermitte/lh-brackets'
Plug 'rhysd/vim-grammarous'
Plug 'matze/vim-move'

" comments
Plug 'tpope/vim-commentary'
Plug 'JoosepAlviste/nvim-ts-context-commentstring'
" rmd chunks
" TODO still not working
Plug 'echasnovski/mini.nvim'

" git
Plug 'tpope/vim-fugitive'
Plug 'BitsuMamo/cheat-sh-nvim'
Plug 'tpope/vim-rhubarb'

" latex
" https://github.com/lervag/vimtex/issues/2508
Plug 'lervag/vimtex'
let g:tex_flavor='latex'
" let g:vimtex_view_method='mupdf'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmg'
" https://github.com/lervag/vimtex/issues/2566
let g:vimtex_view_general_viewer = '~/.dotfiles/mupdf.sh'
let g:vimtex_view_general_options = '@pdf'

" Plug 'sirver/ultisnips'
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<S-tab>'
Plug 'honza/vim-snippets'

" AI
" Plug 'jackMort/ChatGPT.nvim'
Plug 'github/copilot.vim'
"

" R
Plug 'jalvesaq/Nvim-R'
Plug 'ncm2/ncm2'
Plug 'gaalcaras/ncm-R'
Plug 'roxma/vim-hug-neovim-rpc'
Plug 'ncm2/ncm2-ultisnips'

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

"
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

if has('win32') || (has('unix') && exists('$WSLENV'))
elseif executable('mupdf.exe')
    let g:vimtex_view_general_viewer = 'mupdf.exe'
endif

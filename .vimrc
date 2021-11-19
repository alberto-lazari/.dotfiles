syntax on

call plug#begin('~/.vim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'lyuts/vim-rtags'
Plug 'git@github.com:kien/ctrlp.vim.git'
Plug 'git@github.com:Valloric/YouCompleteme.git'
Plug 'mbbill/undotree'
Plug 'miyakogi/conoline.vim'
Plug 'tomasiser/vim-code-dark'

call plug#end()

set noerrorbells
set tabstop=4 softtabstop=4
set shiftwidth=4
set scrolloff=10
set mouse=a
set title
set background=dark

"Cursor line settings
let g:conoline_auto_enable = 1
let g:conoline_use_colorscheme_default_normal = 1

"Allow backspace
set backspace=indent,eol,start

"Tabs -> spaces
set expandtab

set smartindent
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch

"Smart case-sensitive search
set smartcase

"Set compatibility to Vim only
set nocompatible

"Do NOT wrap text if too long
set linebreak
set nowrap

"Show line numbers relative to the current one
set number relativenumber

"Status bar
set laststatus=2

colorscheme codedark

"Vim-airline settings
let g:airline_powerline_fonts = 1
let g:airline_theme = 'deus'

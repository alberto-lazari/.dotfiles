syntax on

call plug#begin('~/.vim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'mbbill/undotree'
Plug 'miyakogi/conoline.vim'
Plug 'joshdick/onedark.vim'
Plug 'ryanoasis/vim-devicons'

call plug#end()

"Move .viminfo file
set viminfo=%,<800,'10,/50,:100,h,f0,n~/.vim/cache/.viminfo
"           | |    |   |   |    | |  + viminfo file path
"           | |    |   |   |    | + file marks 0-9,A-Z 0=NOT stored
"           | |    |   |   |    + disable 'hlsearch' loading viminfo
"           | |    |   |   + command-line history saved
"           | |    |   + search history saved
"           | |    + files marks saved
"           | + lines saved each register (old name for <, vi6.2)
"           + save/restore buffer list

"Scroll when over number of lines
set scrolloff=2

"Mouse support
"Drains a crazy amount of battery power if enabled
"set mouse=a

"Allow backspace
set backspace=indent,eol,start

"Tabs -> spaces
set expandtab

"Preserve words on wrap
set linebreak

"Indentation
set tabstop=4 softtabstop=4
set shiftwidth=4
set smartindent
set breakindent

"Window title
set title
set titlestring=%t%(\ %M%)%a\ -\ VIM

"Smart case-sensitive search
set smartcase

"Show line numbers relative to the current one
set number relativenumber

"Theme
colorscheme onedark

"Misc
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch

"No '-- INSERT --' in status line
set noshowmode

"No ESC delay
set timeoutlen=1000 ttimeoutlen=0

"Vim-airline settings
let g:airline_powerline_fonts = 1
let g:airline_theme = 'onedark'

"Enable buffers line
let g:airline#extensions#tabline#enabled = 1

"Cursor line settings
let g:conoline_use_colorscheme_default_normal = 1

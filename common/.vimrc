set nocompatible

colorscheme zenburn

execute pathogen#infect()

syntax on

filetype plugin indent on

if has('filetype')
  filetype indent plugin on
endif

if has('syntax')
  syntax on
endif

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
set hidden
set wildmenu
set showcmd
set hlsearch
set ignorecase
set smartcase
set backspace=indent,eol,start
set autoindent
set nostartofline
set ruler
set laststatus=2
set confirm
set visualbell
set t_vb=

if has('mouse')
  set mouse=a
endif

set cmdheight=2
set number
set notimeout ttimeout ttimeoutlen=200
set pastetoggle=<F11>
set shiftwidth=4
set softtabstop=4
set expandtab

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

map Y y$

nnoremap <C-L> :nohl<CR><C-L>
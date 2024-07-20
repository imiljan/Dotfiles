syntax on
let mapleader = " "
set number relativenumber
set clipboard=unnamedplus,unnamed,autoselect

" Mouse and backspace
set mouse=a
set bs=2     " make backspace behave like normal again

noremap <C-c> :nohl<CR>
noremap <Esc> <C-c>

" Useful settings
set history=700
set undolevels=700

" Make search case insensitive
set hlsearch
set incsearch
set ignorecase
set smartcase

" Disable stupid backup and swap files - they trigger too many events
" for file system watchers
set nobackup
set nowritebackup
set noswapfile

set rtp+=/Users/imiljan/Library/Python/3.9/lib/python/site-packages/powerline/bindings/vim/
set laststatus=2


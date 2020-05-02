" do not store file
set noswapfile
" Set to auto read when a file is changed from the outside
set autoread
" Set 5 lines to the cursor - when moving vertically using j/k

" BEHAVIOR ------------
set so=5

" --------------------------------------------------------------------------------
" configure editor with tabs and nice stuff...
" --------------------------------------------------------------------------------
set expandtab           " enter spaces when tab is pressed
set textwidth=120       " break lines when line length increases
set tabstop=2           " use 2 spaces to represent tab
set softtabstop=2
set shiftwidth=2        " number of spaces to use for auto indent
set autoindent          " copy indent from current line when starting a new line

" set map leader
let mapleader=","

" hit F2 in insert mode to paste corretly data
set pastetoggle=<F2>
" Fast saving
nmap <leader>w :w!<cr>

" turn off all the colors
syntax off
set nohlsearch
colo blue

" do not store file
set noswapfile
" Set to auto read when a file is changed from the outside
set autoread
" Set 5 lines to the cursor - when moving vertically using j/k

" BEHAVIOR ------------
set so=5
" Set auto indent 
set ai
" tabsize is 4 spaces
set tabstop=2
" this will turn tab into spaces
set expandtab
set autoindent
" code shift width
set sw=4
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

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
set tabstop=4           " use 2 character space to represent tab
set softtabstop=4       " tab is 2 spaces long 
set shiftwidth=4        " number of spaces to use for auto indent

set smartindent         " smart indent : )
set noerrorbells        " no bells and whistles  

set nu                  " line numbers on 
set nowrap              " no wrapping 
set incsearch           " incremental search is on

" set map leader
let mapleader=","

" hit F2 in insert mode to paste corretly data
set pastetoggle=<F2>

" turn off all the colors
syntax off


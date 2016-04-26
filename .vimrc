" for linux (see http://stackoverflow.com/questions/13704680/vim-imap-jk-esc-not-working)
if filereadable('/etc/debian_version')
	inoremap jk 
	inoremap kj 
else
	inoremap jk <Esc>  
	inoremap kj <Esc>
endif


" command autocompletion with tabs
set wildchar=<TAB>

" highlight search results
set hlsearch

" show matching brackets on hover
set showmatch
" how many tenths of a second to blink when matching
set mat=2

" yank into system clipboard
set clipboard=autoselect,unnamed,unnamedplus

" make backspace work
set backspace=2

" for linux (see http://stackoverflow.com/questions/13704680/vim-imap-jk-esc-not-working)
if filereadable('/etc/debian_version')
	inoremap jk 
	inoremap kj 
else
	inoremap jk <Esc>  
	inoremap kj <Esc>

	" osx clipboard sharing
	set clipboard=unnamed
endif


" command autocompletion with tabs
set wildchar=<TAB>

" highlight search results
set hlsearch

" show matching brackets on hover
set showmatch
" how many tenths of a second to blink when matching
set mat=2

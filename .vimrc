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

" OR via tmp file (if no vim-gui-common)
let mapleader=","
vmap <Leader>y :w! /tmp/vi_clip<CR>
vmap <Leader>p :r! cat /tmp/vi_clip<CR>

" make backspace work
set backspace=2

" http://blog.http417.com/2016/06/go-go-gadget-vim-command-magic-quick.html
" Fast JSON formatting
command JsonFmtAll %!python3 -m json.tool
command -range JsonFmt <line1>,<line2>!python3 -m json.tool
nnoremap & :JsonFmtAll<CR>
vnoremap & :JsonFmt<CR>

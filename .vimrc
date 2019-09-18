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

" search stuff
set ignorecase
set smartcase
set incsearch
" highlight search results
set hlsearch

" don't wrap lines by default
set nowrap

" colors
syntax enable
" colorscheme plan9

" default: .md highlighting if {no suffix,.txt}
" https://stackoverflow.com/questions/2666551/vim-default-syntax-for-files-with-no-extension
au BufNewFile,BufRead * if &syntax == '' | set syntax=markdown | endif
" http://vim.wikia.com/wiki/Forcing_Syntax_Coloring_for_files_with_odd_extensions
autocmd BufNewFile,BufRead *.txt set syntax=markdown   " txt files -> md
autocmd BufNewFile,BufRead bash-fc* set syntax=sh " bash tmp files -> sh
" autocmd BufNewFile,BufRead *rc set syntax=sh         " rc files -> sh

" always UTF-8
"set encoding=utf-8

" show matching brackets on hover
set showmatch
" how many tenths of a second to blink when matching
set mat=2

" yank to end of line
nmap Y y$

" yank into system clipboard
"set clipboard+=autoselect,unnamed,unnamedplus
"set clipboard=autoselect,unnamed,unnamedplus
set clipboard=unnamed,unnamedplus " autoselect copies text you're pasting over before you can clobber it !

" OR via tmp file (if no vim-gui-common)
let mapleader=","
vmap <Leader>y :w! /tmp/vi_clip<CR>
vmap <Leader>p :r! cat /tmp/vi_clip<CR>

" ..but don't lose on exit
" autocmd VimLeave * call system("xclip -selection clipboard", getreg('+'))
autocmd VimLeave * call system("xsel -i --clipboard", getreg('+'))

" make backspace work
set backspace=2

" 1 tab := 4 spaces
set expandtab
set shiftwidth=4
set tabstop=4
set smarttab

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
if has("autocmd")
    filetype plugin indent on
endif

" 80 char line widths
" set textwidth=80

" keep backup file
set backup

" https://coderwall.com/p/sdhfug/vim-swap-backup-and-undo-files
" cleaner swap, backup, undo files
set undodir=~/.vim/.undo//
set backupdir=~/.vim/.backup//
set directory=~/.vim/.swp//

"Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" w!! := sudo write
cmap w!! w !sudo tee % > /dev/null

" separate sentences by a period + ONE space when using gq
set nojoinspaces

" http://blog.http417.com/2016/06/go-go-gadget-vim-command-magic-quick.html
" Fast JSON formatting
command JsonFmtAll %!python3 -m json.tool
command -range JsonFmt <line1>,<line2>!python3 -m json.tool
nnoremap & :JsonFmtAll<CR>
vnoremap & :JsonFmt<CR>

" https://www.reddit.com/r/vim/comments/48zclk/i_just_found_a_simple_method_to_read_pdf_doc_odt/

autocmd BufReadPost *.doc,*.docx,*.rtf,*.odp,*.odt silent %!pandoc "%" -tplain -o /dev/stdout

" Read-only pdf through pdftotext
autocmd BufReadPre *.pdf silent set ro
autocmd BufReadPost *.pdf silent %!pdftotext -nopgbrk -layout -q -eol unix "%" - | fmt -w78

" For jpegs
autocmd BufReadPre *.jpg,*.jpeg silent set ro
autocmd BufReadPost *.jpg,*.jpeg silent %!jp2a --term-width "%"
" For other image formats
autocmd BufReadPre *.png,*.gif,*.bmp silent set ro
autocmd BufReadPost *.png,*.gif,*.bmp silent %!convert "%" jpg:- | jp2a -i --term-width -

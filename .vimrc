if [[ "$OSTYPE" == "linux-gnu" ]]; then
	#for linux (see http://stackoverflow.com/questions/13704680/vim-imap-jk-esc-not-working)
	inoremap jk 
	inoremap kj 
else
	inoremap jk <Esc>  
	inoremap kj <Esc>
fi

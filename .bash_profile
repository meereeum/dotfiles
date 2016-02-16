# editors
#alias python="echo 'use haskell!'"
export EDITOR=/usr/bin/vi
#e() { open -a Emacs "$@"; } #osx
e() { emacs "$@"; } #linux
# touche = touch + emacs
touche() { touch "$@"; e "$@"; }


# various profiles
alias editbash='vi ~/.bash_profile && source ~/.bash_profile'
alias editvim='vi ~/.vimrc && source ~/.vimrc'


# aliasing
alias http='python -m SimpleHTTPServer'
alias rc='cd /Volumes/Media/workspace/rc'
if [[ "$OSTYPE" != "linux-gnu" ]]; then
	alias vlc='open -a VLC'
	# copy to clipboard without trailing \n
	alias copy='tr -d "\n" | pbcopy; echo; echo pbcopied; echo' 
	alias cpy='copy'
fi


# Works as long as initialize virtual environment with "virtualenv .venv"
alias venv='source .venv/bin/activate'


# pretty print git log (via Mary @RC)
alias gl='git log --graph --pretty="format:%C(yellow)%h%Cblue%d%Creset %s %C(white)"'


# http://desk.stinkpot.org:8080/tricks/index.php/2006/12/give-rm-a-new-undo/
alias rm='bash ~/dotfiles/safe_rm.sh'
alias cp='cp -i'
alias mv='mv -i'


# history

HISTSIZE=5000
HISTFILESIZE=10000
# append rather than overrwriting history (which would only save last closed bash sesh)
shopt -s histappend
# make commands executed in one shell immediately accessible in history of others
# i.e. append, then clear, then reload file
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"



# Path thangs

# added by Anaconda2 2.4.1 installer
if [[ "$OSTYPE" == "linux-gnu" ]]; then
	export PATH="/home/miriam/anaconda2/bin:$PATH"
	export PYTHONPATH="/home/miriam/anaconda2/bin/python"
else
	export PATH="/Users/miriamshiffman/anaconda2/bin:$PATH"
	export PYTHONPATH="/Users/miriamshiffman/anaconda2/bin/python"

	# added for homebrew, coreutils
	PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH" #osx
	PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH" #osx
	export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

	#if [ -f $(brew --prefix)/etc/bash_completion ]; then
	#    . $(brew --prefix)/etc/bash_completion
	#  fi
fi



# ACE

alias rudd='ssh -X uqmschif@10.168.48.12'
alias keating='ssh -X uqmschif@10.168.48.11'
alias hawke='ssh -X uqmschif@10.168.48.10'
alias brown='ssh -X uqmschif@10.168.48.9'
alias gillard='ssh -X uqmschif@10.168.48.17'
alias menzies='ssh -X uqmschif@10.168.48.16'
alias frazer='ssh -X uqmschif@10.168.48.13'

# for faster X11 connection
alias fastfrazer='ssh -Y -C -o CompressionLevel=9 -c arcfour,blowfish-cbc uqmschif@10.168.48.13'

alias uprudd='sshfs -o follow_symlinks -o transform_symlinks uqmschif@10.168.48.12:/srv/whitlam/home/users/uqmschif ~/srv/rudd'
alias upkeating='sshfs -o follow_symlinks -o transform_symlinks uqmschif@10.168.48.11:/srv/whitlam/home/users/uqmschif ~/srv/keating'
alias uphawke='sshfs -o follow_symlinks -o transform_symlinks uqmschif@10.168.48.10:/srv/whitlam/home/users/uqmschif ~/srv/hawke'
alias upbrown='sshfs -o follow_symlinks -o transform_symlinks uqmschif@10.168.48.9:/srv/whitlam/home/users/uqmschif ~/srv/brown'
alias upmenzies='sshfs -o follow_symlinks -o transform_symlinks uqmschif@10.168.48.16:/srv/whitlam/home/users/uqmschif ~/srv/menzies'
alias upgillard='sshfs -o follow_symlinks -o transform_symlinks uqmschif@10.168.48.17:/srv/whitlam/home/users/uqmschif ~/srv/gillard'
alias upfrazer='sshfs -o follow_symlinks -o transform_symlinks uqmschif@10.168.48.13:/srv/whitlam/home/users/uqmschif ~/srv/frazer'
alias marsupial='sshfs -o follow_symlinks -o transform_symlinks uqmschif@10.168.48.13:/srv/projects/marsupial ~/srv/marsupial'


alias downrudd='sudo umount ~/srv/rudd'
alias downkeating='sudo umount ~/srv/keating'
alias downhawke='sudo umount ~/srv/hawke'
alias downbrown='sudo umount ~/srv/brown'
alias downgillard='sudo umount ~/srv/gillard'
alias downmenzies='sudo umount ~/srv/menzies'
alias downfrazer='sudo umount ~/srv/frazer'


# UQ VPN up/down
# http://wiki.ecogenomic.org/doku.php?id=vpn_and_vpnc
alias vuq='sudo vpnc uq'
alias vdc='sudo vpnc-disconnect'

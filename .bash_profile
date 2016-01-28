# editors
#alias python="echo 'use haskell!'"
export EDITOR=/usr/bin/vi
e() { open -a Emacs "$@"; }
# touche = touch + emacs
touche() { touch "$@"; e "$@"; }

# various profiles
alias editbash='vi ~/.bash_profile && source ~/.bash_profile'
alias editvim='vi ~/.vimrc && source ~/.vimrc'

# aliasing
alias http='python -m SimpleHTTPServer'
alias rc='cd ~/workspace/rc'

# Works as long as initialize virtual environment with "virtualenv .venv"
alias venv='source .venv/bin/activate'

# pretty print git log (via Mary @RC)
alias gl='git log --graph --pretty="format:%C(yellow)%h%Cblue%d%Creset %s %C(white)"'

# copy to clipboard without trailing \n
alias copy='tr -d "\n" | pbcopy; echo; echo pbcopied; echo'
alias cpy='copy'


# http://desk.stinkpot.org:8080/tricks/index.php/2006/12/give-rm-a-new-undo/
alias rm='bash ~/dotfiles/safe_rm.sh'
alias cp='cp -i'
alias mv='mv -i'


alias vlc='open -a VLC'


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
export PATH="/Users/miriamshiffman/anaconda2/bin:$PATH"
export PYTHONPATH="/Users/miriamshiffman/anaconda2/bin/python"


# detect os
if [[ "$OSTYPE" = "linux-gnu" ]]; then
	export linux=1
	#echo "hey there, debian"
else
	export linux=0
	#echo "hey there, osx"
fi


# editors
#alias python="echo 'use haskell!'"
export EDITOR=/usr/bin/vi
export EVERYWHERE_EDITOR='/usr/bin/emacsclient --alternate-editor="" -c'
export GIT_EDITOR=$EDITOR

#e() { emacsclient --alternate-editor="" -nc "$@" & disown; }
if (($linux)); then
	#e() { emacs "$@" 2>&1 > /dev/null & disown; }
	#e() { emacs "$@"; }
	e() { emacsclient --alternate-editor="" -nc "$@"; }
else
	#e() { open -a Emacs "$@" & disown; }
	#e() { emacs "$@" & disown; }
	#e() { /Applications/Emacs.app/Contents/MacOS/Emacs "$@" & disown; }
	e() { /usr/local/Cellar/emacs-mac/*/Emacs.app/Contents/MacOS/Emacs "$@" & disown; }
fi

# touche = touch + emacs
touche() { touch "$@"; e "$@"; }


# aliasing

MEDIA="${HOME}"

alias editbash='vi ~/.bash_profile && source ~/.bash_profile'
alias http='python -m SimpleHTTPServer'
# alias rc='cd ${MEDIA}/wkspace/rc'
alias wk='cd ${MEDIA}/wkspace'
alias mit='cd ${MEDIA}/mit'
alias quotes='vi ${MEDIA}/txt/quotes.txt'
alias ffl='ssh miriam@toymaker.ops.fastforwardlabs.com'
alias buffalo='whereis whereis whereis whereis whereis whereis whereis whereis'
alias urls='ssh -t csail "vi txt/urls"'
alias cpout='tee /dev/tty | xsel -i --clipboard' # clipboard + STDOUT

export DELTA='Δ'

math() { bc -l <<< "$@"; }
# tom_owes=$(echo '${MEDIA}/Documents/txt/tom_owes')
# tom() { cat '${MEDIA}/Documents/txt/tom_phones'; }
tb() { tensorboard --logdir $PWD/"$@" & google-chrome --app="http://127.0.1.1:6006" && fg; }
lstoday() { today=$( date +'%b %d' ); ls -l "$@" | awk '/'"$today"'/{print $9,$10,$11,$12,$13}'; }
shiffsymphony() { for _ in {1..1000}; do (sleep $(($RANDOM % 47)); echo -e '\a';) &done; }

alias python3="${HOME}/anaconda2/envs/py36/bin/python"
lunch() { python3 ${MEDIA}/utils/mit-lunch/get_menu.py "$@"; }
movies() { python3 ${MEDIA}/utils/cinematic/get_movies.py "$@"; }

# universalish / v possibly nonrobust way to query ip address
# this is local (not public) ip
#ip() { ifconfig | awk '/cast/ {print $2}' | sed 's/addr://'; }
# instead, via https://www.cyberciti.biz/faq/how-to-find-my-public-ip-address-from-command-line-on-a-linux/
#alias ip='dig +short myip.opendns.com @resolver1.opendns.com | cpout'
alias ip='dig +short myip.opendns.com @resolver1.opendns.com | cpout && open "https://horizon.csail.mit.edu/horizon/project/access_and_security"'

#alias rvmv='history | tail -n2 | head -n1 | awk "/\$2==\"mv\"/{print \$2,\$4,\$3;next} {print \"not mv\"}" | sh'
# rvmv() { history | tail -n2 | head -n1 | awk '{print $2,$4,$3}' | sh; }

# add appropriate suffix to unspecified file
suffix()
{
  for f in "$@"; do
    #SUFF=$( file --extension "$f" | awk -F':' '{print $2}' | awk -F'/' '{print $1}' | xargs) &&
    SUFF=$( file -b "$f" | awk '{print $1}' ) && \

    if [[ "${SUFF}" = "ASCII" ]]; then SUFF='txt'; fi

    # unknown
    if [[ "${SUFF}" = "???" ]]; then
       echo 'suffix: filetype unknown'
    # already suffixed
    elif [[ "${f##*.}" =~ ("${SUFF,,}"|"${SUFF^^}") ]]; then
       echo "suffix: $f -> \"\""
    # suffix
    else
       echo "suffix: $f -> $f.${SUFF,,}"
       mv "$f" "$f.${SUFF,,}"
    fi
  done
}


# terminal tab title
# via https://recurse.zulipchat.com/#narrow/stream/Unix.20commands/subject/change.20terminal.20tab.20title.20(OSX)
t ()
{
  TITLE=$@;
  TITLE_CAP=$(echo "$TITLE" | tr '[:lower:]' '[:upper:]');
  echo -en "\033]0;|| $TITLE_CAP ||\a ";
}



# pandoc
eval "$(pandoc --bash-completion)"
# markdown -> man page
md() { pandoc -s -f markdown -t man "$*" | man -l -; }

# conda envs
alias p3='source activate py36'
alias d='source deactivate'

# osx only
if ((!$linux)); then
	alias vlc='open -a VLC'
	alias chrome='open -a /Applications/Google\ Chrome.app'
	alias ffox='open -a /Applications/Firefox.app/'

        for x in gcc g++; do
           #GPATH=$( ls /usr/local/Cellar/gcc/*/bin/${x}* | grep ${x}-[0-9] | tail -n1)
           #alias $x=$GPATH
           #sudo ln -s $GPATH /usr/local/bin/${x}
        #done
           alias $x=$( ls /usr/local/Cellar/gcc/*/bin/${x}* |
                       grep ${x}-[0-9] | tail -n1); done

	alias phil='chrome "https://docs.google.com/document/d/1Bcfz3Tl_T78nx9VLnOyoyn4rrvpjFH2ol8PJ9JMk97U/edit";
			open -a Skype; open -a Evernote'

	# copy to clipboard without trailing \n
	alias copy='tr -d "\n" | pbcopy; echo; echo pbcopied; echo'
	alias cpy='copy'

	# internet tabs --> file
	tabs() { now=$( date +%y%m%d ); for app in safari; #"google chrome" firefox;
                 do osascript -e'set text item delimiters to linefeed' -e'tell app "'${app}'" to url of tabs of window 1 as text' >> tabs_${now}; done; }

# linux only
else
	alias iceweasel='firefox &> /dev/null & disown'
	#alias iceweasel='/usr/lib/iceweasel &> /dev/null & disown'

	alias netflix='google-chrome --app=https://www.netflix.com &> /dev/null'

	alias zotero='/usr/lib/zotero/zotero &> /dev/null & disown'

	screenshot(){ sleep 5; gnome-screenshot -af ~/Downloads/"$@"; }

	# mass xdg-open
	open(){ for f in "$@"; do xdg-open "$f" &> /dev/null & disown; done; }
fi


# list all packages from ```$ apt-get install```, in historical order
# inspired by http://askubuntu.com/questions/17823/how-to-list-all-installed-packages
if (($linux)); then
    # find all packages uninstalled via ```$ apt-get remove```
    # redirect errors if no gzipped history log to /dev/null
    pkgs() {
        uninstalled=$( \
            ( zcat $(ls -tr /var/log/apt/history.log*.gz 2>/dev/null) 2>/dev/null; \
            cat /var/log/apt/history.log ) | \
                #egrep "^(Start-Date:|Commandline:)" | grep -v aptdaemon | \
                # combination sed/grep for removed pkg names, minus -options
                sed -nr "s/^Commandline: apt-get remove (-. )?//p" | \
                # transform into regex to grep out
                tr "\n " "|" | sed "s/|$//" \
                )

        ( zcat $( ls -tr /var/log/apt/history.log*.gz 2>/dev/null) 2>/dev/null; \
        cat /var/log/apt/history.log ) | \
            #egrep "^(Start-Date:|Commandline:)" | grep -v aptdaemon | \
            # combination sed/grep for all installed pkgs names, minus -options
            sed -nr "s/^Commandline: apt-get install (-. )?//p" | \
            # grep out uninstalled (unless empty)
            egrep -v ${uninstalled:-NADA_MUCHO};
    }

  else
    pkgs() {
        cd ${HOME}/dotfiles/packages
        rm Brewfile && brew bundle dump # with package-install options
	cd -
        # brew list
    }
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

export HISTSIZE="INFINITE" # via https://superuser.com/questions/479726/how-to-get-infinite-command-history-in-bash
#HISTFILESIZE=100000 # 10^6
export HISTFILESIZE=$HISTSIZE

# ignore 2 letter commands, variants of ls, pwd
#HISTIGNORE="??:ls -?:ls -??:ls -???:pwd"
export HISTIGNORE="?:??:pwd"

# append rather than overrwriting history (which would only save last closed bash sesh)
shopt -s histappend
# make commands executed in one shell immediately accessible in history of others
# i.e. append, then clear, then reload file
#export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
# ignore duplicates
#HISTCONTROL=erasedups
HISTCONTROL=ignorespace:ignoredups

# via https://unix.stackexchange.com/questions/1288/preserve-bash-history-in-multiple-terminal-windows

_bash_history_sync() {
  builtin history -a         #1
  HISTFILESIZE=$HISTSIZE     #2
  builtin history -c         #3
  builtin history -r         #4
}

history() {                  #5
  _bash_history_sync
  builtin history "$@"
}

PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}_bash_history_sync"

# reedit a history substitution line if it failed
shopt -s histreedit
# edit a recalled history line before executing
shopt -s histverify

# extended regex - e.g. $ ls !(*except_this)
shopt -s extglob

# succinct cmd line (working dir only)
export PS1=" \W \$ "


# Path thangs

export PATH="${HOME}/anaconda2/bin:$PATH"
export PYTHONPATH="${HOME}/anaconda2/bin/python"
# will be useful after upgrading to 3.7..
# via builtin breakpoint()
export PYTHONBREAKPOINT="IPython.embed"

# fix CURL certificates path
# http://stackoverflow.com/questions/3160909/how-do-i-deal-with-certificates-using-curl-while-trying-to-access-an-https-url
if (($linux)); then
	export CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
else
	# added for homebrew, coreutils
	PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
	PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
	MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
	MANPATH="/usr/local/opt/gnu-sed/libexec/gnuman:$MANPATH"

	alias vi='/usr/local/bin/vim' # homebrew version

	# latex
	PATH="/Library/TeX/texbin/:$PATH"

  # brew autocomplete
	#if [ -f $(brew --prefix)/etc/bash_completion.d/brew ]; then
	#    . $(brew --prefix)/etc/bash_completion.d/brew
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
alias curtin='ssh -X uqmschif@10.168.48.21'

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

# autocomplete screen
complete -C "perl -e '@w=split(/ /,\$ENV{COMP_LINE},-1);\$w=pop(@w);for(qx(screen -ls)){print qq/\$1\n/ if (/^\s*\$w/&&/(\d+\.\w+)/||/\d+\.(\$w\w*)/)}'" screen

# make tensorflow work, if server
#export QT_QPA_PLATFORM=offscreen

# make theanify work
export MKL_THREADING_LAYER=GNU

# rc servers
alias rcbroome='ssh meereeum@broome.cluster.recurse.com'
alias rccrosby='ssh meereeum@crosby.cluster.recurse.com' # gpu
alias rcmercer='ssh meereeum@mercer.cluster.recurse.com' # gpu
alias rcspring='ssh meereeum@spring.cluster.recurse.com'

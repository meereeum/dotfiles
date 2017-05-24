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

if (($linux)); then
	#e() { emacs "$@"; }
	e() { emacsclient --alternate-editor="" -nc "$@" & disown; }
else
	e() { open -a Emacs "$@" & disown; }
fi

# touche = touch + emacs
touche() { touch "$@"; e "$@"; }


# aliasing
alias editbash='vi ~/.bash_profile && source ~/.bash_profile'
alias http='python -m SimpleHTTPServer'
alias rc='cd /Volumes/Media/workspace/rc'
alias wk='cd /Volumes/Media/workspace'
alias mit='cd /Volumes/Media/Documents/mit'
alias quotes='vi /Volumes/Media/Documents/txt/quotes.txt'
#alias rvmv='history | tail -n2 | head -n1 | awk "/\$2==\"mv\"/{print \$2,\$4,\$3;next} {print \"not mv\"}" | sh'
alias ffl='ssh miriam@toymaker.ops.fastforwardlabs.com'

math() { bc -l <<< "$@"; }
tom_owes=$(echo '/Volumes/Media/Documents/txt/tom_owes')
tom() { cat '/Volumes/Media/Documents/txt/tom_phones'; }
tb() { tensorboard --logdir $PWD/"$@" & google-chrome --app="http://127.0.1.1:6006" && fg; }

# rvmv() { history | tail -n2 | head -n1 | awk '{print $2,$4,$3}' | sh; }


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
	alias phil='chrome "https://docs.google.com/document/d/1Bcfz3Tl_T78nx9VLnOyoyn4rrvpjFH2ol8PJ9JMk97U/edit";
			open -a Skype; open -a Evernote'

	# copy to clipboard without trailing \n
	alias copy='tr -d "\n" | pbcopy; echo; echo pbcopied; echo'
	alias cpy='copy'

# linux only
else
	alias netflix='google-chrome --app=https://www.netflix.com &> /dev/null'
	screenshot(){ sleep 5; gnome-screenshot -af ~/Downloads/"$@"; }

	# mass xdg-open
	open(){ for f in "$@"; do xdg-open $f &> /dev/null & disown; done }
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

HISTSIZE=1000000 # 10^7
HISTFILESIZE=100000 # 10^6
# ignore 2 letter commands, variants of ls, pwd
#export HISTIGNORE="??:ls -?:ls -??:ls -???:pwd"
# append rather than overrwriting history (which would only save last closed bash sesh)
shopt -s histappend
# make commands executed in one shell immediately accessible in history of others
# i.e. append, then clear, then reload file
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
# ignore duplicates
export HISTCONTROL=erasedups


# Path thangs

# succinct cmd line (working dir only)
export PS1=" \W \$ "

# fix CURL certificates path
# http://stackoverflow.com/questions/3160909/how-do-i-deal-with-certificates-using-curl-while-trying-to-access-an-https-url
if (($linux)); then
	export CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
fi

# added by Anaconda2 2.4.1 installer
if ((!$linux)); then
	# added for homebrew, coreutils
	PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
	PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
	export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

	#if [ -f $(brew --prefix)/etc/bash_completion ]; then
	#    . $(brew --prefix)/etc/bash_completion
	#  fi
fi
export PATH="${HOME}/anaconda2/bin:$PATH"
export PYTHONPATH="${HOME}/anaconda2/bin/python"

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

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
export EDITOR=vim
export VISUAL=$EDITOR
#export EVERYWHERE_EDITOR='/usr/bin/emacsclient --alternate-editor="" -c'
##export EVERYWHERE_EDITOR='/usr/local/Cellar/emacs-mac/*/Emacs.app/Contents/MacOS/Emacs'
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

MEDIA="${HOME}/shiff"

alias editbash='vi ~/.bash_profile && source ~/.bash_profile'
alias http='python -m SimpleHTTPServer'
# alias rc='cd ${MEDIA}/wkspace/rc'
alias wk='cd ${MEDIA}/wkspace'
alias mit='cd ${MEDIA}/mit'
alias quotes='vi ${MEDIA}/txt/quotes.txt'
alias ffl='ssh miriam@toymaker.ops.fastforwardlabs.com'
alias buffalo='whereis whereis whereis whereis whereis whereis whereis whereis'
#alias urls='ssh -t csail "vi txt/urls"'
alias xvlc='xargs -I{} vlc "{}"'
alias wip='vi "$HOME/phd/txt/mtgs/wip_$( day )"'

(( $linux )) && alias toclipboard='xsel -i --clipboard' || alias toclipboard='pbcopy'
#alias cpout='tee /dev/tty | toclipboard' # clipboard + STDOUT
alias cpout='xargs echo'                  # w/o X11 forwarding

alias arxivate='bash ~/dotfiles/arxivate.sh'
alias restart='bash ~/dotfiles/bashcollager.sh'
alias shrinkpdf='bash ~/dotfiles/shrinkpdf.sh'

export DELTA='Δ'
export DELTAS="${DELTA}s"

export STRFDATE="+%y%m%d"


lunch() { python ${MEDIA}/wkspace/mit-lunch/get_menu.py "$@"; }
movies() { python ${MEDIA}/wkspace/cinematic/get_movies.py "$@"; }
lsbeer() { python ${MEDIA}/wkspace/lsbeer/get_beer.py "$@"; }
vixw() { python ${MEDIA}/wkspace/vixw/vixw/vixw.py "$@"; }

math() { bc -l <<< "$@"; }
# tom_owes=$(echo '${MEDIA}/Documents/txt/tom_owes')
# tom() { cat '${MEDIA}/Documents/txt/tom_phones'; }
tb() { tensorboard --logdir $PWD/"$@" & google-chrome --app="http://127.0.1.1:6006" && fg; }
token() { jupyter notebook list | awk -F 'token=' '/token/ {print $2}' | awk '{print $1}' | cpout; } # jupyter notebook token
shiffsymphony() { for _ in {1..1000}; do (sleep $(($RANDOM % 47)); echo -e '\a';) &done; }
coinflip() {
    choices=( "$@" )
    echo "${choices[$(( $RANDOM % ${#choices[@]} ))]}"
    #i=$(( $RANDOM % ${#choices[@]} ))
    #echo "${choices[$i]}"
}

addmusic() { F="$MEDIA/txt/music"; echo -e "$@" >> $F; tail -n4 $F; }
addmovie() { F="$MEDIA/txt/movies4"; echo -e "$@" >> $F; tail -n4 $F; }

# anagram utils
sortword() { echo "$@" | grep -o '\w' | sort | xargs; }
anagrams() { [[ $( sortword "${1,,}" ) == $( sortword "${2,,}" ) ]] && echo "ANAGRAM" || echo "NOT AN ANAGRAM"; }

spiral() { jp2a $MEDIA/media/giphy_096.jpg --term-width --chars=" ${@^^}${@,,}"; }

#dashes() { yes - | head -n"$@" | tr -d '\n'; echo; }
dashes() {
    [[ $2 ]] && dash="$2" || dash="-"
    yes "$dash" | head -n"$1" | tr -d '\n'; echo;
}

# via https://misc.flogisoft.com/bash/tip_colors_and_formatting#colors2
_iter256() {
    fgbg=$1
    for color in {0..255} ; do
        [[ $2 ]] && str=$2 \
                 || str=$color # default: str is colornumber

        # display the color
        printf "\e[${fgbg};5;%sm  %3s  \e[0m" $color $str
        [[ $(( ($color + 1) % 6 )) == 4 ]] && echo # newline (6 colors per line)
    done
}
iterbg256() { _iter256 48 "$@"; }
iterfg256() { _iter256 38 "$@"; }

pdfsplit() {
    PDF="$@"
    pdfseparate $PDF ${PDF%.pdf}.%d.pdf
}
pdfurl2txt() { # e.g. for menus
    URL="$@"
    F=/tmp/pdfurl_"$( echo $URL | sha1sum | awk '{print $1}' )" # hash url
    #[[ -f $F ]] || wget "$URL" -qO $F                           # wget iff doesn't exist
    [[ -f $F ]] || curl "$URL" -s > $F                         # curl iff doesn't exist (wget failed w/ 503 while curl did not..)
    echo; dashes 100; pdftotext -layout $F -; dashes 100; echo # TODO: && display if wget doesnt fail
}

# get bounding box of img (e.g. for when pdflatex is being dumb)
getbbox() {
    gs -o /dev/null -sDEVICE=bbox "$@" 2>&1 | awk '/%%B/ {print $2,$3,$4,$5}' # redirect ghostscript STDERR to STDOUT, & parse
}


# e.g. from youtube-dled subtitles
# $ youtube-dl --write-auto-sub --sub-lang en --sub-format ttml --skip-download $MYVIDOFCHOICE
vtt2txt() {
    grep "<" "$@" |
    # eliminate <stuff>, get ' back, remove blank lines
    sed -e 's/<[^>]*>//g' -e "s/&#39;/'/g" -e '/^\s*$/d' |
    uniq
}
srt2txt() {
    grep -i "[a-z]" "$@"
}

# universalish / v possibly nonrobust way to query ip address
# --> this is local (not public) ip
# ip() { ifconfig | awk '/cast/ {print $2}' | sed 's/addr://'; }
# instead, via https://www.cyberciti.biz/faq/how-to-find-my-public-ip-address-from-command-line-on-a-linux/
# alias ip='dig +short myip.opendns.com @resolver1.opendns.com | cpout && open "https://horizon.csail.mit.edu/horizon/project/access_and_security"'
alias MY_IP='dig -4 +short myip.opendns.com @resolver1.opendns.com'
alias ip='echo $( MY_IP ) | cpout'

alias sourceopenstack='. ~/*openrc.sh'
allowip()
{
    IP="$@"
    [[ $IP ]] || IP=$( MY_IP )
    sourceopenstack
    openstack security group rule create --protocol tcp --dst-port 22 --src-ip $IP ssh
}

# reset illustrator trial
resetadobe()
{
    f="/Applications/Adobe Illustrator CC 2018/Support Files/AMT/AI/AMT/application.xml"
    oldn=$( awk -F'[<>]' '/TrialSerial/{print $3}' "$f" )
    newn=$( math "$oldn + 1" )
    sudo sed -i'.tmp' -E "s/(TrialSerial.*)$oldn/\1$newn/" "$f"
}

#alias rvmv='history | tail -n2 | head -n1 | awk "/\$2==\"mv\"/{print \$2,\$4,\$3;next} {print \"not mv\"}" | sh'
# rvmv() { history | tail -n2 | head -n1 | awk '{print $2,$4,$3}' | sh; }

# add appropriate suffix to unspecified file
suffix()
{
  for f in "$@"; do
    SUFF=$( file -b "$f" | awk '{print $1}' )
    [ "${SUFF,,}" = "ascii" ] && SUFF="txt"
    [ "${SUFF,,}" = "bourne-again" ] && SUFF="sh"

    # unknown
    if [[ "$SUFF" = "???" ]]; then
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

# list top `n` files (by size, including inside directory)
# lsbiggest [-n] $dir (default: 10, working dir)
lsbiggest(){
    #(( $@ )) && n=$@ || n=10
    #du -ahd1 | sort -k1,1 -h | tail -n $(( $n + 1 )) # account for total size

    #FLAG="-n ?" # with optional space

    #ARGS=$( printf "%s" "$@" | sed -r "s/^(.*) ?$FLAG(\w*) ?(.*)$/\2\t\1\3/" ) # N  DIR

    #N=$( echo $ARGS | awk '{print $1}' )
    #DIR=$( echo $ARGS | awk '{print $2}' | sed 's/\/$//' )

    # defaults
    #(( $N )) || N=10
    #[[ "$DIR" ]] || DIR="."

    FLAG="-n ?" # with optional space

    # N.B. need printf b/c echo interprets -n
    N=$( printf "%s" "$@" | sed -rn "s/^.*$FLAG(\w*).*/\1/p" )          # extract $FLAG
    (( $N )) || N=10                                                    # default

    DIR=$( printf "%s" "$@" | sed -re"s/ ?$FLAG\w* ?//" -e"s/\/$//" )   # extract positional, remove trailing /
    [[ "$DIR" ]] || DIR="."                                             # default

    du -ah --max-depth 1 "$DIR" | sort -k1,1 -h | tail -n $(( $N + 1 )) # account for total size
}

#alias lsbiggest='echo "use du | sort | tail !"'

# list files filtered by date
# lstoday [$date] $files (default: today, working dir)
lstoday(){
    # check for valid date
    [[ $( date -d"$1" 2> /dev/null ) ]] && with_date=1 || with_date=0

    (( $with_date )) && dt="$1" || dt="today" # default: today
    (( $with_date )) && shift                 # default: .

    today=$( date -d"$dt" $STRFDATE )

    # ls the thing/s
    ( [[ "$@" == "" ]] && ls -Al --time-style=$STRFDATE || (    # "A"lmost all - not . or ..
        for f in "$@"; do
            [[ -d "$f" ]] && ls -Adl --time-style=$STRFDATE $f/* \
                          || ls -Al --time-style=$STRFDATE "$f" # e.g. can't ls ".." (directory not contents)
        done )) |

    sed -Ee's@/+@/@g' -ne"s/^.*${today} (.*)$/\1/p" | # filter, eliminate // in path
    #grep -Ev '^\.+(git)?$' |                          # ignore . & .. & .git
    sed -e's@\/\/*@/@g' -e"s/'/\\\'/" -e"s/'/\\\'/" | # eliminate // in path, escape '|
    grep -Ev '^\.git$' |                              # ignore .git
    xargs -I{} ls -d --color=auto 2>&1 "{}" ;         # pprint
}


lssince(){
    # check for valid date
    maybe_dt="$( echo "$1" | sed -re's/wk/week/' -e's/\b(((day)|(week)|(month))s? [^(ago)])/\1 ago/' )"
    maybe_dt="$maybe_dt 1" # 1 just sets time if not necessary
                           # else, check for (1st of) month

    [[ $( date -d"$maybe_dt" 2> /dev/null ) ]] && with_date=1 || with_date=0
    [[ $( date -d"last $maybe_dt" 2> /dev/null ) ]] && with_date=1 && maybe_dt="last $maybe_dt"

    (( $with_date )) && dt="$maybe_dt" || dt="today" # default: today
    (( $with_date )) && shift                        # default: .

    today=$( day "$dt" )

    # ls the thing/s
    ( [[ "$@" == "" ]] && ls -Al --time-style=$STRFDATE || (    # "A"lmost all - not . or ..
        for f in "$@"; do
            [[ -d "$f" ]] && ls -Ald --time-style=$STRFDATE $f/* \
                          || ls -Al --time-style=$STRFDATE "$f" # e.g. can't ls ".."
        done )) |

    awk -v today=$today '$6 >= today' |                              # filter by "since"
    sed -Ee's/^([^ ]* *){6}(.*)/\2/' -e's@\/\/*@/@g' -e"s/'/\\\'/" | # extract filename, eliminate // in path, escape '
    grep -Ev '^\.git$' |                                             # ignore .git
    xargs -I{} ls -d --color=auto 2>&1 "{}" ;                        # pprint
}


# get YYMMDD (default: today)
day() {
    [[ $# == 0 ]] && dt="today" || dt="$@"     # no args -> today
    [[ "${dt,,}" == "tom" ]] && dt+="orrow"    # tom -> tomorrow
    [[ "${dt,,}" == "tom murphy" ]] && echo "that's my date not *a* date" \
                                    || date -d "$dt" $STRFDATE;
}

# extract zulip msgs
# zulipjson2msgs(){ cat "$@" | jq -c '.messages[].content' | # <-- without **mirtom
zulipjson2msgs(){
    cat "$@" | jq -c '.messages[] | [.sender_short_name, .content]' |
      # star the ~best~ lines, then rm the jq crud
      sed -re's/^\["(meereeum|amindfv)","/** /' -e's/"]$//' -e's/^\["[^"]*","//' |
      # " (just the escaped ones) and &
      sed -re's/(^|[^\])"/\1/g' -e's/\\"/"/g' -e's/amp;//g' |
      # `code` and *bold* and ```
      #                       multiline code
      #                       ```
      sed -re's@</?code>@`@g' -e's@</?strong>@*@g' -e's@<div class="codehilite">([^<]*)</div>@```\n\1\n```@' |
      # rm extraneous tags
      sed -re's@</?(p|br|pre)>@@g' -e's@<a href[^>]*>pasted image</a>@@g' |
      # rescue just the linknames + spantxt (including @folks and some emoji)
      sed -re's@<a href[^>]*>([^<]*)</a>@\1@g' -e's@<span class[^>]*>([^<]*)</span>@\1@g' |
                                             # -e's@<span class="emoji[^>]*>([^<]*)</span>@\1@g'
                                             # -e's@<span class="user-mention"[^>]*>([^<]*)</span>@\1@g'
      # rescue more emoji
      sed -re's@<img alt="([^"]*)" class="emoji[^>]*>@\1@g' |
      # clobber remaining spans; make actual newlines
      sed -re's@</?span>@@g' -e 's/\\n/\n/g' |
         # -e's@<span[^>]*>[^>]*>@@g'
      # rm remaining crud, including emptylines, et voila
      grep -v '^<div class="message_inline_image">' | awk '$NF';
    # grep -v "^</?div"
}


# N.B. missing txt inside <span class="k">, which seems to be a latex math block

# save open ffox tabs
# inspired by https://superuser.com/questions/96739/is-there-a-method-to-export-the-urls-of-the-open-tabs-of-a-firefox-window
openTabs(){
    (( $linux )) && PREFIX="$HOME/.mozilla/firefox" || PREFIX="$HOME/Library/Application Support/Firefox"
    SESSION=$( awk -F'=' '/Path/ {print $2}' "${PREFIX}"/profiles.ini )
    #cat "$PREFIX"/$SESSION/sessionstore-backups/recovery.js |
    cat "$PREFIX"/$SESSION/sessionstore-backups/recovery.jsonlz4 |
     dejsonlz4 - |
     jq -c '.windows[].tabs[].entries[-1].url' |
     sed -e 's/^"//' -e 's/"$//' |

     # filter unwanted
     grep -v -e'[(calendar)|(mail)].google.com' -e'owa.mit.edu' -e'webmail.csail.mit.edu' -e'^file:' -e'zulipchat.com' |

     # site-specific edits
     awk '!/about:sessionrestore/' |
     awk -v SITE='nytimes.com|washingtonpost.com' -F'?' '$0~SITE {print $1} $0!~SITE' | # get rid of post-? junk
     sed 's@\(google.com/search?\).*\b\(q=[^&]*\).*[&$].*@\1\2@' |                      # get rid of post-? junk besides query
     sed 's@\(biorxiv.org/.*\)\.full\.pdf.*$@\1@' |                                     # biorxiv pdf -> abs
     sed 's@\(arxiv.org/\)pdf\(/.*\)\.pdf$@\1abs\2@' |                                  # arxiv pdf -> abs

     # rm trailing stuff
     sed -e 's@/$@@' ; #-e 's@\?needAccess=[(true)|(false)]$@@'; # TODO
}

getOpenTabs(){ openTabs | cpout; }
#saveOpenTabs(){ f=./tabs_$( day ); openTabs > "$f"; echo -e "\n--> $f\n"; }
saveOpenTabs(){ f=./tabs_$( day ); openTabs > "$f"; echo "     --> $f"; }


# wifi on/off
airplane_mode()
{
    OPS=(on off)

    [ $( nmcli radio wifi ) == "enabled" ] && i=0 || i=1
    from=${OPS[$i]}
    to=${OPS[1 - $i]} # flip

    nmcli radio wifi $to
    echo "${from^^}-->${to^^}"
}


# terminal tab title
# via https://recurse.zulipchat.com/#narrow/stream/Unix.20commands/subject/change.20terminal.20tab.20title.20(OSX)
t()
{
    TITLE=$@
    PATTERN="||"
    echo -en "\033]2;$PATTERN ${TITLE^^} $PATTERN\a"
}


# pandoc
# eval "$(pandoc --bash-completion)"
# markdown -> man page
# md() { pandoc -s -f markdown -t man "$*" | man -l -; }

# conda envs
# alias p3='source activate py36'
# alias d='source deactivate'

(($linux)) && PIPCACHE=$HOME/.cache/pip || PIPCACHE=$HOME/Library/Caches/pip
alias pip-clean='\rm -r $PIPCACHE/*'

# osx only
if ((!$linux)); then
    alias vlc='open -a VLC'
    alias chrome='open -a /Applications/Google\ Chrome.app'
    alias ffox='open -a /Applications/Firefox.app'
    alias preview='open -a /Applications/Preview.app'

    #for g in gcc g++; do
       #GPATH=$( ls /usr/local/Cellar/gcc/*/bin/${g}* | grep ${g}-[0-9] | tail -n1)
       #alias $g=$GPATH
       #sudo ln -s $GPATH /usr/local/bin/${g}
    #done

	alias phil='chrome "https://docs.google.com/document/d/1Bcfz3Tl_T78nx9VLnOyoyn4rrvpjFH2ol8PJ9JMk97U/edit";
			open -a Skype; open -a Evernote'

	# copy to clipboard without trailing \n
	alias copy='tr -d "\n" | pbcopy; echo; echo pbcopied; echo'
	alias cpy='copy'

	# internet tabs --> file
	tabs() {
        now=$( date $STRFDATE )
        for app in safari; do #"google chrome" firefox;
            osascript -e'set text item delimiters to linefeed' -e'tell app "'${app}'" to url of tabs of window 1 as text' >> tabs_${now}
        done
    }

# linux only
else
	alias iceweasel='firefox &> /dev/null & disown'
	# alias iceweasel='/usr/lib/iceweasel &> /dev/null & disown'

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
        uninstalled=$(
            ( zcat $(ls -tr /var/log/apt/history.log*.gz 2>/dev/null) 2>/dev/null;
            cat /var/log/apt/history.log ) |
                #egrep "^(Start-Date:|Commandline:)" | grep -v aptdaemon |
                # combination sed/grep for removed pkg names, minus -options
                sed -nr "s/^Commandline: apt-get remove (-. )?//p" |
                # transform into regex to grep out
                tr "\n " "|" | sed "s/|$//"
                )

        ( zcat $( ls -tr /var/log/apt/history.log*.gz 2>/dev/null) 2>/dev/null;
        cat /var/log/apt/history.log ) |
            #egrep "^(Start-Date:|Commandline:)" | grep -v aptdaemon |
            # combination sed/grep for all installed pkgs names, minus -options
            sed -nr "s/^Commandline: apt-get install (-. )?//p" |
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
#alias venv='source .venv/bin/activate'


# pretty print git log (via Mary @RC)
alias gl='git log --graph --pretty="format:%C(yellow)%h%Cblue%d%Creset %s %C(white)"'

alias gitcontrib='git shortlog -sn'


# http://desk.stinkpot.org:8080/tricks/index.php/2006/12/give-rm-a-new-undo/
(($linux)) && export TRASHDIR="${HOME}/.local/share/Trash/files" \
           || export TRASHDIR="${HOME}/.Trash"
alias rm='~/dotfiles/safe_rm.sh'
alias cp='cp -i'
alias mv='mv -i'

alias grep='grep --color'
alias ls='ls --color=auto'
export LESS=-r # allow colorcodes & symbols in less

alias vinilla='vi -u NONE'


# history

export HISTSIZE="INFINITE" # via https://superuser.com/questions/479726/how-to-get-infinite-command-history-in-bash
#HISTFILESIZE=100000 # 10^6
export HISTFILESIZE=$HISTSIZE

# ignore 1-2 letter commands, variants of ls, pwd
#HISTIGNORE="??:ls -?:ls -??:ls -???:pwd"
export HISTIGNORE="?:??:pwd:history"

# via https://www.shellhacks.com/tune-command-line-history-bash/
# append rather than overwriting history (which would only save last closed bash sesh)
shopt -s histappend
# make commands executed in one shell immediately accessible in history of others
# i.e. append, then clear, then reload file
# export PROMPT_COMMAND="history -a; history -c; history -r"
# export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
# ignore duplicates
#HISTCONTROL=erasedups
export HISTCONTROL=ignorespace:ignoredups

# via https://unix.stackexchange.com/questions/1288/preserve-bash-history-in-multiple-terminal-windows

# _bash_history_sync() {
#   builtin history -a         #1
#   HISTFILESIZE=$HISTSIZE     #2
#   builtin history -c         #3
#   builtin history -r         #4
# }
#
# history() {                  #5
#   _bash_history_sync
#   builtin history "$@"
# }
#
# PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}_bash_history_sync"
PROMPT_COMMAND="${PROMPT_COMMAND:+${PROMPT_COMMAND} ;}history -a"

# reedit a history substitution line if it failed
shopt -s histreedit
# edit a recalled history line before executing
shopt -s histverify
# multi-line commands in 1 history entry
shopt -s cmdhist

# extended regex - e.g. $ ls !(*except_this)
shopt -s extglob

# succinct cmd line (working dir only)
# homebase vs remote / server
[[ $DISPLAY ]] && PS1=" \W \$ " || PS1="\e[1m\h:\e[m \W \$ "

case "$TERM" in
	"dumb")
	    export PS1="> " # make tramp compatible ?
	    ;;
	*)
        #export PS1=" \W \$ "
        export PS1="$PS1"
	    ;;
esac
# export PS1=" \W \$ "               # homebase
# export PS1="\e[1m\h:\e[m \W \$ "   # remote / server
# export PS1="$PS1"

bash ~/dotfiles/horizon.sh # populate /tmp/darksky

MOON=$( bash ~/dotfiles/moony.sh )
export PS1="$MOON$PS1" # prepend moon

SUN=$( bash ~/dotfiles/sunny.sh )
[[ $SUN ]] && echo $SUN # skip if no return

# Path thangs

export PATH="${HOME}/miniconda3/bin:$PATH"
export PYTHONPATH="${HOME}/miniconda3/bin/python"

export pandoc=/usr/bin/pandoc # don't let conda vs override

# will be useful after upgrading to 3.7..
# via builtin breakpoint()
export PYTHONBREAKPOINT="IPython.embed"

# fix CURL certificates path
# http://stackoverflow.com/questions/3160909/how-do-i-deal-with-certificates-using-curl-while-trying-to-access-an-https-url
#if (($linux)); then
	#export CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
#else
if ((!$linux)); then
	# added for homebrew, coreutils
    GNUPATH=$( echo "/usr/local/opt/"{grep,coreutils,gnu-{sed,tar,which,indent}}"/libexec/gnubin:" |
               sed 's/ //g' )
    GNUMANPATH=$( echo $GNUPATH | sed 's/gnubin/gnuman/g' )

    PATH="$GNUPATH$PATH"
    MANPATH="$GNUMANPATH$MANPATH"

    # either: symlink once OR explicitly alias
    # ln -s /usr/local/Cellar/vim/*/bin/vim /usr/local/bin/vim
    # alias vim=/usr/local/Cellar/vim/*/bin/vim # homebrew version
	alias vi=vim
    export VIMRUNTIME=/usr/local/Cellar/vim/*/share/vim/*

    # # refresh editors
    # export EDITOR=vim
    # export VISUAL=$EDITOR
    # export GIT_EDITOR=$EDITOR

	# latex
	PATH="/Library/TeX/texbin/:$PATH"

    # LD stuff
    export CPPFLAGS="-I/usr/local/include"
    export LDFLAGS="-L/usr/local/lib"

    # brew autocomplete
	# if [ -f $(brew --prefix)/etc/bash_completion.d/brew ]; then
	#    . $(brew --prefix)/etc/bash_completion.d/brew
	#  fi
fi


# ACE

# ace servers
alias acerudd='ssh acerudd'
alias acekeating='ssh acekeating'
alias acehawke='ssh acehawke'
alias acebrown='ssh acebrown'
alias acegillard='ssh acegillard'
alias acemenzies='ssh acemenzies'
alias acefrazer='ssh acefrazer'
alias acecurtin='ssh acecurtin'

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

[[ $DISPLAY ]] || export QT_QPA_PLATFORM=offscreen # make tensorflow / matplotlib work if server

# make theanify work
export MKL_THREADING_LAYER=GNU


# screen shots
alias update_screenshots='mv ~/Desktop/Screen* ~/pix/screenshots; rsync -rz --progress ~/pix csail:./macos'

# broad servers
if [[ -f /etc/redhat-release ]]; then
    DK_DEFAULTS="taciturn reuse dkcomplete"

    use -q $DK_DEFAULTS # quietly load

    # succinct cmd line (working dir only)
    load_prompt() {
        #LS_USE=$( use | grep -A 10 'Packages in use:' | awk 'NR>1 && $0' | xargs | sed 's/ /, /g' )
        LS_USE=$( use | grep -A 10 'Packages in use:' | grep '^  \w' |
                  grep -Eve'^  default\+*$' -e"$( echo $DK_DEFAULTS | sed 's/ /|/g' )" |
                  xargs | sed 's/ /, /g' )
        export PS1="($LS_USE) \e[1m\h:\e[m \W \$ "
    }
    load_prompt

    # make CWD nice
    TMPWD="$HOME/.cwd"

    [ -f $TMPWD ] && source $TMPWD   # maybe `cd`, &
    echo "cd $HOME/shiffman" > $TMPWD # reset to default

    alias insh='echo "cd $PWD" > $TMPWD; qrsh -q interactive -P regevlab -l os=RedHat7'
    alias ddt='utilize GCC-5.2 Anaconda3 && source activate ddt && cd $HOME/shiffman/tree-ddt'
    alias editbash='echo "cd $PWD" > $TMPWD; vi ~/dotfiles/.bash_profile && source ~/dotfiles/.bash_profile' # re-alias

    utilize()   {   use "$@" && load_prompt; }
    reutilize() { reuse "$@" && load_prompt; }
    unutilize() { unuse "$@" && load_prompt; }

    utilize UGER

    #functions[use]='
    #  (){ '$functions[use]'; } "$@"; local myret=$?
    #  echo "hellooo"
    #  return $myret'

    #use() { local source /broad/software/scripts/useuse && use "$@" && load_prompt; }
    #reuse() { reuse "$@" && load_prompt; }
    #unuse() { unuse "$@" && load_prompt; }

    # turn on autocompletion
    # via /broad/software/dotkit/bash/dkcomplete.d
    complete -W '`$DK_ROOT/etc/use-usage 1`' utilize
    complete -W '`$DK_ROOT/etc/use-usage 1`' unutilize
    complete -W '`$DK_ROOT/etc/use-usage 1`' reutilize

    OS=$( cat /etc/redhat-release | sed -e"s/^.*release //" -e"s/ (.*$//" )
    #(( $( bc <<< "$OS > 7" ) )) && vimdir='vim' || vimdir='vim_dumb' # TODO
    #alias vim=$HOME/bin/$vimdir
    (( $( bc <<< "$OS > 7" ) )) && vimdir='$HOME/bin/vim' || vimdir='/usr/bin/vim'
    alias vim=$vimdir
    alias vi=vim

    # refresh editors
    export EDITOR=$vimdir
    export VISUAL=$EDITOR
    export GIT_EDITOR=$EDITOR

    export LANG="en_US.utf8" # b/c broad defaults are :(
    export LD_LIBRARY_PATH=/user/lib64:/lib64:$LD_LIBARY_PATH
fi


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/ubuntu/google-cloud-sdk/path.bash.inc' ]; then source '/home/ubuntu/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/ubuntu/google-cloud-sdk/completion.bash.inc' ]; then source '/home/ubuntu/google-cloud-sdk/completion.bash.inc'; fi

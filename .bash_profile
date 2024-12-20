DIR=$( dirname "${BASH_SOURCE[0]}" )

# detect os
# [[ "$OSTYPE" = "linux-gnu" ]]
	                           # echo "hey there, debian"
[[ $( uname ) = "Linux" ]] && export linux=1 \
                           || export linux=0
	                           # echo "hey there, osx"


(( $linux )) && export DISTRO=$(
    awk -F'=' '/^PRETTY_NAME/ {print $2}' /etc/os-release | # e.g. Debian GNU/Linux 9 (stretch)
    #         '/^NAME/                                      # e.g. Debian GNU/Linux
    #         '/^ID=/                                       # e.g. debian
    xargs # xargs removes "
)            || export DISTRO=MacOS

HAS_DISPLAY=$( [ -z $DISPLAY ] && echo 0 || echo 1 )
((!$linux)) && HAS_DISPLAY=1 # fix for mac


alias grep='grep --color'
alias jq='jq -C'
(( $linux )) && alias ls='ls --color=auto' \
             || { eval $( gdircolors ); alias ls='gls --color=auto'; }
export LESS=-r # allow colorcodes & symbols in less


# just kingdom
if ((!$linux)); then

    source ~/.secret

    # alias drive='cd /Volumes/GoogleDrive/My\ Drive'
    # alias driveKingdom='cd /Volumes/GoogleDrive/My\ Drive/KingdomScience/Analysis_files'
    alias gd='cd ~/Google\ Drive/Shared\ drives/Science'
    mtg() { vi ~/kingdom-supercultures/mtgs/"$@"; }

    R_HOME=/usr/local/bin/R
    alias python='python3.10'
    alias pip='pip3.10'
    export PATH="/usr/local/opt/python@3.10/bin:$PATH"
    export PATH="/usr/local/bin:$PATH"

    export JAVA_HOME=$( ls -d /Library/Java/JavaVirtualMachines/adoptopenjdk-*.jdk/Contents/Home )
    export JARDIR=~/tools/jars

    alias rdp_classifier='java -Xmx1g -jar ~/tools/jars/rdp_classifier-2.14.jar'

    complete -C $( which aws_completer ) aws

    grasgrep() {
        pdfgrep -HPi "$@" $HOME/gras-lists/*pdf && \
           grep -Hi  "$@" $HOME/gras-lists/*{sv,txt};
    }

    CIHP='/Users/miriam/Google Drive/Shared drives/IngredientDevelopment/1. Active Projects/CIHP/Notebook'
    cihp() {
        if [[ $# == 0 ]]; then
            cd "$CIHP"
        else
            cd "$CIHP"
            EXPT="$1"
            EXPTDIR=$( find . -type d -maxdepth 2 -iregex '.*/cihp.*0'$EXPT'' | head -1 ) # first match
            cd "$EXPTDIR"
        fi
    }
    COHP='/Users/miriam/Google Drive/Shared drives/IngredientDevelopment/1. Active Projects/COHP/Notebook'
    cohp() {
        if [[ $# == 0 ]]; then
            cd "$COHP"
        else
            cd "$COHP"
            EXPT="$1"
            EXPTDIR=$( find . -type d -maxdepth 2 -iregex '.*/cohp.*0'$EXPT'' | head -1 ) # first match
            cd "$EXPTDIR"
        fi
    }

    fasta2seq() {
        # fasta file to contiguous seq
        cat "$1" | grep -v \> | tr -d '\n'
    }
    alias rc='tr ACGTacgt TGCAtgca | rev' # reverse complement

    contiggrep() {
        REGEX="$1"
        MAYBE_FILE="$2"
        awk -v RS=">" -v ORS="\n" -v FS="\n" -v OFS="\t" -v REGEX="$REGEX" '$1~REGEX{$1=$1; print ">"$1"\n"$2}' $MAYBE_FILE
        # adapted from https://bioinfoaps.github.io/20-text_process/index.html
    }

    # ARBHOME=/Users/miriam/tools/arb;export ARBHOME
    # export LD_LIBRARY_PATH=${ARBHOME}/lib:${LD_LIBRARY_PATH}
    # export PATH=${ARBHOME}/bin:${PATH}
    alias bfg='java -jar ~/tools/bfg*.jar' # $ bfg --delete-files $FILE

    backup() {
        OUTDIR="$@"
        pip freeze > ~/py_pkgs.txt
        brew list > ~/brew_pkgs.txt
        ls -alh /usr/local/bin | grep ~/tools | awk '{print $9,$10,$11}' > ~/tools/links
        OGD=$PWD
        cd $HOME
        echo rsync -az --progress --exclude="'*.DS_Store'" --exclude="'*.com.google*'" $( cat ~/bkp | grep -v '^#' ) "$OUTDIR" | cpout
        cd $OGD
    }

    # strainid2well() { awk -vCSVPAT="$CSVPAT" '{FPAT=CSVPAT} $17{print $1,$17}' ~/Downloads/df_meta.csv; }

    whoisstrain() {
        NAME="${@^^}"
        # curl -s -H  "X-API-Key: $API_KEY" ${API_URL}/api/dereplication/strains/${NAME}/card |
        env=prod kcurl dereplication/strains/${NAME}/card |
            jq -C | less -R
            # filtering out some unnecessary stuff:
            # jq -C 'del( .strain_tube, .accessible_strain_tubes, .strain_phylogeny, .strain_gtdbtk.assembled_genome )'
    }
    # askstaging() {
    #     Q="$@"
    #     curl -s -H  "X-API-Key: $API_KEY_STAGING" ${API_URL_STAGING}/api/${Q} # |
    #         # jq -C | less -R
    # }

    export APISTUFF_STAGING="-sH \"X-API-Key: ${API_KEY_STAGING}\" ${API_URL_STAGING}"
    export APISTUFF="-sH \"X-API-Key: ${API_KEY}\" ${API_URL}"

    kcurl() {
        if [[ "$1" == "-X" ]]; then
            XFLAG="$1 $2"
            shift; shift
        else
            XFLAG=""
        fi

        if [[ "$env" = "staging" ]]; then
            curl $XFLAG -s -H "X-API-Key: $API_KEY_STAGING" ${API_URL_STAGING}/api/${@}
        elif [[ "$env" = "prod" ]]; then
            curl $XFLAG -s -H "X-API-Key: $API_KEY" ${API_URL}/api/${@}
        else # local
            curl $XFLAG -s http://localhost:8000/api/${@}
        fi
    }

    upbastion() {
        ssh bastion -NfL 5432:${POSTGRES_CLUSTER}:5432
    }
    upbastion_staging() {
        ssh bastion_staging -NfL 5432:${POSTGRES_CLUSTER_STAGING}:5432
    }
    downbastion() {
        pid=$( ps aux | grep bastion | grep -v "grep" | awk '{print $2}' )
        kill $pid
    }

    export SAM_CLI_TELEMETRY=0

    alias  tfinit='AWS_PROFILE=staging terraform init -reconfigure -backend-config="backend/staging.conf"'
    alias  tfplan='AWS_PROFILE=staging terraform plan  -var-file="tfvars/staging.tfvars" -var git_sha=47'
    alias tfapply='AWS_PROFILE=staging terraform apply -var-file="tfvars/staging.tfvars"'

    export KTOOLS="$HOME/tools-kingdom"
    export TS="${KTOOLS}/kingdom_task_schemas/kingdom_task_schemas/task_schemas"
    # grepkingdom() { # grep kingdom codebase
    kgrep() { # grep kingdom codebase
        cd "$KTOOLS"
        grep --color -RI "$@" --exclude-dir api_docs --exclude-dir archive --exclude-dir graphs --exclude old_* --exclude-dir test_data --exclude-dir data --exclude-dir safety_resources --exclude-dir .git --exclude-dir .terraform --exclude-dir kingdom-django-main --exclude-dir .pytest_cache --exclude safety_considerations.py --exclude-dir lab-data-analysis --exclude-dir standalone-dereplication \
            --exclude-dir 230524_assigns --exclude-dir 230519_data_dump --exclude package-lock.json --exclude-dir migrations
        cd - 2>&1 > /dev/null # silently return
        # grep --color -RI "$@" ~/tools-kingdom --exclude-dir api_docs --exclude-dir archive
    }

    # docker
    # docker attach $( docker ps | awk '$2=="kingdom-django-api" {print $1}' )

    # aws
    # via https://stackoverflow.com/a/60398039
    s3ls() {
        path="$@"
        if [[ $path = *"*"* ]]; then
            rest=$( echo $path | sed -E 's%^([^\*]*/)%%' ) # any segment w/ wildcard thru end
            dir=${path%"$rest"} # all segments of path until one with a wildcard
            aws s3 sync s3://"${dir}" /tmp/akdjf --exclude '*' --include "${rest}" --dryrun | awk '{print $3}'

        else # no wildcard; this will list everything recursively
            aws s3 sync s3://"$path" /tmp/akdjf --dryrun | awk '{print $3}'

        fi
    }

    s3lsrecent() {
        aws s3 ls "$@" --recursive | sort -k1,1 | awk '{print $1"\t"$2"\t"$4}'
    }

    auditwgs() {
        RUN=$1
        [[ "$2" ]] && RUN_ID=$2 || RUN_ID=1 # default: 1
        F_LOG=/tmp/wgsprog_${RUN}
        # strain name | size of read file | size of assembly file (if it exists)
        join -a1 <( aws s3 ls s3://kingdom-raw-downloads/novogene/read/well_tars/${RUN}/ | sed 's/.tar//' | awk '{print $4,$3}' | sort ) \
                 <( aws s3 ls s3://kingdom-data/assemblies/${RUN}/${RUN_ID}/ | sed 's/.assembly.fasta//' | awk '{print $4,$3}' | sort ) |
            grep -vi -e ^ctrl -e ^undetermined | tr ' ' '\t' > $F_LOG
        cat $F_LOG
        echo
        echo "~~~summary~~~"
        echo "$( awk '$3>0'  $F_LOG | wc -l | xargs printf '%3s' )" ASSEMBLED
        echo "$( awk '$3==0' $F_LOG | wc -l | xargs printf '%3s' )" EMPTY
        echo "$( awk 'NF==2' $F_LOG | wc -l | xargs printf '%3s' )" STILL ASSEMBLING
    }
    wgsstats() {
        RUN=$1
        RUN_ID=1
        D_RUN=/tmp/contigs_${RUN}
        mkdir -p $D_RUN
        for GENOME in $( aws s3 ls s3://kingdom-data/assemblies/${RUN}/${RUN_ID}/ | awk '{print $4}' ); do
            F_GENOME="${D_RUN}/$( echo $GENOME | awk -F. '{print $1}' )"
            # if file doesn't already exist
            [[ -f $F_GENOME ]] || aws s3 cp s3://kingdom-data/assemblies/${RUN}/${RUN_ID}/$GENOME - |
                tr -d '\n' | sed -E 's/(>[^ACGT]*)/\n\1\n/g' | grep -v '^>' |
                    awk 'NF{print length}' > $F_GENOME
        done
        echo -e "genome\tlen\tn50"
        for GENOME in $( ls $D_RUN ); do
            # strain name | length | n50
            # echo $( echo $GENOME; cat ${D_RUN}/${GENOME} | sort -n | awk '{len[i++]=$1;sum+=$1} END {for (j=0;j<i+1;j++) {csum+=len[j]; if (csum>=sum/2) {print sum;print len[j];break}}}' )
            echo $( echo $GENOME; fastastats ${D_RUN}/${GENOME} )
        done | tr ' ' '\t'
    }
    fastastats() {
        FASTA=$1
        cat $FASTA | tr -d '\n' | sed -E 's/(>[^ACGT]*)/\n\1\n/g' | grep -v '^>' |
            awk 'NF{print length}' | sort -n |
            awk '{len[i++]=$1;sum+=$1} END {for (j=0;j<i+1;j++) {csum+=len[j]; if (csum>=sum/2) {print sum;print len[j];break}}}'
        # size | N50
    }

    source ~/dotfiles/zoomsched.sh
    ZOOMROOM="https://us06web.zoom.us/j/${MI_CUARTO}"
    alias zoomroom="echo $ZOOMROOM | cpout"

    alias bkpnb='cd ~/nb && git add *ipynb; git commit -m ∆∆∆ && git push origin master; cd -'

fi


# editors
# alias python="echo 'use haskell!'"
export EDITOR=vim
export VISUAL=$EDITOR
# export EVERYWHERE_EDITOR='/usr/bin/emacsclient --alternate-editor="" -c'
# export EVERYWHERE_EDITOR='/usr/local/Cellar/emacs-mac/*/Emacs.app/Contents/MacOS/Emacs'
export GIT_EDITOR=$EDITOR

# e() { emacsclient --alternate-editor="" -nc "$@" & disown; }
if (($linux)); then
	# e() { emacs "$@" 2>&1 > /dev/null & disown; }
	# e() { emacs "$@"; }
	e() { emacsclient --alternate-editor="" -nc "$@"; }
else
	# e() { open -a Emacs "$@" & disown; }
	# e() { emacs "$@" & disown; }
	# e() { /Applications/Emacs.app/Contents/MacOS/Emacs "$@" & disown; }
	e() { /usr/local/Cellar/emacs-mac/*/Emacs.app/Contents/MacOS/Emacs "$@" & disown; }
fi

    # touche = touch + emacs
    touche() { touch "$@"; e "$@"; }


# aliasing

(( $HAS_DISPLAY )) && (( $linux )) && MEDIA="$HOME/shiff" \
                                   || MEDIA="$HOME" # aqua ^^ v. rest
# WKSPACE="$MEDIA/wkspace"
WKSPACE="$HOME/wkspace"

alias editbash='vi $HOME/dotfiles/.bash_profile && source $HOME/dotfiles/.bash_profile'
alias http='python -m SimpleHTTPServer'
# alias rc='cd $MEDIA/wkspace/rc'
alias wk="cd $WKSPACE"
alias mit='cd $MEDIA/mit'
alias quotes='vi $MEDIA/txt/quotes.txt'
alias ffl='ssh miriam@toymaker.ops.fastforwardlabs.com'
alias buffalo='whereis whereis whereis whereis whereis whereis whereis whereis'
# alias urls='ssh -t csail "vi txt/urls"'
alias xvlc='xargs -I{} vlc "{}"'
alias wip='vi "$HOME/phd/txt/mtgs/wip_$( day )"'
alias fixscroll='tput rmcup' # via https://unix.stackexchange.com/a/259971
alias pipoutdated='pip --disable-pip-version-check list --outdated'

if (( $HAS_DISPLAY )); then
    (( $linux )) && alias clipboard='xsel -i --clipboard' \
                 || alias clipboard='pbcopy'
    alias cpout='tee /dev/tty | clipboard' # clipboard + STDOUT
else
    alias cpout='xargs echo'   # w/o X11 forwarding
fi

alias arxivate='bash ~/dotfiles/arxivate.sh'
alias h5tree='bash ~/dotfiles/h5tree.sh'
alias nbmerge='python ~/dotfiles/nbmerge.py'
alias restart='bash ~/dotfiles/bashcollager.sh'
alias shrinkpdf='bash ~/dotfiles/shrinkpdf.sh'

export DELTA='Δ'
export DELTAS="${DELTA}s"

export STRFDATE="+%y%m%d"

export CSVPAT='([^,]*)|(\"([^\"]|(\"\"))*\")' # for awk

lunch()  { python $WKSPACE/mit-lunch/get_menu.py   "$@"; }
movies() { python $WKSPACE/cinematic/get_movies.py "$@"; }
lsbeer() { python $WKSPACE/lsbeer/get_beer.py      "$@"; }
vixw()   { python $WKSPACE/vixw/vixw/vixw.py       "$@"; }
8tracks-dl() {    $WKSPACE/8tracks-dl/dl.sh        "$@"; }

alias ls🏜️="curl -su $( cat $HOME/dotfiles/SECRET_amindfv )/cinemenace.txt | grep 🏜️ | sort | uniq | sort -t'(' -k2,2"

oath() { oathtool -b --totp "$@" | cpout; }
oathfromsecret() { oath "$( cat "$@" )"; }

math() { bc -l <<< "$@"; }
PI=$( bc -l <<< "scale=10; 4*a(1)" )

awkcsv() { awk -vFPAT='([^,]*)|("[^"]+")' "$@"; } # via https://stackoverflow.com/a/29650812
# awkcsv() { awk -vFPAT=$CSVPAT "$@"; } # via https://stackoverflow.com/a/29650812

charcount() {
    # delete all chars except those matching the argument, then count remaining chars
    # via https://stackoverflow.com/a/41119233
    tr -cd "$1" | wc -c
}

addup() {
    bc <<< $( cat "$@" | grep -E '^[0-9.]+' | sed 's/#.*$//' | sed 's/$/+/' | tr -d '\n' | sed 's/+$//' );
}
# tom_owes=$(echo '${MEDIA}/Documents/txt/tom_owes')
# tom() { cat '${MEDIA}/Documents/txt/tom_phones'; }
tb() { tensorboard --logdir $PWD/"$@" & google-chrome --app="http://127.0.1.1:6006" && fg; }
token() { jupyter notebook list | awk -F 'token=' '/token/ {print $2}' | awk '{print $1}' | cpout; } # jupyter notebook token
nbrerun() {
    for nb in "$@"; do
        (jupyter nbconvert --to notebook --inplace --execute --ExecutePreprocessor.timeout=600 "$nb";) &done
}

# via https://stackoverflow.com/a/31560568
alias pngcompress='convert -depth 24 -define png:compression-filter=2 -define png:compression-level=9 \
                           -define png:compression-strategy=1' # -resize 50%

shiffsymphony() { for _ in {1..1000}; do (sleep $(($RANDOM % 47)); echo -e '\a';) &done; }
# via https://unix.stackexchange.com/a/28045
chicagowind() { cat /dev/urandom | padsp tee /dev/audio > /dev/null; }
introduceyoselves() { for person in {,fe}male{1,2,3} child_{fe,}male; do spd-say "i am a $person" -t $person -w; done; }
echoooo() { echo "$@" | sed -E 's/([aeiouy])/\1\1\1\1/g'; }

coinflip() {
    [[ "$@" ]] && choices=( "$@" ) || choices=( heads tails )
    echo "${choices[$(( $RANDOM % ${#choices[@]} ))]}"
    # or:
    # via https://stackoverflow.com/a/39050850
    # shuf -en1 "$choices";
}
# test bias via:
# $ for _ in $( seq 100000 ); do coinflip; done | sort | uniq -c

echobold()          { echo -e "\e[1m$@\e[0m"; }
echoitalic()        { echo -e "\e[3m$@\e[0m"; }
echounderline()     { echo -e "\e[4m$@\e[0m"; }
echostrikethrough() { echo -e "\e[9m$@\e[0m"; }


# aqua only
(( $HAS_DISPLAY )) && (( $linux )) && (
    addmusic() { F="$MEDIA/txt/music";   echo -e "$@" >> $F; tail -n4 $F; }
    addmovie() { F="$MEDIA/txt/movies4"; echo -e "$@" >> $F; tail -n4 $F; }
)


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
    [[ -f $F ]] || wget "$URL" -qO $F                           # wget iff doesn't exist
    # [[ -f $F ]] || curl "$URL" -s > $F                         # curl iff doesn't exist (wget failed w/ 503 while curl did not..)
    echo; dashes 100; pdftotext -layout $F -; dashes 100; echo # TODO: && display if wget doesnt fail
}


alias mod='stat -c"%a"' # get mod (as in chmod) of file
cpmod() {               # cp mod (of file A, to file B)
    like="$1"
    shift
    for f in $@; do
        chmod $( mod "$like" ) "$f"
    done
}


# check available URLs for given TLD
checkURLs() {
    TLD="$@" # https://data.iana.org/TLD/tlds-alpha-by-domain.txt

    testresponse="$( whois a.$TLD )"
    if [[ "${testresponse,,}" =~ "no whois server" ]]; then
        echo "$testresponse"
        return # "it short-circuits" -scruff
    fi

    for word in $( grep ".\+${TLD}$" /usr/share/dict/words ); do # 1+ letters, ending in $TLD
        wordasURL=${word/$TLD/.$TLD}
        # [[ $( whois $wordasURL | head -n1 ) == "NOT FOUND" ]] && echo $wordasURL # unregistered # agggg not standardized at. all.
                                                                                                  # e.g. see https://learnonlinephp.wordpress.com/2015/02/11/domain-availability-check
        (( $( whois $wordasURL | grep -ic "^registr" ) )) || echo $wordasURL # unregistered
    done
}

checkPhotos() {
    BASEPATH_SIM="$1"

    BASEPATH_LOCAL="$2"
    [[ $BASEPATH_LOCAL ]] || BASEPATH_LOCAL=~/Pictures/Photos\ Library.photoslibrary/Masters

    for f in ${BASEPATH_SIM}/*; do
        # N.B. *.THM files are thumbnails (first frame of video)
        # -- not transferred; ignore
        [[ ${f,,} == *.thm ]] || checkPhoto "$f" "$BASEPATH_LOCAL"
    done
}

checkPhoto() {
    F="$1"
    IMG=$( basename $F )

    BASEPATH="$2"
    [[ $BASEPATH ]] || BASEPATH=~/Pictures/Photos\ Library.photoslibrary/Masters

    SHA=$( sha256sum "$F" | awk '{print $1}' )
    OTHER_SHAS=$( find "$BASEPATH" -name "$IMG" |
                  while read -d $'\n' f; do sha256sum "$f"; done |
                  awk '{print $1}' )

    # check for checksum match among all possible image matches;
    # only print if no match
    [[ $( echo $OTHER_SHAS | grep -c $SHA ) == 1 ]] || echo $F
}

zopen() {
    zathura "$@" &> /dev/null & disown
}

# get bounding box of img (e.g. for when pdflatex is being dumb)
getbbox() {
    gs -o /dev/null -sDEVICE=bbox "$@" 2>&1 | awk '/%%B/ {print $2,$3,$4,$5}' # redirect ghostscript STDERR to STDOUT, & parse
}

convertvid4mac() {
    INFILE="$@"
    INFMT="${INFILE##*.}"
    # via https://apple.stackexchange.com/a/166554
    ffmpeg -i "$INFILE" -pix_fmt yuv420p "${INFILE/$INFMT/mp4}"
    # if necessary: ("height not divisible by 2")
    # -vf "pad=ceil(iw/2)*2:ceil(ih/2)*2"
    # ^ via https://stackoverflow.com/a/20848224
}

alias stripexif='exiftool -all= -overwrite_original_in_place'

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


# TODO fix b/c mac only has ifconfig
# $( command -v ifconfig &> /dev/null ) && {
# $( command -v  &> /dev/null ) && {
(( $linux )) && export _checkip='ip addr' || export _checkip=ifconfig
$( command -v $( echo $_checkip | awk '{print $1}' )  &> /dev/null ) && {
    # macaddress() {
    #     ifconfig en0 | awk '/ether/ {print $2}' | cpout
    # }
    export MACADDRESS=$( $_checkip | grep eth | grep -Eio '\b([a-z0-9]{2}:)+[a-z0-9]{2}\b' | head -1 )

    # local ip (the device)
    # ip() { ifconfig | awk '/cast/ {print $2}' | sed 's/addr://'; }
    # export MY_IP_DEVICE=$( ifconfig | awk '/192./ {print $2}' )
    # export MY_IP_DEVICE=$( ip addr | awk '/inet 192/ {print $2}' | sed 's/\/.*//' )
    # export MY_IP_DEVICE=$( $_checkip | awk '/192./ {print $2}' | sed 's/\/.*//' )
    export MY_IP_DEVICE=$( $_checkip | grep -A2 eth | grep inet | grep -Eo '\b([0-9]+\.?)+\b' | head -1 )

    # IPv6
    export MY_IP_DEVICE_6=$( $_checkip | grep -A4 eth | grep inet6 | grep -Eio '\b([0-9a-z]*:)+[0-9a-z]+\b' | head -1 )

    alias server='echo -e "\nGO TO => http://${MY_IP_DEVICE}:8000\n"; python -m http.server'
}
# public ip (e.g., the router)
# via https://www.cyberciti.biz/faq/how-to-find-my-public-ip-address-from-command-line-on-a-linux/
# alias rather than export b/c don't run unless you need it (e.g., may not be connected to internet)
alias MY_IP='dig -4 +short myip.opendns.com @resolver1.opendns.com'
alias myip='echo $( MY_IP ) | cpout'


alias sourceopenstack='. ~/*openrc.sh'
# alias ip='dig +short myip.opendns.com @resolver1.opendns.com | cpout && open "https://horizon.csail.mit.edu/horizon/project/access_and_security"'
allowip() {
    IP="$@"
    [[ $IP ]] || IP=$( MY_IP )
    sourceopenstack

    (( $linux )) && flag="src" || flag="remote"
    openstack security group rule create --protocol tcp --dst-port 22 --$flag-ip $IP ssh
}


#alias rvmv='history | tail -n2 | head -n1 | awk "/\$2==\"mv\"/{print \$2,\$4,\$3;next} {print \"not mv\"}" | sh'
# rvmv() { history | tail -n2 | head -n1 | awk '{print $2,$4,$3}' | sh; }

# add appropriate suffix to unspecified file
suffix() {
  for f in "$@"; do
    SUFF=$( file -b "$f" | awk '{print $1}' )
    [ "${SUFF,,}" = "ascii" ] && SUFF="txt"
    [ "${SUFF,,}" = "bourne-again" ] && SUFF="sh"
    [ "${SUFF,,}" = "mpeg" ] && SUFF="mp4"

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
lsbiggest() {
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
lstoday() {
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


lssince() {
    # check for valid date
    maybe_dt="$( echo "${1,,}" | sed -re's/wk/week/' -e's/\b(((day)|(week)|(month))s? *$)/\1 ago/' -e's/weds/wed/')"
    maybe_dt="$maybe_dt 1" # 1 just sets time if not necessary
                           # else, check for (1st of) month

    [[ $( date -d"$maybe_dt" 2> /dev/null ) ]] && with_date=1 || with_date=0
    [[ $( date -d"last $maybe_dt" 2> /dev/null ) ]] && with_date=1 && maybe_dt="last $maybe_dt" # last weds

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


cdrecent() {
    [[ "$@" ]] && DIR="$@" || DIR="."
    RECENTEST="$( ls -dt "$DIR"/*/ | head -n1 )"
    cd "$RECENTEST"
}

virecent() {
    [[ "$@" ]] && DIR="$@" || DIR="."
    RECENTEST="$( ls -alh -dt "$DIR"/* | awk '$1!~/^d/{print $9}' | head -n1 )" # excluding directories
    vi "$RECENTEST"
}


# get YYMMDD (default: today)
day() {
    [[ $# == 0 ]] && dt="today" || dt="$@"     # no args -> today
    dt=$( echo $dt | sed 's/\bweds\b/wed/g' |  # i am bad at wkday abbrevs
                     sed 's/\bwk\b/week/g' )

    [[ "${dt,,}" == "tomorr" ]] && dt+="ow"    # tomorr -> tomorrow
    [[ "${dt,,}" == "tom" ]] && dt+="orrow"    # tom -> tomorrow
    [[ "${dt,,}" == "tmr" ]] && dt="tomorrow"  # tmr -> tomorrow
    [[ "${dt,,}" == "tom murphy" ]] && echo "that's my date not *a* date" \
                                    || date -d "$dt" $STRFDATE;
}

# prepend file with date
predate() {
    F="$@"

    # match date if already in name
    DATE=$( echo $F | grep -Eo '[0-9]{6}' )
    # else, get best guess file touch date
    # TODO: `ls` vs. `stat`
    (( $DATE )) || DATE=$( day "$( ls -alh "$F" | awk '{print $6,$7}' )" )

    # Fundated=$( echo $F | sed "s/$DATE//" | sed -e's/_+/_/g' -e's/^_//' -e 's/_$//' )
    Fundated=$( echo $F | sed "s/$DATE//" | sed -e's/^_//' -e 's/_$//' )

    echo "${DATE}_${Fundated}"
}


browse_csv() {
    cat "$1" | sed -E 's/(\.[0-9][0-9][0-9])[0-9]*/\1/g' | # 3 digit significance
        column -t -s, | less -S
}


# only print 1st `n` levels (collapse rest)
# adapted from https://github.com/stedolan/jq/issues/306#issuecomment-35975958
jqfirstn() {
    n="$1"; shift
    levels=$( yes "[]?" | head -n $n | tr -d '\n' )
    jq 'reduce path(.'"$levels"') as $path (.; setpath($path; {}))' "$@"
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


if (( $HAS_DISPLAY )); then
    # ffox stuff
    (( $linux )) && PREFIX="$HOME/.mozilla/firefox" \
                 || PREFIX="$HOME/Library/Application Support/Firefox"

    _get_ffox() {
        SESSION=$( awk -F'=' '/Path/ {print $2}' "$PREFIX"/profiles.ini |
                    tail -n1 ) # assumes the "right" one is last.. # TODO: can prob incorporate into awk
        echo "$PREFIX/$SESSION"
    }
    _catjsonlz() {
        if (( $linux )); then
            cat "$@" | dejsonlz4 -
        else
            dejsonlz4 "$@"
        fi
    }
    if [[ -d "$PREFIX" ]]; then
        export FFOX_PROFILE="$( _get_ffox )"

        # save open ffox tabs
        # inspired by https://superuser.com/questions/96739/is-there-a-method-to-export-the-urls-of-the-open-tabs-of-a-firefox-window
        openTabs(){
            # cat "$PREFIX"/$SESSION/sessionstore-backups/recovery.js |
            # cat "$PREFIX"/$SESSION/sessionstore-backups/recovery.jsonlz4 |
            # cat "$FFOX_PROFILE/sessionstore-backups/recovery.jsonlz4" |
            #  dejsonlz4 - |
            dejsonlz4 "$FFOX_PROFILE/sessionstore-backups/recovery.jsonlz4" |
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

        getAddons() {
            # exclude addons that are not automatic ffox extensions
            cat "$FFOX_PROFILE/extensions.json" |
                # jq -c '.addons[] | select(.path | test("/extensions/")).defaultLocale.name' |
                jq -c '.addons[] | select(.location == "app-profile").defaultLocale.name' |
                tr -d '"'
        }
        export -f getAddons
    fi


    # alternately: safari
    openTabsSafari() {
        DELIM=" <> "
        getTabInfo() {
            osascript -e "tell app \"Safari\" to set AppleScript's text item delimiters to \"$DELIM\"" \
                      -e "tell app \"Safari\" to $1 of tabs of windows as string"
        }
        urls=$( getTabInfo URL )
        names=$( getTabInfo name )
        N=$( echo $urls | awk -F"$DELIM" '{print NF}' )
        for i in $( seq $N ); do
            echo "#" $( echo $names | awk -F"$DELIM" -vi=$i '{print $i}' )
            echo $( echo $urls | awk -F"$DELIM" -vi=$i '{print $i}' )
            echo
        done;
    }
    getOpenTabsSafari(){ openTabsSafari | cpout; }
    saveOpenTabsSafari(){ f=./tabs_$( day ); openTabsSafari > "$f"; echo "     --> $f"; }


    zoom() {
        source ~/dotfiles/zoomsched.sh # for DATETIME2ID + MI_CUARTO

        if [[ "$@" ]]; then # if argument passed, use as ID for call

            unset closest
            [[ "$@" != 47 ]] && callid="$@" || callid=$MI_CUARTO
            # callid="$@"

        else                # else, find nearest meeting
            declare -A timedelta2datetime

            NOW=$( date +%s )
            timedelta() { echo $(( $NOW - $( date -d "$@" +%s ) )) | tr -d '-'; } # absolute value (;

            # iterate over newline-separated datetimes, alphabetically sorted
            # this is a total hack to make "everyday" meetings have lowest priority,
            # since numbers come before letters (so will be clobbered)

            local IFS=$'\n' # via https://askubuntu.com/a/344418
            for dt in $( echo "${!DATETIME2ID[@]}" | sed 's/m /m\n/g' | sort ); do
                timedelta2datetime[$( timedelta "$dt" )]="$dt"
            done

            min=$( echo "${!timedelta2datetime[@]}" | tr ' ' '\n' | sort -g | head -n1 )
            closest=${timedelta2datetime[$min]} # closest matching meeting datetime
            callid=${DATETIME2ID[$closest]}     #  & corresponding meeting ID

        fi

        callurl="https://zoom.us/wc/join/$callid"
        echo "$closest ►► $callurl"
        echo $callurl | clipboard # just in case

        if (( $linux )); then
            _chrome=$( echo $( which chromium ) $( which chrome ) | awk '{print $1}' )
            CHROME() { $_chrome --new-window --app="$@" &> /dev/null & disown; }
        else
            _chrome="$( ls -d /Applications/*Chrom* | xargs | awk -F'/Applications/' '{print $2}' )"
            CHROME() { open -na "$_chrome" --args --new-window --app="$@" && \
                        # caffeinate -d -w $( ps aux | grep zoom | awk 'NR==1{print $2}' ); }
                        caffeinate -d -w $( ps aux | awk '/zoom/ {print $2; exit}' ); }
                        # caffeinate -d -w $( ps aux | awk -v callurl="$callurl" '/callurl/ {print $2; exit}' ); }
                        # ^ don't sleep display during mtg
        fi

        if [[ $_chrome ]]; then
            CHROME $callurl
        else
            echo "[[ chrom{e,ium} not found ]]"
        fi
    }
fi


# download big (>100 Mb) files from google drive
# via https://medium.com/@acpanjan/download-google-drive-files-using-wget-3c2c025a8b99
gdownload() {
    SHARE_URL=$1
    FILE_OUT=$2

    FILE_ID=$( echo "$SHARE_URL" | sed -E 's@^.*file/d/([^/]*)/.*$@\1@' )
    CONFIRM=$( wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate "https://docs.google.com/uc?export=download&id=${FILE_ID}" -O- |
                sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p' )
    wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=${CONFIRM}&id=${FILE_ID}" -O "$FILE_OUT" \
        && rm /tmp/cookies.txt

    # gdownloadsmall:
    # wget --no-check-certificate "https://docs.google.com/uc?export=download&id=FILE_ID" -O "$FILE_OUT"
}


# terminal tab title
# via https://recurse.zulipchat.com/#narrow/stream/Unix.20commands/subject/change.20terminal.20tab.20title.20(OSX)
t() {
    TITLE=$@
    PATTERN="||"
    echo -en "\033]2;$PATTERN ${TITLE^^} $PATTERN\a"
}


##### pandoc
##### eval "$(pandoc --bash-completion)"
# markdown -> man page
##### md() { pandoc -s -f markdown -t man "$*" | man -l -; }

# conda envs
# alias p3='source activate py36'
# alias d='source deactivate'

# python stuff
(($linux)) && PIPCACHE=$HOME/.cache/pip || PIPCACHE=$HOME/Library/Caches/pip
alias pip-clean='\rm -r $PIPCACHE/*'

# alias python=python3
export PATH="$HOME/.local/venv/bin:$PATH"

pyfind(){ python -c "import ${1}; print(${1}.__file__)"; } # find a pkg
export PYTHONBREAKPOINT="IPython.embed" # via builtin breakpoint()


# osx only
if ((!$linux)); then
    alias vlc='open -a VLC'
    alias chrome='open -a /Applications/Google\ Chrome.app'
    alias ffox='open -a /Applications/Firefox.app'
    alias preview='open -a /Applications/Preview.app'
    alias zotero='open -a /Applications/Zotero.app'

    alias tmpchrome="open -na /Applications/Google\ Chrome.app --args --new-window --user-data-dir=$( mktemp -d )"

    #for g in gcc g++; do
       #GPATH=$( ls /usr/local/Cellar/gcc/*/bin/${g}* | grep ${g}-[0-9] | tail -n1)
       #alias $g=$GPATH
       #sudo ln -s $GPATH /usr/local/bin/${g}
    #done

	alias phil='chrome "https://docs.google.com/document/d/1Bcfz3Tl_T78nx9VLnOyoyn4rrvpjFH2ol8PJ9JMk97U/edit";
			open -a Skype; open -a Evernote'

    # fix
    alias fixvimcolors='sed -ri".tmp" -e"s/=SlateBlue/=#6a5acd/g" \
                                      -e"s/=Orange/=#ffa500/g" ${VIMRUNTIME}"/syntax/syncolor.vim"'

	# copy to clipboard without trailing \n
	alias copy='tr -d "\n" | pbcopy; echo; echo pbcopied; echo'
	alias cpy='copy'

    # screen shots
    alias update_screenshots='mv ~/Desktop/Screen* ~/pix/screenshots; rsync -rz --progress ~/pix csail:./macos'
    last_screenshot() { ls ~/Desktop/Screen\ Shot\ 2* | tail -n1; }

    # reset illustrator trial
    resetadobe() {
        f="/Applications/Adobe Illustrator CC 2018/Support Files/AMT/AI/AMT/application.xml"
        oldn=$( awk -F'[<>]' '/TrialSerial/{print $3}' "$f" )
        newn=$( math "$oldn + 1" )
        sudo sed -i'.tmp' -E "s/(TrialSerial.*)$oldn/\1$newn/" "$f"
    }

	# internet tabs --> file
	tabs() {
        now=$( date $STRFDATE )
        for app in safari; do #"google chrome" firefox;
            osascript -e'set text item delimiters to linefeed' -e'tell app "'${app}'" to url of tabs of window 1 as text' >> tabs_${now}
        done
    }

    alias kickstart='sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart'

# linux only
else
	alias iceweasel='firefox &> /dev/null & disown'
	# alias iceweasel='/usr/lib/iceweasel &> /dev/null & disown'

	alias netflix='google-chrome --app=https://www.netflix.com &> /dev/null'

	alias zotero='/usr/lib/zotero/zotero &> /dev/null & disown'

    alias fixscroll='tput rmcup' # via https://askubuntu.com/a/123296

	screenshot(){ sleep 5; gnome-screenshot -af ~/Downloads/"$@"; }

	# mass xdg-open
	open(){ for f in "$@"; do xdg-open "$f" &> /dev/null & disown; done; }

    # wifi on/off
    airplane_mode() {
        OPS=(on off)

        [ $( nmcli radio wifi ) == "enabled" ] && i=0 || i=1
        from=${OPS[$i]}
        to=${OPS[1 - $i]} # flip

        nmcli radio wifi $to
        echo "${from^^} ↪ ${to^^}"
    }

    cycle_wifi() {
        echo 1 | sudo tee /sys/bus/pci/devices/0000\:02\:00.0/remove
        sudo killall wpa_supplicant
        sleep 1
        echo 1 | sudo tee /sys/bus/pci/rescan
        sleep 2
        sudo rmmod iwlmvm iwlwifi && sudo modprobe iwlmvm iwlwifi
        sudo ip link set wlo1 up # sudo ifconfig wlan0 up
        sudo service network-manager restart
    }

    # via https://unix.stackexchange.com/a/724963
    # gpick --pick does not work b/c of xwayland (only w/ older x11)
    colorpicker() {
        # get the gdbus output
        output=$( gdbus call --session --dest org.gnome.Shell.Screenshot --object-path /org/gnome/Shell/Screenshot --method org.gnome.Shell.Screenshot.PickColor )
        colors=( $(echo $output | command grep -o "[0-9\.]*") )

        # convert to 255-based RGB format
        for ((i = 0; i < ${#colors[@]}; i++)); do
            colors[$i]=$( printf '%.0f' $(echo "${colors[$i]} * 255" | bc) )
        done

        echo    "RGB: ${colors[0]} ${colors[1]} ${colors[2]}"
        # printf "HEX: #%02x%02x%02x\n" "${colors[0]}" "${colors[1]}" "${colors[2]}"
        HEX=$( printf "#%02x%02x%02x" "${colors[0]}" "${colors[1]}" "${colors[2]}" )
        echo -n "HEX: " && echo -n $HEX | cpout # hex -> clipboard
        echo
    }
fi


# list all packages from ```$ apt-get install```, in historical order
# inspired by http://askubuntu.com/questions/17823/how-to-list-all-installed-packages
if (($linux)); then
    # find all packages uninstalled via ```$ apt-get remove```
    # redirect errors if no gzipped history log to /dev/null
    # pkgs() {
    #     uninstalled=$(
    #         ( zcat $(ls -tr /var/log/apt/history.log*.gz 2>/dev/null) 2>/dev/null;
    #         cat /var/log/apt/history.log ) |
    #             #egrep "^(Start-Date:|Commandline:)" | grep -v aptdaemon |
    #             # combination sed/grep for removed pkg names, minus -options
    #             sed -nr "s/^Commandline: apt-get remove (-. )?//p" |
    #             # transform into regex to grep out
    #             tr "\n " "|" | sed "s/|$//"
    #             )

    #     ( zcat $( ls -tr /var/log/apt/history.log*.gz 2>/dev/null) 2>/dev/null;
    #     cat /var/log/apt/history.log ) |
    #         #egrep "^(Start-Date:|Commandline:)" | grep -v aptdaemon |
    #         # combination sed/grep for all installed pkgs names, minus -options
    #         sed -nr "s/^Commandline: apt-get install (-. )?//p" |
    #         # grep out uninstalled (unless empty)
    #         egrep -v ${uninstalled:-NADA_MUCHO};
    # }

    # ^^ this stops working when history logs get rotated out ! (== deleted)
    # much simpler:
    # via https://askubuntu.com/a/496042
    pkgs() {
        apt-mark showmanual
    }
  else
    pkgs() {
        # cd ${HOME}/dotfiles/pkgs
        # rm Brewfile && brew bundle dump # with package-install options

        # brew list
        BREWPREFIX="$( brew --prefix)/opt"
        for keg in $( ls $BREWPREFIX ); do
            printf "%s " $keg
            jq -r '.used_options | join(" ")' < $BREWPREFIX/$keg/INSTALL_RECEIPT.json
        done | sort

	    # cd -
    }
fi
export -f pkgs


# pretty print git log (via Mary @RC)
alias gl='git log --graph --pretty="format:%C(yellow)%h%Cblue%d%Creset %s %C(white)"'
alias gitcontrib='git shortlog -sn'
alias gs='git --no-pager diff -w -G"^ *[^#]+$" --stat' # see e.g. https://stackoverflow.com/questions/16527215/how-to-make-git-diff-ignore-comments
gb() {
    if [[ "$@" ]]; then
        BRANCH="$@" # name of new branch
        BASE=$( git branch | sed 's/^\*//' | grep -e"^ *ma"{ster,in} | head -1 ) # ma{ster,in} branch
        git checkout $BASE && git pull origin $BASE && \
            git branch $BRANCH && git checkout $BRANCH && \
            git branch
    else
        # if no argument, just list most recent
        git -c color.ui=always branch --sort=-committerdate | head
    fi
}
# show recent branches
#  - top n
# alias gbrecent='git -c color.ui=always branch --sort=-committerdate | head'
#  - up to ma{in,ster}
# alias gbrecent='git -c color.ui=always branch --sort=-committerdate | sed "/ma[(in)|(ster)]/q"'

# via https://stackoverflow.com/a/2929502
gg() { # git grep (of all LoC in git history)
    git rev-list --all | xargs git grep ''$@''
}

if [ -f ~/.git-completion.bash ]; then
      . ~/.git-completion.bash
fi
if [ -f ~/.git-annex-completion.bash ]; then
      . ~/.git-annex-completion.bash
fi

# via https://stackoverflow.com/a/50158675
gitrmpattern() {
    filename=$1
    from=$2
    to=$3
    args=$4
    # git stash
    git filter-branch $args --tree-filter "test -f \"$filename\" && sed -i -E \"s°$from°$to°g\" \"$filename\" || echo \"skipping $filename\"" -- --all
    # git stash pop
}
gitrmline() {
    filename=$1
    pattern=$2
    args=$3
    # git stash
    git filter-branch $args --tree-filter "test -f \"$filename\" && sed -i -E \"°$pattern°d\" \"$filename\" || echo \"skipping $filename\"" -- --all
    # git stash pop
}
# or try
# $ git-filter-repo --force --replace-text path/to/expressions.txt # FROM==>TO


# http://desk.stinkpot.org:8080/tricks/index.php/2006/12/give-rm-a-new-undo/
(($linux)) && export TRASHDIR="${HOME}/.local/share/Trash/files" \
           || export TRASHDIR="${HOME}/.Trash"
alias rm='~/dotfiles/safe_rm.sh'
alias cp='cp -i'
alias mv='mv -i'
# untrash() { # unrm ?
unrm() {
    [[ "$@" ]] && F="$@" || F="$( ls -t $TRASHDIR | head -n1 )"
    mv "$TRASHDIR/$F" .
    echo "recovered: $F"
}

alias psychogrep='grep -RIi'
alias vinilla='vi -u NONE'


# history

export HISTSIZE="INFINITE" # via https://superuser.com/questions/479726/how-to-get-infinite-command-history-in-bash
# HISTFILESIZE=100000 # 10^6
export HISTFILESIZE=$HISTSIZE

# ignore 1-2 letter commands, variants of ls, pwd
# HISTIGNORE="??:ls -?:ls -??:ls -???:pwd"
export HISTIGNORE="?:??:pwd:history"

# ignore duplicates
# HISTCONTROL=erasedups
export HISTCONTROL=ignorespace:ignoredups

# via https://www.shellhacks.com/tune-command-line-history-bash/
# append rather than overwriting history (which would only save last closed bash sesh)
shopt -s histappend
# reedit a history substitution line if it failed
shopt -s histreedit
# edit a recalled history line before executing
shopt -s histverify
# multi-line commands in 1 history entry
shopt -s cmdhist
# allow import of aliases from sourced scripts (i.e. when expand aliases even when shell is not interactive)
shopt -s expand_aliases

# make commands executed in one shell immediately accessible in history of others
# i.e. append, then clear, then reload file
# export PROMPT_COMMAND="history -a; history -c; history -r"
# export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
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
_term_title() { # current directory as term title
    DIR=$( basename "${PWD/$HOME/"~"}" )
    (( $HAS_DISPLAY )) && TITLE="$DIR" \
                       || TITLE="$HOSTNAME:  $DIR"

    echo -ne "\033]0; ${TITLE}\007"
}

export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}_bash_history_sync;_term_title"
# PROMPT_COMMAND="${PROMPT_COMMAND:+${PROMPT_COMMAND} ;}history -a"

# extended regex - e.g. $ ls !(*except_this)
shopt -s extglob


# prompt stuff

# succinct cmd line (abbrev working dir only)
Wshort() { # inspired by https://askubuntu.com/a/29580
    W=$( basename "${PWD/$HOME/"~"}" )
    (( ${#W} > 30 )) && W="${W::10}…${W:(-19)}" # 1st 10 … last 19
    echo $W
}
devicePrefix() {
    PATH_DEVICE="/media/$USER/"
    DEVICE=$( echo "${PWD/$PATH_DEVICE}" | awk -F'/' '{print $1}' )
    # add prefix iff on external device
    [[ "$PWD" =~ "/media/$USER/" ]] && echo " $DEVICE: " \
                                    || echo " "
}

# homebase vs remote / server
# *italicize* device & *bold* remote
# (( $HAS_DISPLAY )) && export PS1=" \$( Wshort ) \$ " \
(( $HAS_DISPLAY )) && export PS1="\[\e[3m\]\$( devicePrefix )\[\e[0m\]\$( Wshort ) \$ " \
                   || export PS1="\[\e[1m\]\h:\[\e[m\] \$( Wshort ) \$ "
# (( $HAS_DISPLAY )) && export PS1=" \W \$ " \
#                    || export PS1="\e[1m\h:\e[m \W \$ "

# extra space before Wshort for osx
(( !$linux )) && export PS1=" $PS1"

case "$TERM" in
	"dumb")
	    export PS1="> " # make tramp compatible ?
	    ;;
	*)
        export PS1="$PS1"
	    ;;
esac

# Path thangs

# echo locks in expansion
CONDA="$( echo $HOME/*conda3 )" # {ana,mini}conda
# if ! echo $CONDA | grep -q '*'; then # wildcard expanded to valid conda
# check for literal "*"; else:
if [[ ! "$CONDA" =~ .*\*.* ]]; then # wildcard expanded to valid conda
    export PATH="$CONDA/bin:$PATH"
    export PYTHONPATH="$CONDA/bin/python"
fi

# via https://stackoverflow.com/a/61355987
# rename conda environment
mvenv () { conda create --prefix ~/.conda/envs/${2} --copy --clone $1 ; conda remove --name $1 --all ;}

# Works as long as initialize virtual environment with "virtualenv .venv"
# alias venv='source .venv/bin/activate'

# don't let conda vs override
if [[ -d /usr/local/Cellar ]]; then
    for PROG in pandoc youtube-dl; do
        (( $linux )) && alias $PROG=/usr/bin/$PROG \
                     || alias $PROG=/usr/local/Cellar/$PROG/*/bin/$PROG
    done
fi

# fix CURL certificates path
# http://stackoverflow.com/questions/3160909/how-do-i-deal-with-certificates-using-curl-while-trying-to-access-an-https-url
# (($linux)) && export CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt

# osx stuff
if ((!$linux)); then
	# added for homebrew, coreutils
    GNUPATH=$( echo "/usr/local/opt/"{grep,coreutils,gawk,gnu-{sed,tar,which,indent}}"/libexec/gnubin:" |
               sed 's/ //g' )
    GNUMANPATH=$( echo $GNUPATH | sed 's/gnubin/gnuman/g' )

    PATH="${GNUPATH}${PATH}"
    # MANPATH="${GNUMANPATH}${MANPATH}"
    MANPATH="${GNUMANPATH}$( manpath )"

    # brew
    # PATH="/usr/local/Cellar:$PATH"
    PATH="/usr/local/sbin:$PATH"

    # either: symlink once OR explicitly alias
    # ln -s /usr/local/Cellar/vim/*/bin/vim /usr/local/bin/vim
    # alias vim=/usr/local/Cellar/vim/*/bin/vim # homebrew version
	alias vi=vim
    export VIMRUNTIME=/usr/local/Cellar/vim/*/share/vim/*

	# latex
	PATH="/Library/TeX/texbin/:$PATH"

    alias pdfjoin='/System/Library/Automator/Combine\ PDF\ Pages.action/Contents/Resources/join.py'

    # LD stuff
    export CPPFLAGS="-I/usr/local/include"
    export LDFLAGS="-L/usr/local/lib"

    # brew autocomplete
    autobrew="$(brew --prefix)/etc/bash_completion.d/brew"
    [[ -f "$autobrew" ]] && . $autobrew
	# if [ -f $(brew --prefix)/etc/bash_completion.d/brew ]; then
	#    . $(brew --prefix)/etc/bash_completion.d/brew
	# fi
# else
#     export VIMRUNTIME="$HOME/.bin/usr/bin/vim.basic"
fi



if (($linux)); then # non-kingdom
    # ace servers

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
    # alias vuq='sudo vpnc uq'
    # alias vdc='sudo vpnc-disconnect'


    # broad VPN up/down
    # help via https://gist.github.com/moklett/3170636
    VPNPID="$HOME/.openconnect.pid"
    if (( $linux )); then
        upvpn() {
            # [[ "${@,,}" == "nonsplit" ]] && GRP="Duo-Broad-NonSplit-VPN" \
            #                              || GRP="Duo-Split-Tunnel-VPN" # default: split
            # GRP="Duo-Broad-NonSplit-VPN"
            GRP="Duo-Split-Tunnel-VPN"
            VPNURL="https://vpn.broadinstitute.org"

            # echo -e "$@" |
            # sudo openconnect --pid-file $VPNID --user=shiffman \
                # --authgroup=$GRP $VPNURL
                # --token-mode yubioath
                # --background
            sudo openconnect --user=shiffman --authgroup=$GRP $VPNURL "$@"
        }
    else
        upvpn() {
            # GRP="Duo-Broad-NonSplit-VPN"
            GRP="Duo-Split-Tunnel-VPN"
            VPNURL=69.173.127.10

            sudo openconnect -u shiffman --authgroup $GRP $VPNURL "$@" \
                --servercert pin-sha256:$( cat $DIR/SECRET_broad )
                # --token-mode yubioath
                # --background
        }
    fi
    downvpn() {
        if [[ -f $VPNPID ]]; then
            sudo kill "$( cat $VPNPID )" && rm $VPNPID
            pgrep openconnect
        else
            echo "vpn not running."
        fi
    }
fi


# autocomplete screen
complete -C "perl -e '@w=split(/ /,\$ENV{COMP_LINE},-1);\$w=pop(@w);for(qx(screen -ls)){print qq/\$1\n/ if (/^\s*\$w/&&/(\d+\.\w+)/||/\d+\.(\$w\w*)/)}'" screen

(( $HAS_DISPLAY )) || export QT_QPA_PLATFORM=offscreen # make tensorflow / matplotlib work if server

export MKL_THREADING_LAYER=GNU # make theanify work


# The next lines update PATH for the Google Cloud SDK,
#              & enable shell command completion for gcloud.
# for f in "$HOME/google-cloud-sdk/{path,completion}.bash.inc"; do
#     [[ -f "$f" ]] && source "$f"
# done


# non-broad
if ! [[ ${DISTRO,,} =~ "red hat" ]]; then

    # last but far from least... fancify
    bash ~/dotfiles/horizon.sh # populate /tmp/darksky

    # prepend moon
    MOON=$( bash ~/dotfiles/moony.sh )
    (( $HAS_DISPLAY )) && export PS1="$MOON$PS1" \
                       || export PS1="$MOON $PS1"

    # echo sun
    SUN=$( bash ~/dotfiles/sunny.sh )
    [[ $SUN ]] && echo $SUN # skip if no return

    # check metrograph !
    # csail server only
    # (( ! $HAS_DISPLAY )) && [[ ${DISTRO,,} =~ "debian" ]] && \
    #     bash ~/dotfiles/metrographer.sh

    # david lynch horoscope, etc
    # brodecomp only
    (( ! $HAS_DISPLAY )) && [[ ${DISTRO,,} =~ "ubuntu" ]] && {
        # STUFF=$( wget -q https://www.astrology.com/horoscope/daily/gemini.html -O - |
        #             grep -A10 '"content-date"' | grep font | sed -E 's/^.*">([^<]*)<.*$/\1/' )
        # STUFF=$( wget -q -O - https://www.brainyquote.com/authors/david-lynch-quotes https://www.brainyquote.com/authors/david-lynch-quotes_2 |
        #           grep -A 1 display | grep -v -e "^--$" -e "^<div" | sed "s/&#39;/'/g" | shuf | head -n1 )

        F="/tmp/dkl_$( day )"
        [[ -f "$F" ]] || {
            # wget -q -O - https://www.brainyquote.com/authors/david-lynch-quotes https://www.brainyquote.com/authors/david-lynch-quotes_2 |
            cat $HOME/dotfiles/source_dkl-quotes |
                grep -A 1 display | grep -v -e "^--$" -e "^<div" | sed "s/&#39;/'/g" | shuf | head -n1 > $F
        }
        STUFF=$( cat $F | sed 's/\. /.\n/g' )
        echo -e "\n\e[3m${STUFF}\e[0m\n — David Lynch\n"
        # echo -e "\n\e[3m` cat $F `\e[0m\n— David Lynch\n"

        export PATH="/usr/local/texlive/2020/bin/x86_64-linux:$PATH"
        export PATH="$HOME/.bin:$PATH"
        export LD_LIBRARY_PATH="$HOME/.bin/usr/lib:$LD_LIBRARY_PATH"

        # pprof
        export PATH="$PATH:${HOME}/bin/go/bin"
        alias pprof='${HOME}/go/bin/pprof'

        alias lsgpu=nvidia-smi

        sudo_apt_get_install() {
            apt-get download "$@" && \
                DEB="$( echo "$@"*.deb )" && \
                dpkg -x "$DEB" ~/.bin && \
                echo "--> installed $@ to ~/.bin"
        }

    }

# broad servers
else

    DK_DEFAULTS="taciturn reuse dkcomplete"

    use -q $DK_DEFAULTS # quietly load

    # succinct cmd line (working dir only)
    load_prompt() {
        #LS_USE=$( use | grep -A 10 'Packages in use:' | awk 'NR>1 && $0' | xargs | sed 's/ /, /g' )
        LS_USE=$( use | grep -A 10 'Packages in use:' | grep '^  \w' |
                  grep -Eve'^  default\+*$' -e"$( echo $DK_DEFAULTS | sed 's/ /|/g' )" |
                  xargs | sed 's/ /, /g' )
        # export PS1="($LS_USE) \e[1m\h:\e[m \W \$ "
        export PS1="($LS_USE) \e[1m\h:\e[m \$( Wshort ) \$ "
    }
    load_prompt

    # make CWD nice
    TMPWD="$HOME/.cwd"

    [[ -f $TMPWD ]] && source $TMPWD  # maybe `cd`, &
    echo "cd $HOME/shiffman" > $TMPWD # reset to default

    alias insh='echo "cd $PWD" > $TMPWD; qrsh -q interactive -P regevlab -l os=RedHat7 -l h_rt=3:00:00'
    # alias insh='echo "cd $PWD" > $TMPWD; qrsh -q interactive -P regevlab'
    alias ddt='utilize GCC-5.2 Anaconda3 && source activate ddt && cd $HOME/shiffman/tree-ddt'
    alias editbash='echo "cd $PWD" > $TMPWD; vi ~/dotfiles/.bash_profile && source ~/dotfiles/.bash_profile' # re-alias

    # utilize >> use
    utilize()   {   use "$@" && load_prompt; }
    reutilize() { reuse "$@" && load_prompt; }
    unutilize() { unuse "$@" && load_prompt; }

    utilize UGER

    # functions[use]='
    #   (){ '$functions[use]'; } "$@"; local myret=$?
    #   echo "hellooo"
    #   return $myret'

    # use() { local source /broad/software/scripts/useuse && use "$@" && load_prompt; }
    # reuse() { reuse "$@" && load_prompt; }
    # unuse() { unuse "$@" && load_prompt; }

    # turn on autocompletion
    # via /broad/software/dotkit/bash/dkcomplete.d
    complete -W '`$DK_ROOT/etc/use-usage 1`' utilize
    complete -W '`$DK_ROOT/etc/use-usage 1`' unutilize
    complete -W '`$DK_ROOT/etc/use-usage 1`' reutilize

    # inspired by https://stackoverflow.com/a/30935977
    # verbose qstat (long jobnames)
                                          # fewer sig figs in job priority, clean up datetime, etc:
                                          # ARG bash won't let me inline comments
    _vqstat() { qstat -xml | tr -d '\n' | sed -re 's/<job_list[^>]*>/\n/g' -e 's/<queue_name>[^>]*>//g' \
                                              -e 's/<JAT_prio>([.0-9]{4})[^>]*>/\1/g' \
                                              -e 's/<[^>]*>//g' -e 's/shiffman//g' \
                                              -e 's/20([-0-9]*)T([0-9]*:[0-9]*)[^ ]*/\1 \2/g' \
                           | awk '$NF'; } #| column -t; }
    # with header..
    vqstat() { (qstat | head -n1 | sed -re 's/(queue|user|jclass|ja-)//g' \
                                       -e 's/submit\/start at/date time/' \
                    && _vqstat) | column -t | awk 'NR==1 {print $0; gsub(".","-")}1'; } # dashes to underline full header

    # awk 'NR==1{print $0; gsub(".","-")}1'
    # && _vqstat) | column -t | 'NR==1 {print $0"\n"sub(/*/,"-",$0)} NR>1 {print}'; }
    # && _vqstat) | column -t | awk -v dashes=$( dashes $COLUMNS ) 'NR==1 {print $0"\n"dashes} NR>1 {print}'; }
    # && dashes $( math "scale=0; 3 * $COLUMNS" / 4)

    # OS=$( cat /etc/redhat-release | sed -e"s/^.*release //" -e"s/ (.*$//" )
    # # check major (int) version
    # (( "${OS%.*} > 7" )) && vimdir='$HOME/bin/vim' || vimdir='/usr/bin/vim'
    # alias vim=$vimdir
    # broad finally updated to >= redhat 7..
    alias vim=$HOME/bin/vim
    alias vi=vim

    # refresh editors
    # export EDITOR=$vimdir
    export EDITOR=vim
    export VISUAL=$EDITOR
    export GIT_EDITOR=$EDITOR

    export LANG="en_US.utf8" # b/c broad defaults are :(
    export LD_LIBRARY_PATH=/user/lib64:/lib64:$LD_LIBARY_PATH

    # make jupyter notebooks work
    export HOSTADDR=$( hostname -i )

    # shortcut to run notebook in screen
    nb() {
        if [[ "$( which python )" =~ "conda" ]]; then # conda already loaded
            ENV="$( which python | sed -En 's@.*envs/([^/]*).*@\1@p' )" # empty == base
            conda deactivate # else, will not activate in screen
        else
            ENV=""
            utilize Anaconda3
        fi
        wait

        NAME="nb"
        screen -dmS $NAME
        SESH=$( screen -ls | grep "\.$NAME\b" | awk '{print $1}' )
        # via https://askubuntu.com/a/597289
        screen -S $SESH -X stuff 'utilize Anaconda3 && source activate ddt && \
            jupyter notebook --no-browser --port=4747'

        # screen -S $SESH -X stuff 'jupyter notebook list > ~/.nbfg'
        # cat ~/.nb | awk "/^http/ {print $1}"

        wait
        [[ $ENV ]] && source activate $ENV # restore environment, if any
        jupyter notebook list | awk '/^http/ {print $1}'
    }
fi

##
# Your previous /Users/miriam/.bash_profile file was backed up as /Users/miriam/.bash_profile.macports-saved_2020-08-31_at_14:45:08
##

# MacPorts Installer addition on 2020-08-31_at_14:45:08: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# recommended by `brew doctor`
export PATH="/usr/local/sbin:$PATH"

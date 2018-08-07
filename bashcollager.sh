#!/bin/bash

F_TIMES="${HOME}/collagertimes"

vlc_hook_off(){
    f=$( basename "$@" )
    TMP="${F_TIMES}.tmp"

    # remove preexisting
    grep -v "$f" $F_TIMES > $TMP

    read -p "Enter stoptime (or q): " stoptime

    # update (or leave removed)
    [[ ${stoptime,,} == q ]] || echo -e "$f\t$stoptime" >> $TMP

    \mv $TMP $F_TIMES
}

vlc_hook_on(){
    f=$( basename "$@" )
    starttime=""

    # pattern match filename & get time
    starttime=$( awk -F'\t' -v f="$f" '$1==f{print $2}' $F_TIMES )
    [[ $starttime ]] || starttime=0 # default to beginning

    # total seconds
    startsecs=$( echo $starttime | awk -F':' '{out=""; for (i=1; i<=NF; i++) out=out+$i * (60^(NF-i)) } END {print out}' )

    vlc --start-time $startsecs "$@"
}

#restart(){
#    touch $F_TIMES
#
#    for f in "$@"; do
#        vlc_hook_on "$f" && vlc_hook_off "$f"
#    done
#}


touch $F_TIMES
for f in "$@"; do
    vlc_hook_on "$f" && vlc_hook_off "$f"
done

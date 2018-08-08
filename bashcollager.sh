#!/bin/bash


F_TIMES="${HOME}/collagertimes"


vlc_hook_off(){
    f=$( basename "$@" )

    VALIDTIME="^([0-9]+:?)+$"
    REMOVE="q"

    read -p "Enter stoptime (or $REMOVE): " stoptime

    # remove preexisting (if valid time or "$REMOVE"/ENTER)
    [[ ${stoptime,,} =~ $VALIDTIME|^$REMOVE?$ ]] && sed -i "/$f/d" $F_TIMES

    # update if valid (or leave removed)
    [[ ${stoptime} =~ $VALIDTIME ]] && echo -e "$f\t$stoptime" >> $F_TIMES
}


vlc_hook_on(){
    f=$( basename "$@" )

    # pattern match filename & get time
    starttime=$( awk -F'\t' -v f="$f" '$1==f{print $2}' $F_TIMES )
    [[ $starttime ]] || starttime=0 # default to beginning

    # total seconds
    startsecs=$( echo $starttime | awk -F':' '{out=0; for (i=1; i<=NF; i++) out=out + $i * 60^(NF-i) } END {print out}' )

    vlc --start-time $startsecs "$@"
}


touch $F_TIMES
for f in "$@"; do
    vlc_hook_on "$f" && vlc_hook_off "$f"
done

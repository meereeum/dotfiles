#!/bin/bash

DIR=$( dirname "${BASH_SOURCE[0]}" )
[[ -f $DIR/SECRET_darksky ]] && KEY=$( cat $DIR/SECRET_darksky ) \
                             || ( >&2 echo "missing SECRET_darksky" && exit 1 ) # echo to STDERR & leave

EXCLUDE=currently,minutely,hourly,alerts,flags


SUNTIMES=$( curl -s https://api.darksky.net/forecast/$KEY/$LAT,$LON?exclude=$EXCLUDE |
                jq -c '.daily.data[0] | [.sunriseTime, .sunsetTime]' )

[[ $SUNTIMES == "[null,null]" ]] && exit 1

SUNRISE=$( echo $SUNTIMES | jq '.[0]' )
SUNSET=$(  echo $SUNTIMES | jq '.[1]' )

NOW=$( date +%s )

# i=$(( $SUNRISE > $SUNSET )) # next event is sunset vs 'rise
i=$(( $SUNRISE < $NOW )) # next event is sunset vs 'rise

ARROWS=(↗ ↘)
COLORS=(221 168) # 162

# TIMETILLRISE=$(( ($SUNRISE - $( date +%s )) / 60 )) # in mins
# TIMETILLSET=$((  ($SUNSET  - $( date +%s )) / 60 ))

EVENTS=($SUNRISE $SUNSET)
TIMETILLEVENT=$(( (${EVENTS[$i]} - $( date +%s )) ))

# via https://unix.stackexchange.com/questions/27013/displaying-seconds-as-days-hours-mins-seconds
converts() # s -> h(h):mm:ss
{
    local t=$1

    # local d=$((t/60/60/24))
    local h=$((t/60/60%24))
    local m=$((t/60%60))
    local s=$((t%60))

    echo "$h:$( printf "%02d" $m ):$( printf "%02d" $s )"
    # if [[ $d > 0 ]]; then
    #         [[ $d = 1 ]] && echo -n "$d day " || echo -n "$d days "
    # fi
    # if [[ $h > 0 ]]; then
    #         [[ $h = 1 ]] && echo -n "$h hour " || echo -n "$h hours "
    # fi
    # if [[ $m > 0 ]]; then
    #         [[ $m = 1 ]] && echo -n "$m minute " || echo -n "$m minutes "
    # fi
    # if [[ $d = 0 && $h = 0 && $m = 0 ]]; then
    #         [[ $s = 1 ]] && echo -n "$s second" || echo -n "$s seconds"
    # fi  
    # echo
}

fgbg=48 # background; else 38
COLORSTRING="\e[$fgbg;5;%sm  %3s  \e[0m"

printf "$COLORSTRING" ${COLORS[$i]} "☼${ARROWS[$i]} in $( converts $TIMETILLEVENT )"

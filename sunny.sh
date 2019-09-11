#!/bin/bash

KEY=SETME
EXCLUDE=currently,minutely,hourly,alerts,flags

LAT=40.6695668 # @ 961
LON=-73.936074

SUNTIMES=$( curl -s https://api.darksky.net/forecast/$KEY/$LAT,$LON?exclude=$EXCLUDE |
                jq -c '.daily.data[0] | [.sunriseTime, .sunsetTime]' )

SUNRISE=$( echo $SUNTIMES | jq '.[0]' )
SUNSET=$(  echo $SUNTIMES | jq '.[1]' )

i=$(( $SUNRISE > $SUNSET )) # next event is sunrise vs 'set

ARROWS=(↗ ↘)
COLORS=(221 168) # 162

# TIMETILLRISE=$(( ($SUNRISE - $( date +%s )) / 60 )) # in mins
# TIMETILLSET=$((  ($SUNSET  - $( date +%s )) / 60 ))

EVENTS=($SUNRISE $SUNSET)
TIMETILLEVENT=$(( (${EVENTS[$i]} - $( date +%s )) ))

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

#[[ $SUNTIMES != null ]] && echo "☼${ARROWS[$i]} in $( converts $TIMETILLEVENT )"

fgbg=48 # background; else 38
COLORSTRING="\e[$fgbg;5;%sm  %3s  \e[0m"

[[ $SUNTIMES != null ]] && \
    printf "$COLORSTRING" ${COLORS[$i]} "☼${ARROWS[$i]} in $( converts $TIMETILLEVENT )"

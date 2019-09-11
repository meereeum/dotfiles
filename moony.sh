#!/bin/bash

MOONS=(🌑 🌒 🌓 🌔 🌕 🌖 🌗 🌘)

KEY=e183813ad99e49edfd257277c2df9a2c
EXCLUDE=currently,minutely,hourly,alerts,flags

LAT=40.6695668 # @ 961
LON=-73.936074

PHASE=$( curl -s https://api.darksky.net/forecast/$KEY/$LAT,$LON?exclude=$EXCLUDE |
            jq '.daily.data[0].moonPhase' )

INTPHASE=$( bc <<< "$PHASE * 1000" | xargs printf "%0.f" ) # float (0,1) -> int (0,1000)

# cutoffs via https://jshakespeare.com/work/the-moon-tonight
case 1 in
    ( $(( INTPHASE <  125 ))* ) i=0 # new moon
    ;;                                                
    ( $(( INTPHASE <  250 ))* ) i=1 # waxing crescent
    ;;                                                
    ( $(( INTPHASE <  375 ))* ) i=2 # first quarter
    ;;                                                
    ( $(( INTPHASE <  490 ))* ) i=3 # waxing gibbous
    ;;                                                
    ( $(( INTPHASE <  520 ))* ) i=4 # full moon
    ;;                                                
    ( $(( INTPHASE <  750 ))* ) i=5 # waning gibbous
    ;;                                                
    ( $(( INTPHASE <  875 ))* ) i=6 # last quarter
    ;;                                               
    ( $(( INTPHASE < 1000 ))* ) i=7 # waning crescent
    ;;
esac

[[ $PHASE != null ]] && echo ${MOONS[$i]} # else, request failed

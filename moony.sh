#!/bin/bash

MOONS=(🌑 🌒 🌓 🌔 🌕 🌖 🌗 🌘)

# PHASE=$( cat /tmp/darksky | jq '.daily.data[0].moonPhase' )
PHASE=$( cat /tmp/darksky | jq '.location.values[0].moonphase' )

( [[ ! $PHASE ]] || [[ $PHASE == null ]] ) && exit 1

INTPHASE=$( bc <<< "$PHASE * 1000" | xargs printf "%0.f" ) # float (0,1) -> int (0,1000)

# cutoffs via https://jshakespeare.com/work/the-moon-tonight
# case via https://unix.stackexchange.com/questions/65310/case-how-to-implement-equal-or-less-or-greater-in-case-syntax/239462#239462
case 1 in
    $(( INTPHASE <  125 )) ) i=0 # new moon
    ;;
    $(( INTPHASE <  250 )) ) i=1 # waxing crescent
    ;;
    $(( INTPHASE <  375 )) ) i=2 # first quarter
    ;;
    $(( INTPHASE <  490 )) ) i=3 # waxing gibbous
    ;;
    $(( INTPHASE <  520 )) ) i=4 # full moon
    ;;
    $(( INTPHASE <  750 )) ) i=5 # waning gibbous
    ;;
    $(( INTPHASE <  875 )) ) i=6 # last quarter
    ;;
    $(( INTPHASE < 1000 )) ) i=7 # waning crescent
    ;;
esac

echo ${MOONS[$i]}

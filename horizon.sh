#!/bin/bash

DIR=$( dirname "${BASH_SOURCE[0]}" )
[[ -f $DIR/SECRET_darksky ]] && KEY=$( cat $DIR/SECRET_darksky ) \
                             || ( >&2 echo "missing SECRET_darksky" && exit 1 ) # echo to STDERR & leave

# EXCLUDE=currently,minutely,hourly,alerts,flags

# LATLON=42.3566978,-71.1072584 # @ 589
# LATLON=40.6695668,-73.936074  # @ 961
[[ -f /tmp/latlon && $( cat /tmp/latlon ) ]] || bash $DIR/geolocate.sh
LATLON=$( cat /tmp/latlon )

# need to rerun ?
[[ -f /tmp/darksky ]] && {
    SUNTIMES=$( cat /tmp/darksky |
                # jq -c '.daily.data[0] | [.sunriseTime, .sunsetTime]' )
                jq -c '.location.values[0] | [.sunrise,.sunset]' )

    SUNRISE=$( echo $SUNTIMES | jq '.[0]' | xargs date +%s -d )
    SUNSET=$(  echo $SUNTIMES | jq '.[1]' | xargs date +%s -d )
    NOW=$( date +%s )

    if [[ ! $SUNTIMES ]] || [[ $SUNTIMES == "[null,null]" ]]; then
        RERUN=1
    elif (( $NOW < $SUNRISE)) || (( $NOW < $SUNSET )); then
        RERUN=0 # don't rerun *only* if sun{rise,set} still in future
    else
        RERUN=1
    fi
} || RERUN=1

# (( $RERUN )) && curl -s https://api.darksky.net/forecast/$KEY/$LATLON?exclude=$EXCLUDE \
(( $RERUN )) && curl -s "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/weatherdata/forecast?aggregateHours=24&includeAstronomy=true&forecastDays=1&contentType=json&combinationMethod=aggregate&unitGroup=us&locationMode=single&key=$KEY&locations=$LATLON" \
                    > /tmp/darksky

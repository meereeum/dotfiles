#!/bin/sh

FPREFIX=~/movls
TODAY=$( date +%y%m%d )
FTODAY=${FPREFIX}_${TODAY}

[[ -f $FTODAY ]] || {
    rm ${FPREFIX}_* &> /dev/null

    NOW=$( date +%s )
    FARAWAY=9999999999

    URL="https://www.americancinematheque.com/wp-json/wp/v2/algolia_get_events?environment=production&startDate=${NOW}&endDate=${FARAWAY}"

    curl -s "$URL" --user-agent 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.1 Mobile/15E148 Safari/604.1' > $FTODAY
}

echo
cat $FTODAY | jq -c '.hits[] |
    select(.post_type=="event") |
    select( (.event_format | index(74)) or
	    (.event_format | index(79)) ) |
    [.event_start_date,.event_start_time,.title,.event_location]' |
    # [.event_start_date,.event_start_time,.title,.event_format,.event_location]' |
    sed 's/:00"/"/' |
    sed -e's/\b74\b/35mm/g' -e's/\b79\b/70mm/g' |
    sed -e's/\[102\]/LF3/' -e's/\[54\]/AERO/' -e's/\[55\]/EGYPTIAN/' |
    sed -e's/"//1' -e's/"//1' -e's/"//1' -e's/"//1' |
    sort
echo

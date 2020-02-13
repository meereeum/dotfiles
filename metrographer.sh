#!/bin/bash

DIR=$( dirname "${BASH_SOURCE[0]}" )

for film in $( cat $DIR/films | grep -v '^#' ); do
    # really, number of days showing
    showtimes=$( wget -qO- $film | grep "film/times" | wc -l )

    stars=$( yes ★ | head -n$showtimes | tr -d '\n')
    (( $showtimes > 0 )) && echo "$stars $film"
done

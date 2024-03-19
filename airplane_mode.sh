#!/bin/bash

OPS=(on off)

[ $( nmcli radio wifi ) == "enabled" ] && i=0 || i=1
from=${OPS[$i]}
to=${OPS[1 - $i]} # flip

nmcli radio wifi $to
# echo "${from^^} ↪ ${to^^}"

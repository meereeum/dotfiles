#!/bin/bash

# get the gdbus output
output=$( gdbus call --session --dest org.gnome.Shell.Screenshot --object-path /org/gnome/Shell/Screenshot --method org.gnome.Shell.Screenshot.PickColor )
colors=( $(echo $output | command grep -o "[0-9\.]*") )

# convert to 255-based RGB format
for ((i = 0; i < ${#colors[@]}; i++)); do
colors[$i]=$( printf '%.0f' $(echo "${colors[$i]} * 255" | bc) )
done

echo    "RGB: ${colors[0]} ${colors[1]} ${colors[2]}"
# printf "HEX: #%02x%02x%02x\n" "${colors[0]}" "${colors[1]}" "${colors[2]}"
HEX=$( printf "#%02x%02x%02x" "${colors[0]}" "${colors[1]}" "${colors[2]}" )
# echo -n "HEX: " && echo -n $HEX | cpout # hex -> clipboard
echo -n "HEX: " && echo -n $HEX | xsel -i --clipboard # --display :0
echo

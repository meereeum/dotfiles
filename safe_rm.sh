#!/bin/bash
set -u # don't delete my hd plz

# ensure trash exists
[ -d "$TRASHDIR" ] || mkdir -p "$TRASHDIR"

for file in "$@"; do
    if [ -e "$file" ]; then

        # Target exists and can be moved to Trash safely
        if [ ! -e "$TRASHDIR/$file" ]; then
            mv "$file" "$TRASHDIR"

        # Target exists and conflicts with target in Trash
        elif [ -e "$TRASHDIR/$file" ]; then

            # Increment target name until
            # there is no longer a conflict
            i=1
            while [ -e "$TRASHDIR/$file.$i" ]; do
                i=$(($i + 1))
            done

            # Move to the Trash with non-conflicting name
            mv "$file" "$TRASHDIR/$file.$i"
        fi

    # Target doesn't exist, return error
    else
        # ..but ignore options to `rm`
        [[ "$file" != "-r" ]] && \
            echo "rm: $file: No such file or directory";
    fi
done

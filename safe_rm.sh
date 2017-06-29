#!/bin/sh

if (($linux)); then

    TRASHDIR="${HOME}/.local/share/Trash/files"

    if [ ! -e ${TRASHDIR} ]; then
        touch foo
        trash foo
    fi

else

    TRASHDIR="${HOME}/.Trash"

fi



for file in "$@"; do
    if [ -e "${file}" ]; then

        # Target exists and can be moved to Trash safely
        if [ ! -e "${TRASHDIR}/${file}" ]; then
            mv "${file}" ${TRASHDIR}

            # Target exists and conflicts with target in Trash
        elif [ -e "${TRASHDIR}/${file}" ]; then

            # Increment target name until
            # there is no longer a conflict
            i=1
            while [ -e "${TRASHDIR}/${file}.${i}" ];
            do
                i=$(($i + 1))
            done

            # Move to the Trash with non-conflicting name
            mv "${file}" "${TRASHDIR}/${file}.${i}"
        fi

        # Target doesn't exist, return error
    else
        if [[ "${file}" != "-r" ]]; then # ignore options to `rm`
            echo "rm: ${file}: No such file or directory";
        fi
    fi
done

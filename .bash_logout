# ~/.bash_logout: executed by bash(1) when login shell exits.

# when leaving the console clear the screen to increase privacy

if [ "$SHLVL" = 1 ]; then
    # clear screen
    [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
    # unmount Media partition
    [ -x /usr/bin/sudo umount /Volumes/Media ] && /usr/bin/sudo umount /Volumes/Media
fi

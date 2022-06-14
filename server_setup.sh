#!/bin/bash
set -u # don't delete my hd plz


./_setup.sh


# minimal pkgs
while read line
        do sudo apt-get install -y ${line}
done < packages/packages_server.txt


# comment out lines
sed -ri'.tmp' --follow-symlinks 's/^(.*pandoc)/#\1/' ~/.bash_profile
sed -ri'.tmp' --follow-symlinks 's/^(.*safe_rm)/#\1/' ~/.bash_profile


# edit for remote prompt
#sed -ri'.tmp' --follow-symlinks 's/^(export PS1=).*$/\1"\\e[1m\\h:\\e[21m \\W \\$ "/' ~/.bash_profile
# for server (?):
sed -ri'.tmp' --follow-symlinks 's/^(export PS1=).*$/\1"\\e[1m\\h:\\e[m \\W \\$ "/' ~/.bash_profile
# for cluster (?):
# sed -ri'.tmp' --follow-symlinks 's/^(export PS1=).*$/\\1"\\e[1m\\h:\\e[21m \\W \\$ "/' ~/.bash_profile


# does not exist or remove
[ ! -e ~/.bash_profile.tmp ] || rm ~/.bash_profile.tmp

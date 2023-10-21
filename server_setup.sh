#!/bin/bash
set -u # don't delete my hd plz


# minimal pkgs
while read line
    do sudo apt-get install -y ${line}
done < pkgs/aptpkgs_server.txt


./_setup.sh


# comment out lines
sed -ri'.tmp' --follow-symlinks 's/^(.*pandoc)/#\1/' ~/.bash_profile
sed -ri'.tmp' --follow-symlinks 's/^(.*safe_rm)/#\1/' ~/.bash_profile


# edit for remote prompt
#sed -ri'.tmp' --follow-symlinks 's/^(export PS1=).*$/\1"\\e[1m\\h:\\e[21m \\W \\$ "/' ~/.bash_profile
# for server (?):
sed -ri'.tmp' --follow-symlinks 's/^(export PS1=).*$/\1"\\e[1m\\h:\\e[m \\W \\$ "/' ~/.bash_profile
# for cluster (?):
# sed -ri'.tmp' --follow-symlinks 's/^(export PS1=).*$/\\1"\\e[1m\\h:\\e[21m \\W \\$ "/' ~/.bash_profile


sudo cp ./motd /etc


# does not exist or remove
[ ! -e ~/.bash_profile.tmp ] || rm ~/.bash_profile.tmp

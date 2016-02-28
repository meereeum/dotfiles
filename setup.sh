#!/usr/bin/bash

# simlink
for f in bash_profile gitconfig spacemacs vimrc screenrc
	do rm ~/.${f}
	ln -s ~/dotfiles/.${f} ~/.${f}
done


instructions="
TODO:
$ su

(1) install sudo
$ apt-get install -y sudo
$ visudo
add miriam to #User privilege specification

(2) install b43-firmware for wifi
$ vi /etc/apt/sources.list
append 'non-free' to every deb line
( don't forget to remove l8r )

$ exit

$ bash finish_setup.sh
"


if (($linux)); then
	echo "source ~/.bash_profile" >> ~/.bashrc
	echo "$instructions"
fi

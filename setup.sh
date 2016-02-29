#!/usr/bin/bash

# simlink
for f in bash_profile gitconfig spacemacs vimrc screenrc
	do rm ~/.${f}
	ln -s ~/dotfiles/.${f} ~/.${f}
done

# ye olde spacemacs
git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d


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
$ apt-get update

$ exit

$ bash finish_setup.sh
"


if (($linux)); then
	echo "source ~/.bash_profile" >> ~/.bashrc

	# anaconda
	wget https://3230d63b5fc54e62148e-c95ac804525aac4b6dba79b00b39d1d3.ssl.cf1.rackcdn.com/Anaconda2-2.5.0-Linux-x86_64.sh
	bash Anaconda2-2.5.0-Linux-x86_64.sh
	rm Anaconda2-2.5.0-Linux-x86_64.sh

	echo "$instructions"
fi

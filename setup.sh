#!/usr/bin/bash

# simlink
dotfiles=$( ls -a | grep "^\." | egrep -ve "^\.{1,2}$" -e"^\.git(ignore)?$" )
for f in $dotfiles
	do rm ~/${f}
	ln -s ~/dotfiles/${f} ~/${f}
done

echo "source ~/.bash_profile" >> ~/.bashrc
source ~/.bash_profile

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
append 'non-free contrib' to every deb line
( don't forget to remove l8r )
$ apt-get update

$ exit

$ bash finish_setup.sh
"

if (($linux)); then
	sudo mkdir /Volumes
	sudo mkdir /Volumes/Media

	# anaconda
	wget https://3230d63b5fc54e62148e-c95ac804525aac4b6dba79b00b39d1d3.ssl.cf1.rackcdn.com/Anaconda2-2.5.0-Linux-x86_64.sh
	bash Anaconda2-2.5.0-Linux-x86_64.sh
	rm Anaconda2-2.5.0-Linux-x86_64.sh

	echo "$instructions"
fi

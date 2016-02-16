#!/usr/bin/bash

for f in bash_profile gitconfig spacemacs vimrc screenrc
	do rm ~/.${f}
	ln -s ~/dotfiles/.${f} ~/.${f}
done


# also install apt-get packages if on linux os
if (($linux)); then
	cat packages.txt | xargs sudo apt-get install
fi

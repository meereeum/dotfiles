#!/usr/bin/bash

for f in bash_profile gitconfig spacemacs vimrc
	do rm ~/.${f}
	ln -s ~/dotfiles/.${f} ~/.${f}
done

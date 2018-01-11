#!/bin/bash

if (($linux)); then

	# install apt-get packages/packages
	while read line
		do sudo apt-get install -y ${line}
		#do sudo apt-get install ${line}
	done < packages/packages.txt

	# update uq vpn profile
	cp template_uq.conf uq.conf
	vi uq.conf
	sudo mv uq.conf /etc/vpnc

	# https://github.com/rg3/youtube-dl
	sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
	sudo chmod a+rx /usr/local/bin/youtube-dl

else

	# install brew packages
	brew tap railwaycat/emacsmacport # for emacs-mac

	while read line
		do brew install ${line}
	done < packages/packages_brew.txt

	brew linkapps emacs-mac

fi

mkdir ~/.vim/.{backup,swp,undo}

#!/bin/bash
set -u # don't delete my hd plz

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
        # spacemacs
        # the debate: https://github.com/d12frosted/homebrew-emacs-plus/issues/10
	brew tap railwaycat/emacsmacport # for emacs-mac
        brew install emacs-mac --with-gnutls --with-imagemagick --with-modules --with-texinfo --with-xml2 --with-spacemacs-icon
	brew linkapps emacs-mac

        #brew tap d12frosted/emacs-plus
        #brew install emacs-plus --with-no-title-bars
        #brew linkapps emacs-plus

	while read line
		do brew install ${line}
	done < packages/packages_brew.txt

fi

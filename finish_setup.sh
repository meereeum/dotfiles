#!/usr/bin/bash

if (($linux)); then

	# install apt-get packages
	while read line
		do sudo apt-get install -y ${line}
		#do sudo apt-get install ${line}
	done < packages.txt

	# update uq vpn profile
	cp template_uq.conf uq.conf
	vi uq.conf
	sudo mv uq.conf /etc/vpnc
fi

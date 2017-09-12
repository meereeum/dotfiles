#!/bin/bash

# simlink

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

DOTFILES=$( cd $DIR; ls -a | grep "^\." | egrep -ve "^\.{1,2}$" -e"^\.git(ignore)?$" -ve".*swp")

for f in $DOTFILES
	do if [ -f ~/${f} ]; then # clobber
		rm ~/${f}
	fi
	ln -s ${DIR}/${f} ~/${f} && \
		echo "~/${f} --> ${DIR}/${f}"
done

echo "source ~/.bash_profile" >> ~/.bashrc
source $HOME/.bash_profile


# conda

CONDA="https://repo.continuum.io/archive/Anaconda2-4.3.1-Linux-x86_64.sh" 

wget $CONDA -O ~/conda.sh && \
	bash ~/conda.sh -b && \ # silent install
	{
		rm ~/conda.sh

		export PATH="${HOME}/anaconda2/bin:$PATH"
		export PYTHONPATH="${HOME}/anaconda2/bin/python"

		yes | conda create -n py36 python=3.6 anaconda
	}


# minimal pkgs

while read line
        do sudo apt-get install -y ${line}
        #do sudo apt-get install ${line}
done < packages/packages_server.txt


# comment out lines

sed -ri'.tmp' --follow-symlinks 's/^(.*pandoc)/#\1/' ${HOME}/.bash_profile
sed -ri'.tmp' --follow-symlinks 's/^(.*safe_rm)/#\1/' ${HOME}/.bash_profile

if [ -e ${HOME}/.bash_profile.tmp ]; then
	rm ${HOME}/.bash_profile.tmp
fi

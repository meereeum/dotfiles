#!/bin/bash

# symlink
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOTFILES=$( cd $DIR; ls -a | grep "^\." | egrep -ve "^\.{1,2}$" -e"^\.git(ignore)?$" -ve".*swp")

for f in $DOTFILES
        do rm ~/${f}
        ln -s ${DIR}/${f} ~/${f}
        echo "~/${f} --> ${DIR}/${f}"
done

echo "source ~/.bash_profile" >> ~/.bashrc
source ~/.bash_profile


# ye olde spacemacs
git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d


OS=${OSTYPE//[0-9.]/}
if [[ $OS == "darwin" ]]; then
        SYS="MacOSX"
else
        SYS="Linux"
fi


# homebrew
if [[ $SYS == "MacOSX" ]]; then
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" && \
	brew install wget
fi


# anaconda
CONDA="https://repo.continuum.io/archive/Anaconda2-4.3.1-${SYS}-x86_64.sh"

wget $CONDA -O ~/conda.sh && \
	bash ~/conda.sh -b && \ # silent install
                {
                        rm ~/conda.sh
                        yes | conda create -n py36 python=3.6 anaconda
                }

# vim for jupyter
mkdir -p $(jupyter --data-dir)/nbextensions
cd $(jupyter --data-dir)/nbextensions
git clone https://github.com/lambdalisue/jupyter-vim-binding vim_binding

CUSTOM="~/.jupyter/custom"
mkdir -p $CUSTOM
for f in jupyter/*; do
  ln -s ${DIR}/${f} ${CUSTOM}
  echo "${CUSTOM}/${f} --> ${DIR}/${f}"
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
append 'non-free contrib' to every deb line
( don't forget to remove l8r )
$ apt-get update

(3) fix connectivity ?!
(via http://brontosaurusrex.github.io/postbang/#!index.md)
$ vi /etc/NetworkManager/NetworkManager.conf
change "managed = true"
$ service network-manager restart

$ exit

$ bash finish_setup.sh
"

if (($linux)); then
	sudo mkdir /Volumes
	sudo mkdir /Volumes/Media

	echo "$instructions"
fi

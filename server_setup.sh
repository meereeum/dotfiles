#!/bin/bash
set -u # don't delete my hd plz

# simlink

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

DOTFILES=$( cd $DIR; ls -a | grep "^\." | egrep -ve "^\.{1,2}$" -e"^\.git(ignore)?$" -ve".*swp")

for f in $DOTFILES; do
        [ ! -f ~/${f} ] || rm ~/${f} # clobber

	ln -s ${DIR}/${f} ~/${f} && \
		echo "~/${f} --> ${DIR}/${f}"
done

echo "source ~/.bash_profile" >> ~/.bashrc
source ~/.bash_profile

# infinite HIST
sed -ri'.tmp' --follow-symlinks 's/^(HIST.*SIZE)/# \1/' ~/.bashrc

# vim dir
mkdir -p ~/.vim/{.swp,.backup,.undo}


# conda

CONDA="https://repo.continuum.io/archive/Anaconda3-5.2.0-Linux-x86_64.sh"
#CONDA="https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh"

# silent install
wget $CONDA -O ~/conda.sh && \
	bash ~/conda.sh -b && \
	{
		rm ~/conda.sh

		#export PATH="${HOME}/anaconda2/bin:${PATH}"
		#export PYTHONPATH="${HOME}/anaconda2/bin/python"

		#yes | conda create -n py36 python=3.6 anaconda

        # cleanup
        yes | conda clean --all
	}


# minimal pkgs

while read line
        do sudo apt-get install -y ${line}
        #do sudo apt-get install ${line}
done < packages/packages_server.txt


# comment out lines

sed -ri'.tmp' --follow-symlinks 's/^(.*pandoc)/#\1/' ~/.bash_profile
sed -ri'.tmp' --follow-symlinks 's/^(.*safe_rm)/#\1/' ~/.bash_profile


# edit for remote prompt

sed -ri'.tmp' --follow-symlinks 's/^(export PS1=).*$/\\1"\\e[1m\\h:\\e[21m \\W \\$ "/' ~/.bash_profile


# does not exist or remove
[ ! -e ~/.bash_profile.tmp ] || rm ~/.bash_profile.tmp

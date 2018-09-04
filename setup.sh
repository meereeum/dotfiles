#!/bin/bash
set -u # don't delete my hd plz

# symlink
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOTFILES=$( cd $DIR; ls -a | grep "^\." | egrep -ve "^\.{1,2}$" -e"^\.git(ignore)?$" -ve".*swp")

for f in $DOTFILES; do
        [ ! -f ~/${f} ] || rm ~/${f}
        ln -s ${DIR}/${f} ~/${f}
        echo "~/${f} --> ${DIR}/${f}"
done

echo "source ~/.bash_profile" >> ~/.bashrc
source ~/.bash_profile

# infinite HIST
sed -ri'.tmp' --follow-symlinks 's/^(HIST.*SIZE)/# \1/' ~/.bashrc

# vim dir
mkdir -p ~/.vim/{.swp,.backup,.undo}

# vim postfx highlight
OUTIDIR="$HOME/.vim/after/syntax/sh"
mkdir -p $OUTDIR
cat /usr/share/vim/vim*/doc/syntax.txt | # grab script from docs
    awk '/AWK Embedding/,/^<$/' |
    grep -v '^<$' > ${OUTDIR}/awkembed.vim

# ye olde spacemacs
[ -d ~/.emacs.d ] || git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d


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
CONDA="https://repo.continuum.io/archive/Anaconda3-5.2.0-${SYS}-x86_64.sh"

# silent install
wget $CONDA -O ~/conda.sh && \
	bash ~/conda.sh -b && \
                {
                    rm ~/conda.sh
                    #yes | conda create -n py36 python=3.6 anaconda
                    #yes | conda env create -f ${DIR}/packages/conda_py36.yml
                    # cleanup
                    yes | conda clean --all
                }


# vim for jupyter

#./install/vimjupyter.sh "$DIR"

mkdir -p $(jupyter --data-dir)/nbextensions
cd $(jupyter --data-dir)/nbextensions
[ -d vim_binding ] || git clone https://github.com/lambdalisue/jupyter-vim-binding vim_binding
jupyter nbextension enable vim_binding/vim_binding
cd $DIR # back to dotfiles

CUSTOM="${HOME}/.jupyter/custom"
mkdir -p $CUSTOM
for f in jupyter/*; do
  fname=$( basename "${f}" )
  [ ! -f ${CUSTOM}/${fname} ] || rm ${CUSTOM}/${fname}
  #[ ! -f ${CUSTOM}/${f#jupyter/} ] || rm ${CUSTOM}/${f#jupyter/}
  ln -s ${DIR}/${f} ${CUSTOM}
  echo "${CUSTOM}/${f} --> ${DIR}/${f}"
done


# vim-anywhere
cd $HOME
git clone https://github.com/meereeum/vim-anywhere.git
./install
cd $DIR # back to dotfiles


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
change 'managed = true'
$ service network-manager restart

$ exit

$ bash finish_setup.sh
"

if (($linux)); then
	#sudo mkdir /Volumes
	#sudo mkdir /Volumes/Media

	echo "$instructions"
fi

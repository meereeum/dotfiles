#!/bin/bash
set -u # don't delete my hd plz

# symlink
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOTFILES=$( cd $DIR; ls -a | grep "^\." | egrep -ve "^\.{1,2}$" -e"^\.git(ignore)?$" -ve".*swp")

(( ! $linux )) && sed -ri'.tmp' --follow-symlinks 's/\bstore$/osxkeychain/' $DIR/.gitconfig # credential helper

for f in $DOTFILES; do
        [ ! -f ~/${f} ] || rm ~/${f}
        ln -s ${DIR}/${f} ~/${f}
        echo "~/${f} --> ${DIR}/${f}"
done

echo "source ~/.bash_profile" >> ~/.bashrc
source ~/.bash_profile

# infinite HIST
(( $linux )) && sed -ri'.tmp' --follow-symlinks 's/^(HIST.*SIZE)/# \1/' ~/.bashrc

# permanently store git pw on osx
sed -ri'.tmp' --follow-symlinks 's/helper ?= ?store/helper=osxkeychain/' ~/.gitconfig

# vim dir
mkdir -p ~/.vim/{.swp,.backup,.undo,colors}
for COLOR in "$DIR/colors/*"; do
    ln -s $COLOR ~/.vim/colors
done

# vim postfx highlight
OUTDIR="$HOME/.vim/after/syntax/sh"
mkdir -p $OUTDIR
cat /usr/share/vim/vim*/doc/syntax.txt | # grab script from docs
    awk '/AWK Embedding/,/^<$/' |
    grep -v '^<$' > ${OUTDIR}/awkembed.vim

# vim syntax highlighting fix
# via https://github.com/vim/vim/issues/1008
wget http://www.drchip.org/astronaut/vim/syntax/sh.vim.gz && \
    {
        gunzip sh.vim.gz
        [[ -d ~/.vim/syntax ]] || mkdir ~/.vim/syntax
        mv sh.vim ~/.vim/syntax
    }

# ye olde spacemacs
[ -d ~/.emacs.d ] || git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
# wget https://github.com/nashamri/spacemacs-logo/raw/master/spacemacs.icns


# determine os
[[ ${OSTYPE//[0-9.]/} == "darwin" ]] && SYS="MacOSX" || SYS="Linux"

# osx stuff
if [[ $SYS == "MacOSX" ]]; then
    # homebrew
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" && \
    brew install wget

    # command line tools
    # xcode-select --install

    # yubikey manager
    YUBICO="https://developers.yubico.com/yubikey-manager-qt/Releases/yubikey-manager-qt-latest-mac.pkg"
    wget $YUBICO
fi


# anaconda
#CONDA="https://repo.continuum.io/archive/Anaconda3-2019.07-${SYS}-x86_64.sh"
CONDA="https://repo.anaconda.com/miniconda/Miniconda3-latest-${SYS}-x86_64.sh"

# silent install
wget $CONDA -O ~/conda.sh && \
    bash ~/conda.sh -b && \
                {
                    rm ~/conda.sh

                    # if need separate py2 & py3 envs:
                    # yes | conda create -n py37 python=3.7 anaconda
                    # yes | conda env create -f ${DIR}/packages/conda_py36.yml

                    # cleanup
                    yes | conda clean --all
                }

# jupyter defaults
echo -e "import numpy as np\nimport itertools\nimport re" >> $HOME/.ipython/profile_default/startup/00.py

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
cd vim-anywhere
./install
cd $DIR # back to dotfiles


# gists
# arxivate
wget https://gist.github.com/meereeum/d14cfd9c17e8abda5d0a09eed477bd27/raw/00b7851cb2bfc80d34431c2ee2ca249586e5f920/arxivate.sh
# h5tree
wget https://gist.github.com/meereeum/87e267dc80421aea50cbb1ce63be5612/raw/afa2bb7c498927455622807fd59b7744330073e0/h5tree.sh
# nbmerge
wget https://gist.githubusercontent.com/fperez/e2bbc0a208e82e450f69/raw/8e4fe4536a3e9bd739036fc733020fa3ed8f61c9/nbmerge.py


# gecko driver
[[ $SYS == "Linux" ]] && osname="linux64" || osname="macos"
gecko_url=$( curl -s https://api.github.com/repos/mozilla/geckodriver/releases/latest |
             jq -r '.assets[].browser_download_url | select(contains("'$osname'"))' )

curl -s -L "$gecko_url" | tar -xz && \
    chmod +x geckodriver && sudo mv geckodriver /usr/local/bin


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

[ also: sudo apt-get install msttcorefonts -qq ]

(3) fix connectivity ?!
(via http://brontosaurusrex.github.io/postbang/#!index.md)
$ vi /etc/NetworkManager/NetworkManager.conf
change 'managed = true'
$ service network-manager restart

(4) edit /etc/anacrontab
add line: "1    1   geolocate   bash $DIR/geolocate.sh"

$ exit

$ bash finish_setup.sh
"

instructions_mac="
don't forget about `http://osxdaily.com/2018/10/09/fix-operation-not-permitted-terminal-error-macos`
"

if (($linux)); then
    #sudo mkdir /Volumes
    #sudo mkdir /Volumes/Media

    echo "$instructions"
else
    echo "$instructions_mac"
fi

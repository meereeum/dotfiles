#!/bin/bash
set -u # don't delete my hd plz

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# symlink
DOTFILES=$( cd $DIR; ls -a | grep "^\." | egrep -ve "^\.{1,2}$" -e"^\.git(ignore)?$" -ve".*swp")

for f in $DOTFILES; do
    [ ! -f ~/${f} ] || rm ~/${f} # clobber

    ln -s ${DIR}/${f} ~/${f} && \
        echo "~/${f} --> ${DIR}/${f}"
done

BASHRC=$( ls ~/.*bashrc )
echo "source ~/.bash_profile" >> $BASHRC
source ~/.bash_profile

# infinite HIST
(( $linux )) && sed -ri'.tmp' --follow-symlinks 's/^(HIST.*SIZE)/# \1/' $BASHRC


# unified vim setup
VIMDIR="$HOME/.vim"
find vim -mindepth 1 -type d | sed "s@^vim*@$VIMDIR@" | xargs mkdir -p
for f in $( find vim -mindepth 1 -type f ); do
    LINK_TO=$( echo $f | sed -e "s@^[^/]*@$VIMDIR@" ) # -e 's@/[^/]*$@@')
    ln -s "$DIR/$f" "$LINK_TO"
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
        mkdir -p ~/.vim/syntax
        mv sh.vim ~/.vim/syntax
    }

# for mac, may need to replace colors in $VIMRUNTIME/syntax/syncolor.vim
# e.g. SlateBlue -> #6a5acd
#      Orange -> #ffa500
!(( $linux )) && sed -ri'.tmp' -e's/=SlateBlue/=#6a5acd/g' \
                               -e's/=Orange/=#ffa500/g' "${VIMRUNTIME}/syntax/syncolor.vim"


# anaconda

# via https://stackoverflow.com/a/54839819
CONDA="$( wget -O - https://www.anaconda.com/distribution/ 2>/dev/null |
          grep "64-Bit (x86) Installer" | sed -nE 's/.*href="([^"]*)".*/\1/p' )"
# CONDA="https://repo.anaconda.com/archive/Anaconda3-2021.11-Linux-x86_64.sh"
# CONDA="https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh"

# silent install
wget $CONDA -O ~/conda.sh && \
    bash ~/conda.sh -b && \
    {
        # cleanup
        rm ~/conda.sh
        yes | conda clean --all

        # update
        conda update -n base -c defaults conda
        pip install --upgrade pip

        # ensure bash commands working
        conda init bash
        source ~/anaconda3/etc/profile.d/conda.sh
    }


echo "backend : agg" >> $HOME/.config/matplotlib/matplotlibrc

# jupyter defaults
cat ${DIR}/00.py >> $HOME/.ipython/profile_default/startup/00.py


# gists
# arxivate
[[ -f ${DIR}/arxivate.sh ]] || wget 'https://gist.github.com/meereeum/d14cfd9c17e8abda5d0a09eed477bd27/raw/00b7851cb2bfc80d34431c2ee2ca249586e5f920/arxivate.sh'
# h5tree
[[ -f ${DIR}/h5tree.sh ]] || wget 'https://gist.github.com/meereeum/87e267dc80421aea50cbb1ce63be5612/raw/afa2bb7c498927455622807fd59b7744330073e0/h5tree.sh'

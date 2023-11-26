#!/bin/bash
set -u # don't delete my hd plz
# set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

symlink() {
    FROM=$1
    TO=$2

    [ ! -f "$TO" ] || rm "$TO" # clobber preëxisting
    ln -s "$FROM" "$TO"
}

# symlink
DOTFILES=$( cd $DIR; ls -a | grep "^\." | egrep -ve "^\.{1,2}$" -e"^\.git(ignore)?$" -ve".*swp" -ve"DS_Store")

for f in $DOTFILES; do
    symlink ${DIR}/${f} ~/${f} && \
        echo "~/${f} --> ${DIR}/${f}"
done

BASHRC=$( ls ~/.*bashrc )
echo "source ~/.bash_profile" >> $BASHRC
source ~/.bash_profile

mkdir -p ~/.config/zathura
symlink ${DIR}/zathurarc ~/.config/zathura/zathurarc

# infinite HIST
(( $linux )) && sed -ri'.tmp' --follow-symlinks 's/^(HIST.*SIZE)/# \1/' $BASHRC


# unified vim setup
VIMDIR="$HOME/.vim"
find vim -mindepth 1 -type d | sed "s@^vim*@$VIMDIR@" | xargs mkdir -p
for f in $( find vim -mindepth 1 -type f ); do
    LINK_TO=$( echo $f | sed -e "s@^[^/]*@$VIMDIR@" ) # -e 's@/[^/]*$@@')
    symlink "$DIR/$f" "$LINK_TO"
done

# vim postfx highlight
OUTDIR="$HOME/.vim/after/syntax/sh"
mkdir -p $OUTDIR
cat /usr/share/vim/vim*/doc/syntax.txt | # grab script from docs
    awk '/AWK Embedding/,/^<$/' |
    grep -v '^<$' > ${OUTDIR}/awkembed.vim

# vim syntax highlighting fix
# via https://github.com/vim/vim/issues/1008
# [ -f ~/.vim/syntax/sh.vim ] || {
#     wget http://www.drchip.org/astronaut/vim/syntax/sh.vim.gz && \
#         {
#             gunzip sh.vim.gz
#             mkdir -p ~/.vim/syntax
#             mv sh.vim ~/.vim/syntax
#             rm sh.vim.gz
#         }
# }
# hopefully this is incorporated into vim now, b/c the file no longer exists..

# for mac, may need to replace colors in $VIMRUNTIME/syntax/syncolor.vim
# e.g. SlateBlue -> #6a5acd
#      Orange -> #ffa500
!(( $linux )) && sed -ri'.tmp' -e's/=SlateBlue/=#6a5acd/g' \
                               -e's/=Orange/=#ffa500/g' "${VIMRUNTIME}/syntax/syncolor.vim"


# anaconda

# via https://stackoverflow.com/a/54839819
# CONDA="$( wget -O - https://www.anaconda.com/distribution/ 2>/dev/null |
#           grep "64-Bit (x86) Installer" | sed -nE 's/.*href="([^"]*)".*/\1/p' )"
# CONDA="https://repo.anaconda.com/archive/Anaconda3-2021.11-Linux-x86_64.sh"
# CONDA="https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh"

# silent install
# command -v conda &> /dev/null || { # iff conda does not yet exist
#     wget $CONDA -O ~/conda.sh && \
#         bash ~/conda.sh -b && \
#         {
#             # cleanup
#             rm ~/conda.sh
#             yes | conda clean --all
#
#             # update
#             conda update -n base -c defaults conda
#             pip install --upgrade pip
#
#             # ensure bash commands working
#             conda init bash
#             source ~/anaconda3/etc/profile.d/conda.sh
#         }
# }


mkdir -p $HOME/.config/matplotlib
echo "backend : agg" >> $HOME/.config/matplotlib/matplotlibrc

# jupyter defaults
mkdir -p $HOME/.ipython/profile_default/startup
symlink ${DIR}/00.py ~/.ipython/profile_default/startup/00.py


# gists
# arxivate
[[ -f ${DIR}/arxivate.sh ]] || wget 'https://gist.github.com/meereeum/d14cfd9c17e8abda5d0a09eed477bd27/raw/00b7851cb2bfc80d34431c2ee2ca249586e5f920/arxivate.sh'
chmod +x arxivate.sh
# h5tree
[[ -f ${DIR}/h5tree.sh ]] || wget 'https://gist.github.com/meereeum/87e267dc80421aea50cbb1ce63be5612/raw/afa2bb7c498927455622807fd59b7744330073e0/h5tree.sh'
chmod +x h5tree.sh
# nbmerge
[[ -f ${DIR}/nbmerge.py ]] || wget 'https://gist.githubusercontent.com/fperez/e2bbc0a208e82e450f69/raw/8e4fe4536a3e9bd739036fc733020fa3ed8f61c9/nbmerge.py'
chmod +x nbmerge.py

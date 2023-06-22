#!/bin/bash
set -u # don't delete my hd plz

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


./_setup.sh


# ye olde spacemacs
# [ -d ~/.emacs.d ] || git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
# wget https://github.com/nashamri/spacemacs-logo/raw/master/spacemacs.icns


# vim for jupyter
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
[ -d $HOME/vim-anywhere ] || {
    cd $HOME
    git clone https://github.com/meereeum/vim-anywhere.git
    cd vim-anywhere
    ./install
    cd $DIR # back to dotfiles
}


# determine os
[[ ${OSTYPE//[0-9.]/} == "darwin" ]] && SYS="MacOSX" || SYS="Linux"

# osx stuff
if [[ $SYS == "MacOSX" ]]; then

    # permanently store git pw on osx
    sed -ri'.tmp' --follow-symlinks 's/helper ?= ?store/helper=osxkeychain/' ~/.gitconfig

    # homebrew
    [ -x "$(command -v brew)" ] || {
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" && \
        brew install wget;
    }

    # command line tools
    xcode-select --install

    # yubikey manager
    # YUBICO="https://developers.yubico.com/yubikey-manager-qt/Releases/yubikey-manager-qt-latest-mac.pkg"
    # wget $YUBICO

    # via https://www.macinstruct.com/tutorials/how-to-enable-git-tab-autocomplete-on-your-mac/
    # curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash
    wget -O ~/.git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
    chmod +x ~/.git-completion.bash
    # curl https://raw.githubusercontent.com/RichiH/git-annex/master/bash-completion.bash -o ~/.git-annex-completion.bash
    wget -O ~/.git-annex-completion.bash https://raw.githubusercontent.com/RichiH/git-annex/master/bash-completion.bash
    chmod +x ~/.git-annex-completion.bash
    # TODO and add to .bash_profile ?
fi


# instructions="""

read -r -d '' INSTRUCTIONS <<- EOM
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
EOM


# instructions_mac="""
read -r -d '' INSTRUCTIONS_MAC <<- EOM
    don't forget about "http://osxdaily.com/2018/10/09/fix-operation-not-permitted-terminal-error-macos"
    &
    "https://stackoverflow.com/a/4227294"
EOM

instructions_mac="""
don't forget about `http://osxdaily.com/2018/10/09/fix-operation-not-permitted-terminal-error-macos`
&
`https://stackoverflow.com/a/4227294`

plus consider changing computer name @ System Preferences > Sharing
"""

if (($linux)); then
    # sudo mkdir /Volumes
    # sudo mkdir /Volumes/Media
    echo "$INSTRUCTIONS"
else
    echo "$INSTRUCTIONS_MAC"
fi

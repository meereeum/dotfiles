#!/bin/bash
set -u # don't delete my hd plz

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if (($linux)); then

    # symlink correct python
    # sudo ln -s $HOME/*conda3/bin/python3 /usr/local/bin/python

    # install apt-get packages/packages
    while read line
        do sudo apt-get install -y ${line}
        #do sudo apt-get install ${line}
    done < packages/packages.txt

    # set default apps
    AUDIOVIZ_APP="vlc"
    PDF_APP="zathura"

    F_DEFAULTS="$HOME/.config/mimeapps.list"
    F_DEFAULTS_BKP="${F_DEFAULTS}.bkp"

    mv "$F_DEFAULTS" "$F_DEFAULTS_BKP"
    awk -F'=' '{OFS="="}; /video|audio/{print $1,"'$AUDIOVIZ_APP'.desktop;"} /pdf/{print $1, "'$PDF_APP'.desktop;"} !/video|audio|pdf/' $F_DEFAULTS_BKP > $F_DEFAULTS

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


# reveal-md
npm install -g reveal-md


# vim color
# TODO for osx ?
for COLORSCHEME in "${DIR}/*.vim"; do
    sudo ln -s "$COLORSCHEME" /usr/share/vim/vim*/colors
done


instructions="
TODO:

(1) install firefox [ plus ublock, ghostery, zotero plugin ]

(2) install mactex

(3) build tf for hardware optimizations ?

(4) get openstack stuff

(5) download geckodriver (and put in $PATH)
"

echo "$instructions"

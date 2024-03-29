#!/bin/bash
set -u # don't delete my hd plz

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if (($linux)); then

    # symlink correct python
    # sudo ln -s $HOME/*conda3/bin/python3 /usr/local/bin/python

    while read line
        do sudo apt-get install -y ${line}
        #do sudo apt-get install ${line}
    done < pkgs/aptpkgs.txt

    # set default apps
    AUDIOVIZ_APP="vlc"
    PDF_APP="zathura"

    F_DEFAULTS="$HOME/.config/mimeapps.list"
    F_DEFAULTS_BKP="${F_DEFAULTS}.bkp"

    mv "$F_DEFAULTS" "$F_DEFAULTS_BKP"
    awk -F'=' '{OFS="="}; /video|audio/{print $1,"'$AUDIOVIZ_APP'.desktop;"} /pdf/{print $1, "'$PDF_APP'.desktop;"} !/video|audio|pdf/' $F_DEFAULTS_BKP > $F_DEFAULTS

    # enable copying
    echo "set-selection-clipboard clipboard" >> ~/.config/zathura/zathurarc

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
    # brew tap railwaycat/emacsmacport # for emacs-mac
    # brew install emacs-mac --with-gnutls --with-imagemagick --with-modules --with-texinfo --with-xml2 --with-spacemacs-icon
    # brew linkapps emacs-mac

    #brew tap d12frosted/emacs-plus
    #brew install emacs-plus --with-no-title-bars
    #brew linkapps emacs-plus

    while read line
        do brew install ${line}
    # done < pkgs/brewpkgs.txt
    done < pkgs/brewpkgs.minimal.txt

    brew tap homebrew/cask
    while read line
        do brew cask install ${line}
    done < pkgs/brewpkgs_cask.txt

    # pdftk (old version when it still worked for mac)
    # via https://leancrew.com/all-this/2017/01/pdftk/
    # brew install https://raw.githubusercontent.com/turforlag/homebrew-cervezas/master/pdftk.rb
fi


# reveal-md
# npm install -g reveal-md


# gecko driver
(( $linux )) && osname="linux64" || osname="macos"
gecko_url=$( curl -s https://api.github.com/repos/mozilla/geckodriver/releases/latest |
             jq -r '.assets[].browser_download_url | select(contains("'$osname'"))' )

curl -s -L "$gecko_url" | tar -xz && \
    chmod +x geckodriver && sudo mv geckodriver /usr/local/bin


# vim color
# think this is done in _setup.sh now
# (( $linux )) && COLORDIR="/usr/share/vim/vim*/colors" \
#              || COLORDIR="$VIMRUNTIME/colors"
#            # || COLORDIR="/usr/local/Cellar/vim/*/share/vim/*/colors"
# for COLORSCHEME in "${DIR}/colors/*.vim"; do
#     sudo ln -s $COLORSCHEME $COLORDIR # quotes destroy ?
# done


instructions="
TODO:

(1) install firefox [ plus ublock, ghostery, zotero plugin, pinboard applets ]

(2) install mactex

(3) build tf for hardware optimizations ?

(4) get openstack stuff

(5) download geckodriver (and put in $PATH)

(6) consider installing https://github.com/RemoteDebug/remotedebug-ios-webkit-adapter
    & $ sudo spctl --master-disable (for more control, e.g. installing apps from non-Apple)

(7) copy over & set up ssh keys:
    chmod 600 ~/.ssh/config
    chown $USER ~/.ssh/config
    chmod 600 ~/.ssh/*key *rsa
    chmod 644 ~/.ssh/*pub
"

echo "$instructions"

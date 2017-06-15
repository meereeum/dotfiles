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


# shiff folder

FROM="$HOME/Desktop/$(whoami)"
TO="$HOME/shiff"

if [ -h ${TO} ]; then # true if file exists & is a symbolic link
	rm ${TO}
fi

ln -s $FROM $TO && \
	echo "${TO} --> ${FROM}"


# firefox

if [[ $OS == "darwin" ]]; then
	DEST="$HOME/Library/Application Support/Firefox/Profiles/pui47407.default"
else
	DEST="$HOME/.mozilla" # TODO
fi

DEST="${DEST}/user.js"

# google >>>>>> yahoo
echo 'user_pref("browser.search.defaultenginename", "Google");' > "${DEST}"
echo 'user_pref("browser.search.defaultenginename.US", "data:text/plain,browser.search.defaultenginename.US=Google");' >> "${DEST}"
echo 'user_pref("browser.search.order.1", "Google");' >> "${DEST}"

# don't ask about default browser
echo 'user_pref("browser.shell.checkDefaultBrowser", "false")' >> "${DEST}"


# conda

OS=${OSTYPE//[0-9.]/}
if [[ $OS == "darwin" ]]; then
	SYS="MacOSX"
else
	SYS="Linux"
fi

CONDA="https://repo.continuum.io/archive/Anaconda2-4.3.1-${SYS}-x86_64.sh" 
DEST="/Volumes/THAWSPACE${HOME}/conda"

if [ ! -e ${DEST}/bin/python ]; then

        # get rid of leftover dir
        if [ -e ${DEST} ]; then
            rm -r ${DEST}
        fi

	wget $CONDA -O ~/conda.sh && \
		bash ~/conda.sh -b -p ${DEST} && \ # silent install
		{
			rm ~/conda.sh
	
			export PATH="$DEST/bin:$PATH"
			export PYTHONPATH="$DEST/bin/python"
	
			yes | conda create -n py36 python=3.6 anaconda
		}
fi


# ye olde spacemacs

if [[ $OS == "darwin" ]]; then # built-in emacs is hella old
	if [[ ! $(brew list | grep emacs | wc -l) -eq 1 ]]; then # not yet installed
		sudo chown -R $(whoami) /usr/local/var/homebrew
		brew install emacs --with-cocoa
	fi
# also pandoc
	if [[ ! $(brew list | grep pandoc | wc -l) -eq 1 ]]; then
		brew install pandoc
		sudo ln -s /usr/local/Cellar/pandoc/1.19.2.1/bin/pandoc /usr/local/bin/pandoc
	fi
else
	sudo apt-get install pandoc
fi

FROM="/Volumes/THAWSPACE${HOME}/.emacs.d"
TO="$HOME/.emacs.d"

if [ ! -e ${FROM} ]; then
	git clone https://github.com/syl20bnr/spacemacs $FROM
fi

ln -s $FROM $TO && \
	echo "${TO} --> ${FROM}"


# set ~/.spacemacs python path

sed -Ei .tmp 's@(python-shell-virtualenv-path).*@\1 "/Volumes/THAWSPACE/Users/shiffman/conda")@' ${HOME}/.spacemacs
sed -Ei .tmp 's@(python-shell-interpreter).*@\1 "/Volumes/THAWSPACE/Users/shiffman/conda/bin/python")@' ${HOME}/.spacemacs

if [ -e ${HOME}/.spacemacs.tmp ]; then
	rm ${HOME}/.spacemacs.tmp
fi


# other athena-specific things
echo '
# athena

OS=${OSTYPE//[0-9.]/}

CONDA="/Volumes/THAWSPACE/Users/shiffman/conda"

export PATH="${CONDA}/bin:$PATH"
export PYTHONPATH="${CONDA}/bin/python"

if [[ $OS == "darwin" ]]; then
        alias emacs="/usr/local/Cellar/emacs/25.1/Emacs.app/Contents/MacOS/Emacs"
fi
' >> ${HOME}/.bash_profile

#!/usr/bin/env bash

PKGDIR="$( dirname "$0" )/pkgs"

[[ $DISPLAY ]] && SUFFIX="" || SUFFIX="_server"


# firefox addons
[[ $DISPLAY ]] && getAddons > "$PKGDIR/ffox_addons.txt" &&
    echo "updated: $PKGDIR/ffox_addons.txt"


# python pkgs
VPY=$( python --version 2>&1 | sed -E 's/^Python ([0-9])\.([0-9]).*$/\1\2/' ) # N.B. python --version goes to STDERR, not -OUT
conda env export -n root > "$PKGDIR/conda_py$VPY$SUFFIX.yml" &&
    echo "updated: $PKGDIR/conda_py$VPY$SUFFIX.yml"


# system pkgs
if (($linux)); then
	DISTRO=$( cat /etc/*-release | awk -F'=' '/^NAME/ {print $2}' | xargs )

	# apt
    OUTFILE="aptpkgs$SUFFIX.txt"
	pkgs > "$PKGDIR/$OUTFILE"
else
	# homebrew
	OUTFILE="brewpkgs.txt"
	brew list > "$PKGDIR/$OUTFILE"
	echo "updated: $PKGDIR/$OUTFILE"

	OUTFILE="brewpkgs_cask.txt"
	brew cask list > "$PKGDIR/$OUTFILE"
fi &&

echo "updated: $PKGDIR/$OUTFILE"

#!/usr/bin/env bash

PKGDIR="$( dirname "$0" )/packages"

# firefox addons
getAddons > "$PKGDIR/ffox_addons.txt"
echo "updated: $PKGDIR/ffox_addons.txt"


# python pkgs
#conda env export -n root > "${PKGDIR}/conda_py27.yml" &&
#conda env export -n py36 > "${PKGDIR}/conda_py36.yml" &&
VPY=$( python --version 2>&1 | sed -E 's/^Python ([0-9])\.([0-9]).*$/\1\2/' ) # NB python --version goes to STDERR, not -OUT
conda env export -n root > "${PKGDIR}/conda_py${VPY}.yml" &&

echo "updated: ${PKGDIR}/conda_py${VPY}.yml"
#echo "updated: ${PKGDIR}/conda_py{27,36}.yml"


# system pkgs
if (($linux)); then
	DISTRO=$( cat /etc/*-release | awk -F'=' '/^NAME/ {print $2}' | xargs )
	
	if [[ $DISTRO = "Ubuntu" ]]; then # server
		OUTFILE="packages_server.txt"
	else
		OUTFILE="packages.txt"
	fi

	# apt
	pkgs > "${PKGDIR}/${OUTFILE}"
else
	# homebrew
	OUTFILE="packages_brew.txt"
	brew list > "${PKGDIR}/${OUTFILE}"
	echo "updated: ${PKGDIR}/${OUTFILE}"

	OUTFILE="packages_brew_cask.txt"
	brew cask list > "${PKGDIR}/${OUTFILE}"
fi &&

echo "updated: ${PKGDIR}/${OUTFILE}"

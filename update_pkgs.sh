#!/bin/bash

PKGDIR="$( dirname "$0" )/packages"

# conda

conda env export -n root > "${PKGDIR}/conda_py27.yml" &&
conda env export -n py36 > "${PKGDIR}/conda_py36.yml" &&

echo "updated: ${PKGDIR}/conda_py{27,36}.yml"

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

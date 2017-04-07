#!/bin/sh
set -e

#------------------------------------------------------------------- unix-like #
# Simple script that generates a .gitconfig file and places it in $HOME
# WARN: Do not symlink this script or absdir might break. (ಠ_ಠ)
#------------------------------------------------------------------------------#

absdir() {
	echo "${1}" | \
	awk -v wrk_dir="${PWD}" \
		'{ if(substr ($0, 0, 1) == "/") \
			print $0; \
		else \
			print (wrk_dir "/" $0);}' | \
	xargs realpath | \
	xargs dirname
}

#------------------------------------------------------------------------------#
NAME_SCRIPT=$(basename "${0}")

if [ -z "${1}" ] ; then
	echo "${NAME_SCRIPT}: arguments are <full-name> <email>"
	exit 1
fi

if [ -z "${2}" ] ; then
	echo "${NAME_SCRIPT}: arguments are <full-name> <email>"
	exit 1
fi

if [ -n "${3}" ] ; then
	echo "${NAME_SCRIPT}: arguments are <full-name> <email>"
	exit 1
fi

PATH_SCRIPT_DIR=$(absdir "${0}")

sed -e "s/\${GIT_FULLNAME}/${1}/" \
	-e "s/\${GIT_EMAIL}/${2}/" "${PATH_SCRIPT_DIR}/nix.gitconfig" > "${HOME}/.gitconfig"

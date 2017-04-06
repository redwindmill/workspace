#!/bin/sh
set -e

#------------------------------------------------------------------- unix-like #
# Simple script that generates a .gitconfig file and places it in $HOME
# WARN: Do not symlink this script or abspath might break. (ಠ_ಠ)
#------------------------------------------------------------------------------#
abspath() { [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}" ; }

PATH_SCRIPT=$(abspath "$0")
PATH_SCRIPT_DIR=$(dirname "$PATH_SCRIPT")

NAME_SCRIPT=$(basename "$0")
if [ -z "$1" ] ; then
	echo "$NAME_SCRIPT: arguments are <full-name> <email>"
	exit 1
fi

if [ -z "$2" ] ; then
	echo "$NAME_SCRIPT: arguments are <full-name> <email>"
	exit 1
fi

sed -e "s/\${FULL_NAME}/$1/" \
	-e "s/\${EMAIL}/$2/" "$PATH_SCRIPT_DIR/nix.gitconfig" > "$HOME/.gitconfig"

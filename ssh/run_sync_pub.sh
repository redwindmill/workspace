#!/bin/sh
set -e

#------------------------------------------------------------------- unix-like #
# Simple script to copy the machine ssh pub key to git
# WARN: do not symlink this script or abspath might break. (ಠ_ಠ)
#------------------------------------------------------------------------------#
abspath() { [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}" ; }

NAME_SCRIPT=$(basename "$0")
if [ -z "$1" ] ; then
	echo "$NAME_SCRIPT: arguments are <filename.pub>"
	exit 1
fi

PATH_SCRIPT=$(abspath "$0")
PATH_SCRIPT_DIR=$(dirname "$PATH_SCRIPT")
FILENAME="$1"

cp -f "$HOME/.ssh/id_rsa.pub" "$PATH_SCRIPT_DIR/$FILENAME"

#!/bin/sh
set -e

#------------------------------------------------------------------------- osx #
# Simple script install visual studio code extensions
# NOTE: Probably still want to run 'Shell Command: Install Code' ...
# WARN: Do not symlink this script or abspath might break. (ಠ_ಠ)
#------------------------------------------------------------------------------#
abspath() { [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}" ; }

PATH_SCRIPT=$(abspath "$0")
PATH_SCRIPT_DIR=$(dirname "$PATH_SCRIPT")

grep -v "^#" < "$PATH_SCRIPT_DIR/cmn_extensions.txt" | \
grep -v -e '^[[:space:]]*$' | \
while read -r line || [[ -n "$line" ]]; do
	/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code \
		 --install-extension "$line"
done

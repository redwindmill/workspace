#!/bin/sh
set -e

#------------------------------------------------------------------- unix-like #
# Simple script to soft link vim settings
# WARN: Do not symlink this script or abspath might break. (ಠ_ಠ)
#------------------------------------------------------------------------------#
abspath() { [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}" ; }

PATH_SCRIPT=$(abspath "$0")
PATH_SCRIPT_DIR=$(dirname "$PATH_SCRIPT")

pushd "$HOME"

ln -vsf "$PATH_SCRIPT_DIR/nix.vimrc" ".vimrc"

popd

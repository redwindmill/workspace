#!/bin/sh
set -e

#------------------------------------------------------------------- unix-like #
# Simple script to soft link bash settings
# WARN: Do not symlink this script or abspath might break. (ಠ_ಠ)
#------------------------------------------------------------------------------#
abspath() { [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}" ; }

PATH_SCRIPT=$(abspath "$0")
PATH_SCRIPT_DIR=$(dirname "$PATH_SCRIPT")

pushd "$HOME"

ln -vsf "$PATH_SCRIPT_DIR/nix.bash_profile" ".bash_profile"
ln -vsf "$PATH_SCRIPT_DIR/nix.bash_profile" ".bashrc"

popd

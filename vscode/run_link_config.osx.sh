#!/bin/sh
set -e

#------------------------------------------------------------------------- osx #
# Simple script to soft link visual studio code settings and key bindings
# WARN: Do not symlink this script or abspath might break. (ಠ_ಠ)
#------------------------------------------------------------------------------#
abspath() { [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}" ; }

PATH_SCRIPT=$(abspath "$0")
PATH_SCRIPT_DIR=$(dirname "$PATH_SCRIPT")

pushd "$HOME"/Library/Application\ Support/Code/User

ln -vsf "$PATH_SCRIPT_DIR/osx_keybindings.json" "keybindings.json"
ln -vsf "$PATH_SCRIPT_DIR/cmn_settings.json" "settings.json"

popd

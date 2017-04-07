#!/bin/sh
set -e

#------------------------------------------------------------------------- osx #
# Simple script to soft link visual studio code settings and key bindings
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
PATH_SCRIPT_DIR=$(absdir "${0}")

pushd "${HOME}"/Library/Application\ Support/Code/User
	ln -vsf "${PATH_SCRIPT_DIR}/osx_keybindings.json" "keybindings.json"
	ln -vsf "${PATH_SCRIPT_DIR}/cmn_settings.json" "settings.json"
popd

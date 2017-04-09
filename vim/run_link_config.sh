#!/bin/sh
set -e

#------------------------------------------------------------------- unix-like #
# Simple script to soft link vim settings
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
WRK_DIR="${PWD}"

cd "${HOME}"
	ln -vsf "${PATH_SCRIPT_DIR}/nix.vimrc" ".vimrc"
cd "${WRK_DIR}"

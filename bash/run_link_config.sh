#!/bin/sh
set -e

#------------------------------------------------------------------- unix-like #
# Simple script to soft link bash settings
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
BASHRC_SRC="${PATH_SCRIPT_DIR}/nix.bash_profile"

if [ -d "${HOME}/git" ]; then
	chmod -v 700 "${HOME}/git"
fi

WRK_DIR="${PWD}"
cd "${HOME}"
	ln -vsf "${BASHRC_SRC}" ".bash_profile"
	ln -vsf "${BASHRC_SRC}" ".bashrc"
cd "${WRK_DIR}"

#------------------------------------------------------------------------------#
BASHRC_LOCAL="${HOME}/.bashrc.local"

if [ ! -f "${BASHRC_LOCAL}" ]; then
	touch "${BASHRC_LOCAL}"
	chmod -v 600 "${BASHRC_LOCAL}"
fi

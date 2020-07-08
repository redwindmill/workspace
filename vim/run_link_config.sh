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
SPELL_DIR="${HOME}/.vim/spell"
SPELL_SRC="${PATH_SCRIPT_DIR}/tech.utf-8.add"
SPELL_DST="${SPELL_DIR}/tech.utf-8.add"
VIMRC_SRC="${PATH_SCRIPT_DIR}/nix.vimrc"

mkdir -vp "${SPELL_DIR}"
chmod -v 700 "${HOME}/.vim"

WRK_DIR="${PWD}"
cd "${HOME}"
	ln -vsf "${VIMRC_SRC}" ".vimrc"
	ln -vsf "${SPELL_SRC}" "${SPELL_DST}"
cd "${WRK_DIR}"

#------------------------------------------------------------------------------#
VIMRC_LOCAL="${HOME}/.vimrc.local"

if [ ! -f "${VIMRC_LOCAL}" ]; then
	touch "${VIMRC_LOCAL}"
	chmod -v 600 "${VIMRC_LOCAL}"
fi

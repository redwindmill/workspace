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
VIMPLUG_DST="${HOME}/.vim/autoload/plug.vim"

curl -fLo "${VIMPLUG_DST}" --create-dirs \
	"https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"

#------------------------------------------------------------------------------#
VIMRC_PLUG="${PATH_SCRIPT_DIR}/plug.vimrc"

WRK_DIR="${PWD}"
cd "${HOME}"
	ln -vsf "${VIMRC_PLUG}" ".vimrc.plug"
cd "${WRK_DIR}"

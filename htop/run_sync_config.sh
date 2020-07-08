#!/bin/sh
set -e

#------------------------------------------------------------------- unix-like #
# Simple script that generates copies a htoprc file and places it in $HOME
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
HTOPRC_SRC="${PATH_SCRIPT_DIR}/htoprc"
HTOPRC_DST="${HOME}/.config/htop"

mkdir -vp "${HTOPRC_DST}"
cp "${HTOPRC_SRC}" "${HTOPRC_DST}"

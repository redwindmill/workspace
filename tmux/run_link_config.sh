#!/bin/sh
set -e

#------------------------------------------------------------------- unix-like #
# Simple script to soft link tmux settings
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
TMUXCONF_SRC="${PATH_SCRIPT_DIR}/v2_9.tmux.conf"

WRK_DIR="${PWD}"
cd "${HOME}"
	ln -vsf "${TMUXCONF_SRC}" ".tmux.conf"
cd "${WRK_DIR}"

#------------------------------------------------------------------------------#

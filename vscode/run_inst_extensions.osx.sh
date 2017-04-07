#!/bin/sh
set -e

#------------------------------------------------------------------------- osx #
# Simple script install visual studio code extensions
# NOTE: Probably still want to run 'Shell Command: Install Code' ...
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

grep -v "^#" < "${PATH_SCRIPT_DIR}/cmn_extensions.txt" | \
grep -v -e '^[[:space:]]*$' | \
while read -r LINE || [[ -n "${LINE}" ]]; do
	/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code \
		 --install-extension "${LINE}"
done

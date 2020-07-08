#!/bin/sh
set -e

#------------------------------------------------------------------- unix-like #
# Simple script that loads the dracula_custom theme into a gnome profile,
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
NAME_SCRIPT=$(basename "${0}")

if [ -z "${1}" ] || [ -n "${2}" ]; then
	echo "${NAME_SCRIPT}: arguments are <profile-id>"
	exit 1
fi

PROFILE_ID="${1}"

#------------------------------------------------------------------------------#
PATH_SCRIPT_DIR=$(absdir "${0}")
DCONFIG_SRC="${PATH_SCRIPT_DIR}/dracula_custom.dconf"
DCONFIG_DST="${PATH_SCRIPT_DIR}/dracula_custom.dconf~"

sed -e "s/\${DRACULA_CUSTOM_PROFILE_ID}/${PROFILE_ID}/" \
	"${DCONFIG_SRC}" > "${DCONFIG_DST}"

dconf load /org/gnome/terminal/legacy/profiles:/ < "${DCONFIG_DST}"
rm "${DCONFIG_DST}"

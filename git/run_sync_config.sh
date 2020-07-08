#!/bin/sh
set -e

#------------------------------------------------------------------- unix-like #
# Simple script that generates a .gitconfig file and places it in $HOME
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

if [ -z "${1}" ] || [ -z "${2}" ] || [ -z "${3}" ] || [ -n "${4}" ]; then
	echo "${NAME_SCRIPT}: arguments are <full-name> <email> <none or gpg-keyid>"
	echo "${NAME_SCRIPT}: gpg-keyid is obtained from running 'gpg --list-secret-keys --keyid-format LONG'"
	exit 1
fi

NAME="${1}"
EMAIL="${2}"

if [ "${3}" != "none" ]; then
	GPG_SIGN="true"
	GPG_KEY="${3}"
else
	GPG_SIGN="false"
	GPG_KEY=
fi

#------------------------------------------------------------------------------#
PATH_SCRIPT_DIR=$(absdir "${0}")
GITCONFIG_SRC="${PATH_SCRIPT_DIR}/nix.gitconfig"
GITCONFIG_DST="${HOME}/.gitconfig"

sed -e "s/\${GIT_FULLNAME}/${NAME}/" \
	-e "s/\${GIT_EMAIL}/${EMAIL}/" \
	-e "s/\${GIT_GPGKEY}/${GPG_KEY}/" \
	-e "s/\${GIT_GPGSIGN}/${GPG_SIGN}/" \
	"${GITCONFIG_SRC}" > "${GITCONFIG_DST}"

# alternative; has issues with bash embedded in some git alias commands
#eval "cat <<EOF
#$(<${GITCONFIG_SRC})
#EOF
#" 2>/dev/null > "${GITCONFIG_DST}"

chmod -v 600 "${GITCONFIG_DST}"

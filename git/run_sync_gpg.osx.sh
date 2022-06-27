#!/bin/sh
set -e

#------------------------------------------------------------------- unix-like #
# Simple script that sets up gpg to work with git on mac, requires pinentry-mac.
#------------------------------------------------------------------------------#

mkdir -vp "${HOME}/.gnupg"
chmod 700 "${HOME}/.gnupg"
echo "pinentry-program $(brew --prefix)/bin/pinentry-mac" > "${HOME}/.gnupg/gpg-agent.conf"
echo 'use-agent' > "${HOME}/.gnupg/gpg.conf"
killall gpg-agent

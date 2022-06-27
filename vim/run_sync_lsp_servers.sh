#!/bin/sh
set -e

#------------------------------------------------------------------- unix-like #
# Simple script that downloads language servers for vim
#------------------------------------------------------------------------------#
NAME_SCRIPT=$(basename "${0}")

echo "${NAME_SCRIPT}: installing gopls"
mkdir "${HOME}/bin"
chmod 700 "${HOME}/bin"
go install go install golang.org/x/tools/gopls@latest

echo "${NAME_SCRIPT}: installing pyls"
pip3 install python-language-server --upgrade

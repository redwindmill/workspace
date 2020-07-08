#!/bin/sh
set -e

#------------------------------------------------------------------- unix-like #
# Simple script that downloads language servers for vim
#------------------------------------------------------------------------------#
NAME_SCRIPT=$(basename "${0}")

echo "${NAME_SCRIPT}: installing gopls"
go get -u golang.org/x/tools/cmd/gopls

echo "${NAME_SCRIPT}: installing pyls"
pip3 install python-language-server --upgrade


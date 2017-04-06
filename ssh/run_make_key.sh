#!/bin/sh
set -e

#------------------------------------------------------------------- unix-like #
# Simple script that generates an ssh key
#------------------------------------------------------------------------------#

NAME_SCRIPT=$(basename "$0")
if [ -z "$1" ] ; then
	echo "$NAME_SCRIPT: arguments are <email>"
	exit 1
fi

ssh-keygen -t rsa -b 4096 -C "$1"

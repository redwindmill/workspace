#!/bin/sh
set -e

#---------------------------------------------------------------- alpine linux #
# Script that will update and install apk packages on alpine linux raspberry pi
# NOTE: Alpine on rpi runs in ram. You'll need to mount remount the sd card.
#------------------------------------------------------------------------------#

PACKAGES=" \
	bash \
	curl \
	git \
	htop \
	vim \
	docker \
"

#------------------------------------------------------------------------------#
NAME_SCRIPT=$(basename "${0}")

echo "${NAME_SCRIPT}: updating apk"
mount /media/mmcblk0p1 -o rw,remount
apk update

echo "${NAME_SCRIPT}: upgrading apk packages"
apk upgrade

echo "${NAME_SCRIPT}: installing packages"

for P in ${PACKAGES}; do
	apk add ${P}
done

apk add man man-pages
mount /media/mmcblk0p1 -o r,remount


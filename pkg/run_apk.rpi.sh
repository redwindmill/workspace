#!/bin/sh
set -e

#---------------------------------------------------------------- alpine linux #
# Script that will update and install apk packages on alpine linux raspberry pi
# NOTE: Alpine on rpi runs in ram. You'll need to mount remount the sd card.
#
# SETUP RPI3:
#	IMAGE:
#	1	Download alpine rpi 3.4.6
#	2	Remove 'quiet' from /cmdline.txt
#	3	Add wifi firmware (brcmfmac43430) to /firmware/brcm
#		(https://github.com/RPi-Distro/firmware-nonfree/tree/master/brcm80211/brcm)
#	4	Format sdcard as 'FAT32/masterboot'
#
#	BOOT 1:
#	1	Run 'setup-alpine'
#	2	Modify '/etc/apk/respositories' to reflect latest (stable or edge)
#	4	Run this script (add to image or use wget)
#	6	Run 'rc-update add swclock boot'
#		Run 'rc-update del hwclock boot'
#		Run 'rc-update add wpa_supplicant boot'
#		Run 'rc-update add sshd'
#	7	Run 'lbu commit' and 'reboot'
#
#	BOOT 2:
#	1	Edit '/etc/rc.conf' and add 'UNICODE = YES'
#	2	Edit '/etc/passwd' and set user shell to '/bin/bash'
#	3	Run 'ssh-keygen -t rsa -b 4096 -C ""'
#		Add '~/.ssh/autorized_keys'
#		Run 'chmod 644 ~/.ssh/autorized_keys'
#		Add your remote pub key
#	4	Edit '/etc/ssh/sshd_config' and add:
#			Protocol 2
#			PasswordAuthentication No
#			PermitRootLogin without-password
#			PubKeyAuthentication yes
#			UseDNS No
#	5	Run 'lbu add ~/.ssh'
#	6	Run 'lbu commit' and 'reboot'
#
# SETUP NOTES (3.5.2):
#	Alpine rpi image v3.5.0->3.5.2 is broken for rpi3. Doesn't boot after setup.
#	Add 'enable_uart=1' to '/boot/config.txt'. Could cause issue with btooth.
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


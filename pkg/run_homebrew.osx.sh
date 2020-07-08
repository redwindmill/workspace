#!/bin/sh
set -e

#------------------------------------------------------------------------- osx #
# Script that will update and install homebrew packages on osx.
# NOTE: You will need homebrew first
#
# /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
#
# HOMEBREW CASKS(brew cask install)
#	docker
#	google-backup-and-sync
#	google-chrome
#	xquartz

# NOT AVAILABLE
# iotop
# nmon

# BASH SHELL
# add /usr/local/bin/bash to /etc/shells
# run chsh -s /usr/local/bin/bash

# MULTI USER BREW
# add brew group via osx users & groups; add your brew users to that group
# change homebrew folder groups (sudo chgrp -R brew $(brew --prefix)/*)
# change homebrew foler group to writable (sudo chmod -R g+w $(brew --prefix)/*)

# GIT SETUP
# After install
# - update ~/.gnupg/gpg-agent.conf with "pinentry-program /usr/local/bin/pinentry-mac"
# - run "git lfs install"
# - add to ~/.ssh/config
# ```
# Host *
#  AddKeysToAgent yes
#  UseKeychain yes
#  IdentityFile ~/.ssh/id_rsa
# - run "ssh-add -K ~/.ssh/id_rsa"
#------------------------------------------------------------------------------#

PACKAGES=" \
	aspell \
	awk \
	bash \
	bash-completion \
	coreutils \
	cppcheck \
	curl \
	fzf \
	git \
	git-lfs \
	go \
	gpg \
	grep \
	htop \
	ical-buddy \
	iftop \
	jq \
	make \
	netcat \
	nmap \
	pinentry-mac \
	rsync \
	tmux \
	vim \
	watch \
"

#------------------------------------------------------------------------------#
NAME_SCRIPT=$(basename "${0}")

echo "${NAME_SCRIPT}: updating homebrew"
brew update
brew doctor

echo "${NAME_SCRIPT}: upgrading homebrew packages"
brew upgrade

echo "${NAME_SCRIPT}: installing packages"

for P in ${PACKAGES}; do
	brew install ${P}
done

echo "${NAME_SCRIPT}: cleaning up"
brew cleanup -s
brew list
brew info

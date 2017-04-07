#!/bin/sh
set -e

#------------------------------------------------------------------------ os x #
# Script that will update and install homebrew packages on osx.
# NOTE: You will need homebrew first
#
# /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
#------------------------------------------------------------------------------#

PACKAGES=" \
	aspell \
	cmake \
	coreutils \
	curl \
	docker \
	docker-machine \
	git \
	git-lfs \
	go \
	htop-osx \
	lua \
	python \
	vim \
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
brew cleanup
brew list
brew info

#!/bin/sh

DOTFILES_BOOTSTRAP=false source ./bootstrap.sh

packages="${@:-$DOTFILES_PACKAGES}"

if [ "x$packages" = 'x' ]; then
	die "no package(s) specified to install"
fi

install_packages_if_necessary "${packages}" || die "Installing ${packages} failed"

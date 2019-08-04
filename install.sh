#!/bin/sh

DOTFILES_BOOTSTRAP=false source ./bootstrap.sh

package="${1:-$DOTFILES_PACKAGE}"

if [ "x$package" = 'x' ]; then
	die "no package specified to install"
fi

install_packages_if_necessary "${package}" || die "Installing ${package} failed"
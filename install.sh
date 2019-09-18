#!/bin/sh

DOTFILES_BOOTSTRAP=false . ./bootstrap.sh

if [ $# -eq 0 ]; then
    die "no package(s) specified to install"
fi

install_packages_if_necessary $@ || die "Installing ${@} failed"

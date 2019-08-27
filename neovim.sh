#!/bin/sh

DOTFILES_BOOTSTRAP=false source ./bootstrap.sh

package=neovim

DOTFILES_HOMEBREW_OPTS="--HEAD"
if ! command_is_executable nvim; then
    package_exists $package || try_add_apt_repository "ppa:$package-ppa/stable"
    install_packages $package || die "Installing $package failed"
fi

curl -sSL git.io/speedcola | sh -s -- ~/.config/nvim

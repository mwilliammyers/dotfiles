#!/bin/sh

DOTFILES_BOOTSTRAP=false . "$(dirname "$0")/../bootstrap.sh"

package=neovim

export DOTFILES_HOMEBREW_OPTS="--HEAD"
if ! command_is_executable nvim; then
    package_exists $package || try_add_apt_repository "ppa:$package-ppa/stable"
    install_packages $package || die "Installing $package failed"
fi

curl -fsSL git.io/speedcola | sh -s -- nvim

command_is_executable "fish" \
    && command_is_executable "nvim" \
    && fish -c "set -Ux EDITOR nvim"

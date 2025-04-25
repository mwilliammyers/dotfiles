#!/bin/sh

DOTFILES_BOOTSTRAP=false . "$(dirname "$0")/../bootstrap.sh"

package=ripgrep

if ! command_is_executable rg; then
    install_packages $package || die "Installing $package failed"
fi

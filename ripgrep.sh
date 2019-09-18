#!/bin/sh

DOTFILES_BOOTSTRAP=false . ./bootstrap.sh

package=ripgrep

if ! command_is_executable rg; then
    install_packages $package || die "Installing $package failed"
fi

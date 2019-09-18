#!/bin/sh

DOTFILES_BOOTSTRAP=false . ./bootstrap.sh

package=iTerm2

command_is_executable brew >> /dev/null \
    || die "Currenrly only macOS (via homebrew) is supported for installing $package"

DOTFILES_HOMEBREW_CASK=true ./install.sh $package


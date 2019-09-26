#!/bin/sh

DOTFILES_BOOTSTRAP=false . ./bootstrap.sh

package=iTerm2

command_is_executable brew >> /dev/null \
    || die "Currenrly only macOS (via homebrew) is supported for installing $package"

if [ -d "/Applications/$package.app" ]; then
    echo "$package is already installed, skipping..."
else
    DOTFILES_HOMEBREW_CASK=true install_packages $package
fi

# TODO: automate Settings > General > Preferences > load preferences from a custom folder or URL


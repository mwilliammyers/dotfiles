#!/bin/sh

DOTFILES_BOOTSTRAP=false . "$(dirname "$0")/../bootstrap.sh"

package=iTerm2

command_is_executable brew >> /dev/null \
    || die "Currently only macOS (via homebrew) is supported for installing $package"

if [ -d "/Applications/$package.app" ]; then
    echo "$package is already installed, skipping..."
else
    install_packages $package
fi

# TODO: automate Settings > General > Preferences > load preferences from a custom folder or URL


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

source_config_dir="$DOTFILES_DIR/config/$package"
# TODO: rely on $HOME being set?
# TODO: support XDG...
dest_config_dir=$HOME/.config/$package

configure_single_package "$source_config_dir" "$dest_config_dir"


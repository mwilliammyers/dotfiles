#!/bin/sh

DOTFILES_BOOTSTRAP=false source ./bootstrap.sh

package=iTerm2

command_is_executable brew >> /dev/null \
	|| die "Currenrly only macOS (via homebrew) is supported for installing $package"

DOTFILES_HOMEBREW_CASK=true ./install.sh $package

# TODO: rely on $HOME being set?
source_config_dir="$DOTFILES_DIR/config/$package"
dest_config_dir=$HOME/Library/Application\ Support/$package

configure_single_package "$source_config_dir" "$dest_config_dir"

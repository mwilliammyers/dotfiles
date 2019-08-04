#!/bin/sh

DOTFILES_BOOTSTRAP=false source ./bootstrap.sh

package=iTerm2

command_is_executable brew >> /dev/null \
	|| die "Currenrly only macOS (via homebrew) is supported for installing $package"

# DOTFILES_HOMEBREW_CASK=true ./install.sh $package

# TODO: rely on $HOME being set?
config_dir="$HOME/Library/Application\ Support/$package"

echo $config_dir

info "Configuring $package"
if [ -d "$config_dir" ]; then
	warn "Overwriting existing configuration"
	rm -ri "$config_dir"
fi
ln -s "$DOTFILES_DIR/config/$package" "$config_dir"
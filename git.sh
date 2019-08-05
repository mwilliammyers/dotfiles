#!/bin/sh

DOTFILES_BOOTSTRAP=false source ./bootstrap.sh

package="git"

# TODO: should we overwrite system git on macOS?
install_packages_if_necessary "${package}" || die "Installing ${package} failed"

source_config_dir="$DOTFILES_DIR/config/$package"
# TODO: rely on $HOME being set?
# TODO: support XDG...
dest_config_dir=$HOME/.config/$package

configure_single_package "$source_config_dir" "$dest_config_dir"

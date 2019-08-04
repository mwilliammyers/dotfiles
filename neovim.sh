#!/bin/sh

DOTFILES_BOOTSTRAP=false source ./bootstrap.sh

DOTFILES_HOMEBREW_OPTS="--HEAD"
if ! command_is_executable nvim; then
	package_exists "neovim" || try_add_apt_repository "ppa:neovim-ppa/stable"
	install_packages "neovim" || die "Installing neovim failed"
fi

curl -sSL git.io/speedcola | sh -s -- ~/.config/nvim

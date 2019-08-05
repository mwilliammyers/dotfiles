#!/bin/sh

DOTFILES_BOOTSTRAP=false source ./bootstrap.sh

cargo_path="$HOME/.cargo/bin/cargo"

if ! [ -x  "$cargo_path" ]; then
	info "Installing rust..."
	curl https://sh.rustup.rs -sSf | sh -s -- -y --no-modify-path
fi

command_is_executable fish >> /dev/null && fish -c "set -Ux fish_user_paths $cargo_path"

command "$cargo_path" install --force \
	cargo-watch \
	cargo-edit \
	cargo-bloat \
	cargo-tree \
	cargo-update \
	ripgrep \
	exa \
	fd-find

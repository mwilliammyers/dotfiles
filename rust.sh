#!/bin/sh

DOTFILES_BOOTSTRAP=false source ./bootstrap.sh

if ! command_is_executable cargo; then
	info "Installing rust..."
	curl https://sh.rustup.rs -sSf | sh -s -- -y --no-modify-path
fi

$HOME/.cargo/bin/cargo install \
	cargo-watch \
	cargo-edit \
	cargo-bloat \
	ripgrep \
	exa \
	fd-find

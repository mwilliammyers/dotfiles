#!/bin/sh

DOTFILES_BOOTSTRAP=false source ./bootstrap.sh

cargo_path="$HOME/.cargo/bin/cargo"

if ! [ -x  "$cargo_path" ]; then
	info "Installing rust..."
	curl https://sh.rustup.rs -sSf | sh -s -- -y --no-modify-path
fi

command_is_executable fish >> /dev/null && fish -c "set -Ux fish_user_paths $cargo_path"

if [ "$(uname -s)" == "Darwin" ]; then
	command_is_executable "clang" || xcode-select --install 2> /dev/null
else
	install_packages_if_necessary "gcc" || die "Installing gcc failed"
fi

# if [ "$(uname -s)" == "Darwin" ]; then
# 	# needed for cargo-update & cargo-tree
# 	install_packages "openssl"
# fi

command "$cargo_path" install --force \
	cargo-watch \
	cargo-edit \
	cargo-bloat \
	ripgrep \
	exa \
	fd-find

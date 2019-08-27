#!/bin/sh

DOTFILES_BOOTSTRAP=false source ./bootstrap.sh

cargo_bin_path="$HOME/.cargo/bin"

if ! [ -x  "$cargo_bin_path/cargo" ]; then
    info "Installing rust..."
    curl https://sh.rustup.rs -sSf | sh -s -- -y --no-modify-path
fi

command_is_executable fish >> /dev/null && fish -c "set -Ux fish_user_paths $cargo_bin_path"

if [ "$(uname -s)" == "Darwin" ]; then
    command_is_executable "clang" || xcode-select --install 2> /dev/null
else
    install_packages_if_necessary "gcc" || die "Installing gcc failed"
fi

NUM_LOGICAL_CORES="$(getconf _NPROCESSORS_ONLN)"
if ! grep -q "jobs" ~/.cargo/config; then
    printf "\n\n[build]\njobs=$NUM_LOGICAL_CORES" >> ~/.cargo/config
fi

# if [ "$(uname -s)" == "Darwin" ]; then
#   # needed for cargo-update & cargo-tree
#   install_packages "openssl"
# fi

command "$cargo_bin_path/cargo" install --force \
    cargo-watch \
    cargo-edit \
    cargo-bloat \
    ripgrep \
    exa \
    bat \
    fd-find

#!/bin/sh

DOTFILES_BOOTSTRAP=false . ./bootstrap.sh

cargo_bin_path="$HOME/.cargo/bin"

if ! [ -x  "$cargo_bin_path/cargo" ]; then
    info "Installing Rust..."
    install_packages_if_necessary "curl" || die "Installing curl failed"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi

command_is_executable fish >> /dev/null && fish -c "set -Ux fish_user_paths $cargo_bin_path"

if [ "$(uname -s)" = "Darwin" ]; then
    command_is_executable "clang" || xcode-select --install 2> /dev/null
else
    install_packages_if_necessary "gcc" || die "Installing gcc failed"
fi

# if [ "$(uname -s)" = "Darwin" ]; then
#   # needed for cargo-update & cargo-tree
#   install_packages "openssl"
# fi

for package in "cargo-watch" "cargo-edit"; do
    command "$cargo_bin_path/cargo" install $package &
done
wait

#!/bin/sh

DOTFILES_BOOTSTRAP=false . ./bootstrap.sh

package="FiloSottile/musl-cross/musl-cross"

command_is_executable brew \
    || die "Currently only macOS (via homebrew) is supported for installing ${package}"

# TODO: check all executables
if ! command_is_executable x86_64-linux-musl-gcc; then
    # FIXME: DOTFILES_HOMEBREW_OPTS
    # export DOTFILES_HOMEBREW_OPTS="--with-arm-hf --with-aarch64 --with-arm"

    install_packages "${package}" || die "Installing ${package} failed"
fi

if command_is_executable cargo >/dev/null 2>&1; then
    if ! grep -q "x86_64-linux-musl-gcc" ~/.cargo/config 2>/dev/null; then
        printf '\n\n[target.x86_64-unknown-linux-musl]\nlinker = "x86_64-linux-musl-gcc"' >> ~/.cargo/config
    fi
fi

#!/bin/sh

DOTFILES_BOOTSTRAP=false . ./bootstrap.sh

package="starship"

if ! command_is_executable "${package}"; then
    if [ -x "$(command -v brew)" ]; then
        install_packages "${package}" || die "Installing ${package} failed"
    else
        install_packages_if_necessary curl || die "Installing curl failed"
        
        # curl -fsSL https://starship.rs/install.sh | bash -s -- -f
        curl -fsSL https://starship.rs/install.sh | bash
    fi
fi

if command_is_executable "${package}"; then
    # TODO: rely on $HOME being set?
    # TODO: support XDG...
    configure_single_package "$DOTFILES_DIR/config/$package" "$HOME/.config"

    command fish -c 'fisher install mwilliammyers/starship' || true
fi

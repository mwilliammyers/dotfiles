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
    # https://github.com/starship/starship/pull/921
    # starship config git_status.disabled true
    starship config gcloud.disabled true
    starship config aws.disabled true

    command fish -c 'fisher add mwilliammyers/starship' \
        || echo 'Visit https://starship.rs/guide/ to configure starship'
fi

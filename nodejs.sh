#!/bin/sh

DOTFILES_BOOTSTRAP=false . ./bootstrap.sh

version="${NODEJS_VERSION:-12}"

if ! command_is_executable node; then
    # https://nodejs.org/en/download/package-manager/#installing-node-js-via-package-manager
    package="nodejs"
    if [ -x "$(command -v pacman)" ]; then
        package="${package} npm"
    elif [ -x "$(command -v yum)" ]; then
        package="nodejs${version}"
    elif [ -x "$(command -v zypper)" ]; then
        package="nodejs${version}"
    fi

    if [ -x "$(command -v apt-get)" ]; then
        # TODO: might not work for debian?
        curl -sL "https://deb.nodesource.com/setup_${version}.x"| sudo -E bash -
    fi

    install_packages "${package}" || die "Installing ${package} failed"
fi

safe_npm_global "prettier"

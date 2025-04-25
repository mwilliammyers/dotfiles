#!/bin/sh

DOTFILES_BOOTSTRAP=false . "$(dirname "$0")/../bootstrap.sh"

install_packages_if_necessary "curl"

if [ -x "$(command -v apt-get)" ]; then
    if ! command_is_executable "docker"; then
        sudo apt-get remove docker docker-engine docker.io

        sudo apt-get install \
            apt-transport-https \
            ca-certificates \
            software-properties-common

        if [ "$(lsb_release -is)" = "Ubuntu" ]; then
          
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

            sudo add-apt-repository \
                "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu \
                $(lsb_release -cs) \
                stable"
        elif [ "$(lsb_release -is)" = "Debian" ]; then
            sudo apt-get install gnupg2

            curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | sudo apt-key add -

            sudo add-apt-repository \
                "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
                $(lsb_release -cs) \
                stable"
        fi


        update_package_index

        install_packages "docker-ce"
    fi
else
    install_packages_if_necessary "docker"
fi

if [ -x "$(command -v fish)" ]; then
    info "Installing fish completions..."
    # TODO: figure out how to integrate this with fisher
    curl --create-dirs -Lo ~/.config/fish/completions/docker.fish \
        https://raw.githubusercontent.com/docker/cli/master/contrib/completion/fish/docker.fish
fi


#!/bin/sh

DOTFILES_BOOTSTRAP=false . "$(dirname "$0")/../bootstrap.sh"

package="google-cloud-sdk"

if ! command_is_executable gcloud; then
    info "Installing $package..."

    if [ -x "$(command -v apt-get)" ]; then
        echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" \
            | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
        
        apt-get install apt-transport-https ca-certificates

        install_packages_if_necessary curl

        curl https://packages.cloud.google.com/apt/doc/apt-key.gpg \
            | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -

        sudo apt-get update
       
        sudo apt-get install "$package" || die "Installing $package failed"
    elif [ -x "$(command -v brew)" ]; then
        brew cask install "$package" || die "Installing $package failed"
    elif [ -x "$(command -v yum)" ]; then
        sudo tee -a /etc/yum.repos.d/google-cloud-sdk.repo << EOM
[google-cloud-sdk]
name=Google Cloud SDK
baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
       https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOM
    
    sudo yum install "$package"
    else
        curl -fsSL https://sdk.cloud.google.com \
            | bash -- -s --disable-prompts --install-dir="$HOME/.local/"
    fi
fi

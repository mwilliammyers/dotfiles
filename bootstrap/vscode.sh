#!/bin/sh

DOTFILES_BOOTSTRAP=false . ./bootstrap.sh

install_packages_if_necessary "curl"

package="code"

if [ -x "$(command -v brew)" ]; then
    package="visual-studio-code"
elif [ -x "$(command -v apt-get)" ]; then
    curl https://packages.microsoft.com/keys/microsoft.asc \
        | gpg --dearmor > packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
    sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

    install_packages_if_necessary "apt-transport-https"
elif [ -x "$(command -v zypper)" ]; then
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/zypp/repos.d/vscode.repo'
elif [ -x "$(command -v nix-env)" ]; then
    package="vscode"
fi

update_package_index

install_packages_if_necessary "$package"

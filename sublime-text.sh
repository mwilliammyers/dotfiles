#!/bin/sh

# TODO: use install_packages...

DOTFILES_BOOTSTRAP=false source ./bootstrap.sh

if [ -x "$(command -v brew)" ]; then
    brew cask install sublime-text
elif [ -x "$(command -v apt-get)" ]; then
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
    sudo apt install -y apt-transport-https
    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
    sudo apt update
    sudo apt install -y sublime-text
elif [ -x "$(command -v pacman)" ]; then
    curl -O https://download.sublimetext.com/sublimehq-pub.gpg \
        && sudo pacman-key --add sublimehq-pub.gpg \
        && sudo pacman-key --lsign-key 8A8F901A \
        && rm sublimehq-pub.gpg
    echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf
    sudo pacman -Syu sublime-text
elif [ -x "$(command -v yum)" ]; then
    sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
    sudo yum-config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
    sudo yum install sublime-text
elif [ -x "$(command -v dnf)" ]; then
    sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
    sudo dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
    sudo dnf install sublime-text
elif [ -x "$(command -v zypper)" ]; then
    sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg
    sudo zypper addrepo -g -f https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
    sudo zypper install sublime-text
fi

#!/usr/bin/env bash

dotfiles_dir="$HOME/Documents/developer/dotfiles"

is_installed() {
  command -v "$1" >/dev/null 2>&1
}

# install dependencies
is_installed brew || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
is_installed ansible || brew install ansible
is_installed git || brew install git

mkdir git clone git@github.com:mwilliammyers/dotfiles.git "${dotfiles_dir}" \
  && cd "${dotfiles_dir}"

# bootstrap!
ansible-playbook -i localhost -c local bootstrap.yml

#!/usr/bin/env bash

dotfiles_dir="$HOME/Documents/developer/dotfiles"

# install dependencies
brew || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
ansible || brew install ansible
git || brew install git

mkdir -p "${dotfiles_dir}" \
  && cd $(dirname "${dotfiles_dir}") \
  && git clone git@github.com:mwilliammyers/dotfiles.git \
  && cd "${dotfiles_dir}"

# bootstrap!
ansible-playbook -i localhost -c local bootstrap.yml

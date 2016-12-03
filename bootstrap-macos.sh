#!/usr/bin/env bash

dotfiles_dir="$HOME/Documents/developer/dotfiles"

is_installed() {
  command -v "$1" >/dev/null 2>&1
}

# install dependencies
is_installed brew || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
is_installed ansible || brew install ansible
is_installed git || brew install git

if [ -d "${dotfiles_dir}/.git" ]; then
  cd "${dotfiles_dir}"
  git pull || exit 1
else 
  git clone https://github.com/mwilliammyers/dotfiles.git "${dotfiles_dir}" || exit 1
  cd "${dotfiles_dir}"
fi

# bootstrap!
ansible-galaxy install -r requirements.yml
ansible-playbook -i 'localhost,' -c local --ask-vault-pass bootstrap.yml

#!/usr/bin/env bash

set -E

GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
BOLD=$(tput bold)
NORMAL=$(tput sgr0)
RESET='\033[0;m'

#####=== functions ===#####

info() {
  echo -e "${BLUE}${BOLD}==> ${NORMAL}${BOLD}${1}${RESET}"
}

is_installed() {
  local ret=0
  command -v "$1" >/dev/null 2>&1 || ret=1
  return "$ret"
}

package_install() {
  # determine which package manager to use
  # TODO: cache the found package manager
  is_installed apt-get && _apt_install "$1"
  is_installed brew && _brew_install "$1"
  is_installed yum && _pacman_install "$1"
  is_installed pacman && _pacman_install "$1"
  is_installed pkg && _pkg_install "$1"
  is_installed emerge && _emerge_install "$1"
  is_installed pip && _pip_install "$1"
  # TODO: build ansible from source and/or warn user to install a package manager
}

_apt_install() {
  if [ "$1" == "ansible" ]; then
    sudo apt-get install "software-properties-common"
    sudo apt-add-repository "ppa:ansible/ansible"
    sudo apt-get update
  fi
  sudo apt-get install "$1"
}

_brew_install() {
  brew install "$1"
}

_emerge_install() {
  local package = "$1"
  if [ $package == "ansible" ]; then
    package = "app-admin/ansible"  
  fi
  emerge -av "$package"
}

_pacman_install() {
  sudo pacman -S "$1" --noconfirm --force
}

pip_install() {
  pip install "$1" --upgrade
}

_pkg_install() {
  sudo pkg install "$1"
}

_yum_install() {
  sudo yum install "$1"
}

#####=== install dependencies ===#####

info "Install ansible"
is_installed ansible || package_install ansible

info "Install role dependencies"
sudo ansible-galaxy install -r requirements.yml --force # FIXME: might not require sudo?

info "Configure ssh"
ansible-playbook ssh.yml -l localhost

info "Configure ansible"
ansible-playbook ansible.yml --ask-become-pass -l localhost

#####=== bootstrap ===#####

# ansible-playbook site.yml -t bootstrap

exit

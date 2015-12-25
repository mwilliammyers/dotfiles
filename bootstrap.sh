#!/usr/bin/env bash

set -E

GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
BOLD=$(tput bold)
NORMAL=$(tput sgr0)
RESET='\033[0;m'

############################# functions
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
  is_installed pacman >/dev/null 2>&1 || sudo pacman -Sy && sudo pacman -S $1 --noconfirm --force
  return $?
}

pip_install() {
  pip install $1 --upgrade
  return $?
}

############################# install dependencies
if [[ "$OSTYPE" =~ ^(linux)+ ]]; then
  # Only install python and pip on Linux, they come pre-installed on OS X
  # TODO: determine name of package for python & pip to use - pacman, apt use python-pip 
  info "Install python & pip"
  package_install python-pip
fi

# Install ansible via pip if necessary (will install via package manager later)
info "Install ansible"
is_installed ansible || pip_install ansible
# is_installed redis || pip_install redis

info "Configure ansible"
ansible-playbook ansible.yml --ask-become-pass

info "Install role dependencies"
sudo ansible-galaxy install -r requirements.yml --force

############################# bootstrap
# ansible-playbook site.yml -t bootstrap

exit 0

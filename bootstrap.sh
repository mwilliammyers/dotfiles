#!/usr/bin/env bash

set -E

ANSIBLE_CONFIG_DIR="$HOME/.config/ansible"
ANSIBLE_CONFIG="$ANSIBLE_CONFIG_DIR/ansible.cfg"

if [[ -d "$ANSIBLE_CONFIG_DIR/.git" ]]; then
  pushd >/dev/null 2>&1 "$ANSIBLE_CONFIG_DIR" && git pull && popd >/dev/null 2>&1 
else 
  git clone https://gist.github.com/bcae313de14ab9a3ac66.git "$ANSIBLE_CONFIG_DIR"
fi

# Install dependencies if necessary
hash ansible >/dev/null 2>&1 || pip install ansible --upgrade
# pip install redis --upgrade -q

export ANSIBLE_CONFIG="$ANSIBLE_CONFIG"

echo "NOTE: If you intend to use fish as your default shell, remember to do: " \
  "set -U fish_user_paths (brew --prefix coreutils)/libexec/gnubin /usr/local/bin \$HOME/.local/bin \$fish_user_paths or something similar"

ansible-galaxy install -r requirements.yml

ansible-playbook site.yml -t bootstrap

exit 0

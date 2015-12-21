#!/usr/bin/env bash

set -E

# Install dependencies if necessary
hash ansible >/dev/null 2>&1 || pip install ansible --upgrade
# pip install redis --upgrade -q

echo "NOTE: If you intend to use fish as your default shell, remember to do: " \
  "set -U fish_user_paths (brew --prefix coreutils)/libexec/gnubin /usr/local/bin \$HOME/.local/bin \$fish_user_paths or something similar"

ansible-playbook ansible.yml --ask-become-pass

ansible-galaxy install -r requirements.yml

ansible-playbook site.yml -t bootstrap

exit 0

#!/bin/sh

DOTFILES_BOOTSTRAP=false source ./bootstrap.sh

./fish.sh

command_is_executable "brew" \
    && command "${fish_path}" -c 'set -Ux HOMEBREW_AUTO_UPDATE_SECS 604800'


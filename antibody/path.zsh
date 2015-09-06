#!/usr/bin/env zsh

export ANTIBODY_HOME="${XDG_CONFIG_HOME}/antibody"
export ANTIBODY_BUNDLE_FILE=${ZSH}/antibody/bundles

# TODO: do not hardcode these:
if [[ "$OSTYPE" =~ ^(linux)+ ]]; then
  source "$HOME/.linuxbrew/share/antibody.zsh"
elif [[ "$OSTYPE" =~ ^(darwin)+ ]]; then
  source "/usr/local/share/antibody.zsh"
fi
  

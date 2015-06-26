#!/usr/bin/env zsh

#[[ "$OSTYPE" =~ ^(darwin)+ ]] && gopath="/usr/local" || gopath="${HOME}/.local"
#source "${gopath}/src/github.com/mkwmms/antibody.zsh"

export ANTIBODY_HOME="${XDG_CONFIG_HOME}/antibody"
export ANTIBODY_BUNDLE_FILE=${ZSH}/antibody/bundles
source "${ZSH}/antibody/antibody/antibody.zsh"

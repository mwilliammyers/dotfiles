#!/usr/bin/env bash
BASE_URL="https://github.com/caarlos0/antibody/releases/download"
VERSION="v0.2.1"
ARCH="386"
OS="$(uname -s | tr "[:upper:]" "[:lower:]")"
if [[ "$(uname -m)" = "x86_64" ]]; then
  ARCH="amd64"
fi
mkdir -p "${XDG_CONFIG_HOME}/dotfiles/antibody/antibody"
wget -O "${XDG_CACHE_HOME}/antibody.tar.gz" \
  "${BASE_URL}/${VERSION}/antibody_${OS}_${ARCH}.tar.gz"
tar xvzf "${XDG_CACHE_HOME}/antibody.tar.gz" -C "${XDG_CONFIG_HOME}/dotfiles/antibody/antibody"
rm -rf "${XDG_CACHE_HOME}/antibody.tar.gz"

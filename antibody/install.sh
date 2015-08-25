<<<<<<< HEAD
#!/usr/bin/env zsh

cd "${0%/*}"
source ../dotfiles.conf

set -e

antibody="github.com/mkwmms/antibody"
info "installing ${antibody}"

go get -v -a "${antibody}"
#rm -rf ${config_dir}/antibody/antibody/bin
mkdir -vp ${config_dir}/antibody/antibody/bin
[[ "$OSTYPE" =~ ^(darwin)+ ]] && gopath="/usr/local" || gopath="${HOME}/.local"
rsync -ahPEH --inplace ${gopath}/bin/antibody ${config_dir}/antibody/antibody/bin
rsync -ahPEH --inplace ${gopath}/src/github.com/mkwmms/antibody/antibody.zsh ${config_dir}/antibody/antibody

success "${antibody} installed"
unset gopath
unset antibody

exit 0;
=======
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
>>>>>>> 4e3961496f889a5590aa9fd33cf92c598f69e3e6

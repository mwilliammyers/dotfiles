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
rsync -ahPEHAX --inplace ${gopath}/bin/antibody ${config_dir}/antibody/antibody/bin
rsync -ahPEHAX --inplace ${gopath}/src/github.com/mkwmms/antibody/antibody.zsh ${config_dir}/antibody/antibody

success "${antibody} installed"
unset gopath
unset antibody

exit 0;

#!/bin/sh

if [ "$#" -ne 2 ]; then
  echo "Usage: decrypt.sh <IN> <OUT>" >&2
  return 1
fi

DOTFILES_BOOTSTRAP=false . ./bootstrap.sh

install_packages_if_necessary openssl

openssl aes-256-cbc -salt -a -d -in "${1}" -out "${2}"


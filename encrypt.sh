#!/bin/sh

if [ "$#" -ne 2 ]; then
  echo "Usage: encrypt.sh <IN> <OUT>" >&2
  return 1
fi

DOTFILES_BOOTSTRAP=false . ./bootstrap.sh

./gpg.sh

gpg --cipher-algo=AES256 --symmetric --output="${2}" "${1}"

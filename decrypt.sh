#!/bin/sh

if [ "$#" -ne 2 ]; then
  echo "Usage: decrypt.sh <IN> <OUT>" >&2
  return 1
fi

DOTFILES_BOOTSTRAP=false . ./bootstrap.sh

./gpg.sh

gpg --output="${2}" --decrypt "${1}"


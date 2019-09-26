#!/bin/sh

if [ "$#" -ne 2 ]; then
  echo "Usage: decrypt.sh <IN> <OUT>" >&2
  return 1
fi

DOTFILES_BOOTSTRAP=false . ./bootstrap.sh

package=gnupg
if ! command_is_executable gpg; then
    install_packages $package || die "Installing $package failed"
fi

gpg --output="${2}" --decrypt "${1}"


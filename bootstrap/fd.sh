#!/bin/sh

DOTFILES_BOOTSTRAP=false . "$(dirname "$0")/../bootstrap.sh"

package=fd
if [ -x "$(command -v apt-get)" ] || [ -x "$(command -v dnf)" ]; then
    package=fd-find
fi

if ! command_is_executable fd; then
    install_packages $package || die "Installing $package failed"
fi

# if [ -x "$(command -v fdfind)" ] && [ ! -x "$(command -v fd)" ]; then
#     if [ -x "$(command -v apt-get)" ]; then
#         sudo update-alternatives --install /usr/bin/fd fd "$(command -v fdfind)" 1
#     elif [ -x "$(command -v dnf)" ]; then
#         sudo alternatives --install /usr/bin/fd fd "$(command -v fdfind)" 1
#     fi
# fi

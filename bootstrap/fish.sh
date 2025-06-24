#!/bin/sh

DOTFILES_BOOTSTRAP=false . "$(dirname "$0")/../bootstrap.sh"

package="fish"

install_packages_if_necessary curl $package || die "Installing curl or ${package} failed"

fish_path=$(command -v fish)

login_shell="unknown"

if [ "$(uname -s)" = "Darwin" ]; then
    login_shell=$(finger "$USER" | perl -n -e'/.*Shell\:\s+(.*)/ && print $1')
elif [ "$(uname -s)" = "Linux" ]; then
    login_shell=$(getent passwd "$LOGNAME" | cut -d: -f7)
fi

if ! [ "$login_shell" = "$fish_path" ]; then
    info "Changing the login shell to fish..."
    sudo chsh -s "${fish_path}" "$USER"
else
    info "The login shell is already fish"
fi

info "Installing fisher..."
command "${fish_path}" \
    -c 'curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher' \
    || die "Installing fisher failed"

# TODO: use fishfile?
# some of these, e.g. starship install the package
command "${fish_path}" \
    -c 'fisher install \
            mwilliammyers/starship \
            mwilliammyers/pack \
            mwilliammyers/handy \
            mwilliammyers/j \
            jethrokuan/fzf \
            patrickf3139/Colored-Man-Pages'

command_is_executable "gcloud" && command "${fish_path}" -c 'fisher install mwilliammyers/google-cloud-sdk'

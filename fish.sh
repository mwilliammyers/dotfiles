#!/bin/sh

DOTFILES_BOOTSTRAP=false . ./bootstrap.sh

package="fish"

install_packages_if_necessary "${package}" || die "Installing ${package} failed"

fish_path=$(command -v fish)

login_shell="unknown"
if [ "$(uname -s)" = "Darwin" ]; then
    login_shell="$(finger $USER | perl -n -e'/.*Shell\:\s+(.*)/ && print $1')"
elif [ "$(uname -s)" = "Linux" ]; then
    login_shell="$(getent passwd $LOGNAME | cut -d: -f7)"
fi

if ! [ "$login_shell" = "$fish_path" ]; then
    info "Changing the login shell to fish..."
    sudo chsh -s "${fish_path}"  $USER
else
    info "The login shell is already fish"
fi

# TODO: handle Linux mountpoints
if [ "$(uname -s)" = "Darwin" ]; then
    # TODO: check if file exists first?
    cp -fr "/Volumes/config/$USER/.local/share/fish" ~/.local/share/ 2>/dev/null
fi

info "Installing fisher..."
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish \
    || die "Installing fisher failed"

# TODO: use fishfile?
command "${fish_path}" -c 'fisher add \
    mwilliammyers/pack \
    mwilliammyers/handy \
    mwilliammyers/google-cloud-sdk \
    mwilliammyers/j \
    jethrokuan/fzf \
    rafaelrinaldi/pure \
    patrickf3139/Colored-Man-Pages'

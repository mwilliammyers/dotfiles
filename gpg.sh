#!/bin/sh

DOTFILES_BOOTSTRAP=false . ./bootstrap.sh 

package=gnupg
if ! command_is_executable gpg; then
    install_packages $package || die "Installing $package failed"
fi

if [ "$(uname -s)" = "Darwin" ]; then
    package=pinentry-mac
    if ! command_is_executable $package; then
        install_packages $package || die "Installing $package failed"
       
        # https://dev.to/wes/how2-using-gpg-on-macos-without-gpgtools-428f
        mkdir ~/.gnupg/ 2> /dev/null
        # TODO: should we store this file in ./config ?
        echo 'pinentry-program /usr/local/bin/pinentry-mac' >> ~/.gnupg/gpg-agent.conf   
        
        gpgconf --kill gpg-agent
    fi
fi

# https://www.gnupg.org/faq/whats-new-in-2.1.html#ecc
# https://github.com/NicoHood/gpgit#12-key-generation
# https://lists.gnupg.org/pipermail/gnupg-users/2017-December/059622.html

user="${GPG_USER:-William Myers <mwilliammyers@gmail.com>}"

# `--quick-generate-key` will exit 2 if user_id already has a key
if gpg --quick-generate-key "$user" future-default default 0; then
    if [ -x "$(command -v pbcopy)" ]; then
        gpg --armor --export "$user" | pbcopy
    elif [ -x "$(command -v xsel)" ]; then
        gpg --armor --export "$user" | xsel -ib
    fi

    info "Attempting to open browser; check clipboard for GPG public key..."
    if [ -x "$(command -v open)" ]; then
        open "https://github.com/settings/gpg/new"
    elif [ -x "$(command -v xdg-open)" ]; then
        xdg-open "https://github.com/settings/gpg/new"
    fi
fi

if command_is_executable git; then
    key_id=$(gpg --list-secret-keys --keyid-format LONG --with-colons "$user" | awk -F: '/^sec:/ { print $5 }')
    
    git config --global commit.gpgsign true
    git config --global user.signingkey "$key_id"
fi


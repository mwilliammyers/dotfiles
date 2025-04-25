#!/bin/sh

DOTFILES_BOOTSTRAP=false . "$(dirname "$0")/../bootstrap.sh" 

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
    os_copy_to_clipboard $(gpg --armor --export "$user")
    os_open "https://github.com/settings/gpg/new"
fi

if command_is_executable git; then
    # git figures out which key to use for signing based on user.email config
    git config --global commit.gpgsign true
fi


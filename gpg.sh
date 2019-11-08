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

# gpg --list-secret-keys | wc -l | grep -q 0
# cat >keyconfig <<EOF
#     %echo Generating a basic OpenPGP key
#     Key-Type: eddsa
#     Key-Curve: Ed25519
#     Key-Usage: sign
#     Subkey-Type: ecdh
#     Subkey-Curve: Curve25519
#     Subkey-Usage: encrypt
#     Name-Real: William Myers
#     Name-Email: mwilliammyers@gmail.com
#     Expire-Date: 0

#     %ask-passphrase

#     %commit
#     %echo done
# EOF

# gpg --batch --generate-key keyconfig

# https://www.gnupg.org/faq/whats-new-in-2.1.html#ecc
# https://github.com/NicoHood/gpgit#12-key-generation
# https://lists.gnupg.org/pipermail/gnupg-users/2017-December/059622.html

# `--quick-generate-key` will exit 2 if user_id already has a key
if gpg --quick-generate-key "William Myers <mwilliammyers@gmail.com>" future-default default 0; then
    key_id="$(gpg --list-secret-keys --keyid-format LONG --with-colons | awk -F: '/^sec:/ { print $5 }')"

    if [ -x "$(command -v pbcopy)" ]; then
        gpg --armor --export "$key_id" | pbcopy
    elif [ -x "$(command -v xsel)" ]; then
        gpg --armor --export "$key_id" | xsel -ib
    fi

    info "Attempting to open browser; check clipboard for GPG public key..."

    open "https://github.com/settings/gpg/new"

    if command_is_executable git; then
        git config --global commit.gpgsign true
        # git config --global user.signingkey "$key_id"
    fi
fi

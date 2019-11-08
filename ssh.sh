#!/bin/sh

DOTFILES_BOOTSTRAP=false . ./bootstrap.sh 

mkdir ~/.ssh/ 2> /dev/null

# TODO: be smarter about this check...
if [ ! -e ~/.ssh/config ]; then
    info "Configuring ssh..."
    ./decrypt.sh ./secrets/ssh/config  ~/.ssh/config

fi

if [ ! -e ~/.ssh/id_rsa ]; then
    # TODO: get these from git config
    username=mwilliammyers
    email="$username@gmail.com"

    # TODO: or should we decrypt an existing private key?
    info "Generating new ssh key pair..."
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -C "$email"
    
    ssh-add -K ~/.ssh/id_rsa

    # TODO: should we always do the rest of this?

    pub_key="$(cat ~/.ssh/id_rsa.pub)"

    info "Uploading public key to known hosts..."
    for host in $(grep -E '^Host\s+' ~/.ssh/config | sed 's/Host//g' | sed 's/^[ \t]*//'); do
        echo "$pub_key" \
            | ssh "$host" 'umask 0077; mkdir -p .ssh; cat >> .ssh/authorized_keys'
    done
    
    # TODO: handle https://developer.github.com/v3/auth/#working-with-two-factor-authentication
    info "Uploading public key to GitHub..."
    title="$(hostname | sed 's/.local//' | sed 's/.home//')"
    curl -u "$email" \
        --data "{\"title\": \"$title\", \"key\": \"$pub_key\"}" \
        https://api.github.com/user/keys

    if [ -x "$(command -v gcloud)" ]; then
        if [ -x "$(command -v pbcopy)" ]; then
            echo "$key" | pbcopy
        elif [ -x "$(command -v pbcopy)" ]; then
            echo "$key" | xsel -ib
        fi

        info "Attempting to open browser; check clipboard for public keys..."

        # TODO: does this work on Linux?
        open 'https://console.cloud.google.com/compute/metadata/sshKeys?pli=1'

        # TODO: is an API available for this? does this work on Linux?
        open 'https://source.cloud.google.com/user/ssh_keys?register=true'
    fi
fi

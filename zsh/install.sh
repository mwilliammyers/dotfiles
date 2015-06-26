#!/usr/bin/env zsh

cd "${0%/*}"
source ../dotfiles.conf;

set -e

linkZsh() {
    info "linking zsh files"
    linkFiles "${zsh_src}" "${zsh_dst}"
    success "zsh files linked"
}

# MAIN #########################################################################
deps=( "fasd" "grc" )
checkDependencies ${deps[@]}

linkZsh

source ${zsh_dst}/.zshrc

cleanupPATH

exportedPaths=( "${XDG_DATA_HOME}" )
createPaths ${exportedPaths[@]}

exit 0;

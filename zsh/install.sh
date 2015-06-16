#!/usr/bin/env zsh

cd "${0%/*}"
source ../dotfiles.conf;

set -e

linkAntibody() {
    #TODO: add? sharat87/zsh-vim-mode akoenig/gulp-autocompletion-zsh
    info "linking antibody config files"
    linkFiles "${antibody_src}" "${antibody_dst}"
    [[ "$OSTYPE" =~ ^(linux)+ ]] &&  ln -sf ~/.local/bin/antibody ~/.config/antibody/antibody #XXX
    [[ "$OSTYPE" =~ ^(darwin)+ ]] &&  ln -sf /usr/local/bin/antibody ~/.config/antibody/antibody #XXX
    success "antibody config files linked"
}

linkZsh() {
    info "linking zsh files"
    linkFiles "${zsh_src}" "${zsh_dst}"
    success "zsh files linked"
}

# MAIN #########################################################################
paths=( "${ZDOTDIR}" "${antibody_config_dst}" ) 
createPaths ${paths[@]}

deps=( "fasd" "grc" )
checkDependencies ${deps[@]}

linkZsh
linkAntibody

source ${zsh_dst}/.zshrc

cleanupPATH

exportedPaths=( "${XDG_DATA_HOME}" )
createPaths ${exportedPaths[@]}

exit 0;

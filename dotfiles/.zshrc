#!/usr/bin/env zsh

# XDG settings
if [[ "$OSTYPE" =~ ^(darwin)+ ]]; then
    # export XDG_CONFIG_HOME="${HOME}/Library/Mobile Documents/com~apple~CloudDocs/.config"
    export XDG_CACHE_HOME="/Library/Caches"
    # export XDG_DATA_HOME="/usr/local/share"
    # export XDG_BIN_HOME="/usr/local/bin"
else
    export XDG_CACHE_HOME="${HOME}/.cache"
fi
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_BIN_HOME="${HOME}/.local/bin"

PROFILE_STARTUP=false
if [[ "$PROFILE_STARTUP" == true ]]; then
    zmodload zsh/zprof # Output time statistics
    # http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
    PS4=$'%D{%M%S%.} %N:%i> '
    exec 3>&2 2>"${XDG_CACHE_HOME:-$HOME/tmp}/.zsh_statup.$$"
    setopt xtrace prompt_subst
fi

# Root dir of dotfiles repo
export ZSH=${XDG_CONFIG_HOME}/dotfiles

# all of our zsh files
typeset -U config_files
config_files=( $ZSH/**/*.zsh )

# load the path files
for file in ${(M)config_files:#*/path.zsh}; do
  source "$file"
done

# setup antibody
antibody bundle < "${ANTIBODY_BUNDLE_FILE}"

# load everything but the path and completion files
for file in ${${config_files:#*/path.zsh}:#*/completion.zsh}; do
  source "$file"
done

# initialize autocomplete here, otherwise functions won't be loaded
autoload -U compinit
compinit -i -d ${ZSH_COMPDUMP}

# load every completion after autocomplete loads
for file in ${(M)config_files:#*/completion.zsh}; do
  source "$file"
done

unset config_files

[[ -e ${XDG_CONFIG_HOME}/.localrc ]] && source ${XDG_CONFIG_HOME}/.localrc

eval $(dircolors -b "${XDG_CONFIG_HOME}/dotfiles/dircolors/LS_COLORS")

# TODO: figure out why specifying this in the bundle file causes everything to explode
antibody bundle mkwmms/zsh-fasd
export REPO_URI='https://github.com/mkwmms/spf13-vim.git'

if [[ "$PROFILE_STARTUP" == true ]]; then
    zprof
    unsetopt xtrace
    exec 2>&3 3>&-
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

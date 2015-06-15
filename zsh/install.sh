#!/usr/bin/env bash

cd "${0%/*}"
source ../dotfiles.conf;

set -e

if [ ! -n "$ZSH" ]; then
  ZSH="${zsh_dst}"
fi

makeZshrc(){
    echo -e "${color}Making ${zshrc} file...${reset}"
    [ -e "${zshrc}" ] &&  mv "${zshrc}" ${ZDOTDIR:-${HOME}}/.zshrc.orig
    touch "${zshrc}"

cat <<EOF >> "${zshrc}"
## XDG settings ##################################
export XDG_CACHE_HOME=~/.cache
export XDG_DATA_HOME=~/.local/share
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME}

## ZSH settings ####################################
#export ZDOTDIR="\${XDG_CONFIG_HOME}/zsh" # exported in /etc/zshenv
export ZSH=${ZSH}
export ZSHRC=${zshrc}
export HISTFILE="${ZDOTDIR:-${HOME}}/.zsh_history"

export ANTIBODY_HOME="\${XDG_CONFIG_HOME}/antibody"

## EXPORTS ############################################
export _FASD_DATA="\${XDG_DATA_HOME}/fasd/fasd_data"
export GENCOMPL_FPATH=\$ZSH/completions

export PATH="$(brew --prefix)/bin:$(brew --prefix)/sbin:$PATH"
export MANPATH="$(brew --prefix)/share/man:$MANPATH"
export INFOPATH="$(brew --prefix)/share/info:$INFOPATH"

export PYTHONSTARTUP="\${XDG_CONFIG_HOME}/python/pythonrc.py"
export ECLIMSTARTUP="\${XDG_CONFIG_HOME}/eclim/eclimrc"
export CURL_HOME="\${XDG_CONFIG_HOME}/curl"

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Preferred editor for local and remote sessions
# if [[ -n \$SSH_CONNECTION ]]; then
#   export EDITOR='nvim'
# else
#   export EDITOR='nvim'
# fi

# Make vim the default editor.
export EDITOR='nvim';

# Omit duplicates and commands that begin with a space from history.
export HISTCONTROL='ignoreboth';

# Prefer US English and use UTF-8.
export LANG='en_US.UTF-8';
export LC_ALL='en_US.UTF-8';

export TERM="xterm-256color"

# Don’t clear the screen after quitting a manual page.
export MANPAGER='less -X';

# Always enable colored \`grep\` output.
export GREP_OPTIONS='--color=auto';

# Display correct tmux window titles
#export DISABLE_AUTO_TITLE=true

source \${ANTIBODY_HOME}/antibody.zsh
antibody bundle zsh-users/zsh-syntax-highlighting
source $(brew --prefix)/etc/grc.bashrc

fpath=(\$ZSH \$ZSH/completions \$fpath)

## OS specific settings ############################
autoload -U compinit && compinit
EOF

if [[ "$OSTYPE" =~ ^(linux)+ ]]; then
# TODO: detect linux flavor with cat /etc/issue ? in order to load debian plugin
cat <<EOF >> "${zshrc}"
export ANTIBODY_BUNDLE_FILE=\${ANTIBODY_HOME}/bundles.linux
antibody bundle < \${ANTIBODY_BUNDLE_FILE}
EOF
elif [[ "$OSTYPE" =~ ^(darwin)+ ]]; then
cat <<EOF >> "${zshrc}"
export ANTIBODY_BUNDLE_FILE=\${ANTIBODY_HOME}/bundles.osx
antibody bundle < \${ANTIBODY_BUNDLE_FILE}
export HOMEBREW_CASK_OPTS='--appdir=/Applications --caskroom=$(brew --prefix)/Caskroom'
export ECLIPSE_HOME="$(brew --prefix)/Caskroom/eclipse-java/\$(ls -t $(brew --prefix)/Caskroom/eclipse-java | head -n 1)/eclipse"
EOF
fi

cat <<EOF >> "${zshrc}"
# Plugin settings ################################
for configFile in \${ZSH}/* ; do
    source \${configFile}
done

# autosuggestions settings ##########
# Enable autosuggestions automatically.
zle-line-init() {
    zle autosuggest-start
}
zle -N zle-line-init
export AUTOSUGGESTION_HIGHLIGHT_CURSOR=1
export AUTOSUGGESTION_HIGHLIGHT_COLOR='fg=240'
export AUTOSUGGESTION_ACCEPT_RIGHT_ARROW=1

# zsh-history-substring-search ######
# bind UP and DOWN arrow keys
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# bind UP and DOWN arrow keys (compatibility fallback
# for Ubuntu 12.04, Fedora 21, and MacOSX 10.9 users)
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# bind P and N for EMACS mode
bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down

# bind k and j for VI mode
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
EOF
}

[ -n "${ZDOTDIR}" ] && mkdir -p "${ZDOTDIR}"
[ -n "${ZSH}" ] && mkdir -p "${ZSH}"
[ -n "${antibody_config_dst}" ] && mkdir -p "${antibody_config_dst}"

linkZsh() {
    echo -e "${color}Linking zsh...${reset}"
    ln -sfv "${zsh_src}"/*.zsh "${ZSH}"
    ln -sfv "${zsh_src}"/functions/* "${ZSH}"
}

linkAntibody() {
    #TODO: add? sharat87/zsh-vim-mode akoenig/gulp-autocompletion-zsh
    echo -e "${color}Linking antibody config files...${reset}"
    ln -sfv "${antibody_config_src}"/* "${antibody_config_dst}"
}

#TODO: check if brew is installed first
[ -z "$(command -v fasd)" ] && brew install fasd
[ -z "$(command -v grc)" ] && brew install grc

makeZshrc
linkZsh
linkAntibody

source ${zshrc}

cleanupPath # defined in functions.zsh file

exit 0;

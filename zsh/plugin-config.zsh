# Plugin settings ################################
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
bindkey "[kcuu1]" history-substring-search-up
bindkey "[kcud1]" history-substring-search-down

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

export ZSH_PLUGINS_ALIAS_TIPS_TEXT="Alias tip: "


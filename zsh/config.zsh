#!/usr/bin/env zsh

export LSCOLORS='exfxcxdxbxegedabagacad'
export CLICOLOR=true

fpath=($ZSH/functions $fpath)

autoload -U "$ZSH"/functions/*(:t)

export HISTFILE="${XDG_DATA_HOME:-${HOME}}/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

# don't nice background tasks
setopt NO_BG_NICE
setopt NO_HUP
setopt NO_LIST_BEEP
# allow functions to have local options
setopt LOCAL_OPTIONS
# allow functions to have local traps
setopt LOCAL_TRAPS
# share history between sessions ???
setopt SHARE_HISTORY
# add timestamps to history
# setopt EXTENDED_HISTORY
#setopt PROMPT_SUBST
#setopt CORRECT
#setopt IGNORE_EOF
# adds history
setopt APPEND_HISTORY
# adds history incrementally and share it across sessions
setopt INC_APPEND_HISTORY SHARE_HISTORY
# don't record dupes in history
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt HIST_EXPIRE_DUPS_FIRST
# dont ask for confirmation in rm globs*
# setopt RM_STAR_SILENT

zle -N newtab

if [[ ! -z "$+terminfo[smkx]" ]] && [[ ! -z "$+terminfo[rmkx]" ]]; then
  function zle-line-init() {
    echoti smkx
    #zle autosuggest-start
  }
  function zle-line-finish() {
    echoti rmkx
  }
  zle -N zle-line-init
  zle -N zle-line-finish
fi

# Key bindings ###################################
# Use emacs key bindings
bindkey -e

# [Ctrl-r] - Search backward incrementally for a specified string.
# The string may begin with ^ to anchor the search to the beginning of the line.
bindkey '^r' history-incremental-search-backward
# [PageUp] - Up a line of history
if [[ ! -z "$terminfo[kpp]" ]]; then
  bindkey "$terminfo[kpp]" up-line-or-history
fi
# [PageDown] - Down a line of history
if [[ ! -z "$terminfo[knp]" ]]; then
  bindkey "$terminfo[knp]" down-line-or-history
fi
# start typing + [Up-Arrow] - fuzzy find history forward
if [[ ! -z "$terminfo[kcuu1]" ]]; then
  bindkey "$terminfo[kcuu1]" history-substring-search-up
  bindkey -M vicmd 'k' history-substring-search-up
  bindkey -M emacs '^P' history-substring-search-up
  # for Ubuntu 12.04, Fedora 21, and MacOSX 10.9 users)
  #bindkey '^[[A' history-substring-search-up
fi
# start typing + [Down-Arrow] - fuzzy find history backward
if [[ ! -z "$terminfo[kcud1]" ]]; then
  bindkey "$terminfo[kcud1]" history-substring-search-down
  bindkey -M vicmd 'j' history-substring-search-down
  bindkey -M emacs '^N' history-substring-search-down
  # for Ubuntu 12.04, Fedora 21, and MacOSX 10.9 users)
  #bindkey '^[[B' history-substring-search-down
fi
if [[ ! -z "$terminfo[khome]" ]]; then
  # [Home] - Go to beginning of line
  bindkey "$terminfo[khome]" beginning-of-line
  # OPTION+left
  bindkey '[D' beginning-of-line
fi
if [[ ! -z "$terminfo[kend]" ]]; then
  # [End] - Go to end of line
  bindkey "$terminfo[kend]"  end-of-line
  # OPTION+right
  bindkey '[C' end-of-line
fi

# [Ctrl-RightArrow] - move forward one word
bindkey '^[[1;5C' forward-word
# [Ctrl-LeftArrow] - move backward one word
bindkey '^[[1;5D' backward-word
# [Shift-Tab] - move through the completion menu backwards
if [[ ! -z "$terminfo[kcbt]" ]]; then
  bindkey "$terminfo[kcbt]" reverse-menu-complete
fi
# [Backspace] - delete backward
bindkey '^?' backward-delete-char
# [Delete] - delete forward
if [[ ! -z "$terminfo[kdch1]" ]]; then
  bindkey "$terminfo[kdch1]" delete-char
else
  bindkey "^[[3~" delete-char
  bindkey "^[3;5~" delete-char
  bindkey "\e[3~" delete-char
fi

# Plugin settings ################################
export ZSH_PLUGINS_ALIAS_TIPS_TEXT="Alias tip: "

export GENCOMPL_FPATH=${XDG_DATA_HOME:-${HOME}}/.completions

# autosuggestions settings ##########
export AUTOSUGGESTION_HIGHLIGHT_CURSOR=1
export AUTOSUGGESTION_HIGHLIGHT_COLOR='fg=240'
export AUTOSUGGESTION_ACCEPT_RIGHT_ARROW=1

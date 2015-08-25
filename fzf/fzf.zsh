fzf_home="$XDG_DATA_HOME/vim/plugged/fzf"
# Setup fzf
# ---------
if [[ ! "$PATH" =~ "$fzf_home/bin" ]]; then
  export PATH="$PATH:$fzf_home/bin"
fi

# Man path
# --------
if [[ ! "$MANPATH" =~ "$fzf_home/man" && -d "$fzf_home/man" ]]; then
  export MANPATH="$MANPATH:$fzf_home/man"
fi

# Auto-completion
# ---------------
[[ $- =~ i ]] && source "$fzf_home/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "$fzf_home/shell/key-bindings.zsh"

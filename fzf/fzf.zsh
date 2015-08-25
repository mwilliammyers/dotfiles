# Setup fzf
# ---------
if [[ ! "$PATH" =~ "$HOME/.vim/plugged/fzf/bin" ]]; then
  export PATH="$PATH:$HOME/.vim/plugged/fzf/bin"
fi

# Man path
# --------
if [[ ! "$MANPATH" =~ "$HOME/.vim/plugged/fzf/man" && -d "$HOME/.vim/plugged/fzf/man" ]]; then
  export MANPATH="$MANPATH:$HOME/.vim/plugged/fzf/man"
fi

# Auto-completion
# ---------------
[[ $- =~ i ]] && source "$HOME/.vim/plugged/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "$HOME/.vim/plugged/fzf/shell/key-bindings.zsh"

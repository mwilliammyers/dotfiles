# Setup fzf
# ---------
if [[ ! "$PATH" =~ "/Users/wm/.vim/plugged/fzf/bin" ]]; then
  export PATH="$PATH:/Users/wm/.vim/plugged/fzf/bin"
fi

# Man path
# --------
if [[ ! "$MANPATH" =~ "/Users/wm/.vim/plugged/fzf/man" && -d "/Users/wm/.vim/plugged/fzf/man" ]]; then
  export MANPATH="$MANPATH:/Users/wm/.vim/plugged/fzf/man"
fi

# Auto-completion
# ---------------
[[ $- =~ i ]] && source "/Users/wm/.vim/plugged/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/Users/wm/.vim/plugged/fzf/shell/key-bindings.zsh"


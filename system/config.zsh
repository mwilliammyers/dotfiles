#!/usr/bin/env zsh

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='vim'
fi

# Omit duplicates and commands that begin with a space from history.
export HISTCONTROL='ignoreboth';

# Prefer US English and use UTF-8.
export LANG='en_US.UTF-8';
export LC_ALL='en_US.UTF-8';

export TERM="xterm-256color"

# Don’t clear the screen after quitting a manual page.
export MANPAGER='less -X';

# Always enable colored `grep` output.
export GREP_OPTIONS='--color=auto';

# Display correct tmux window titles
#export DISABLE_AUTO_TITLE=true

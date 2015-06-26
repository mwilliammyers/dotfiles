#!/usr/bin/env bash
# shellcheck disable=SC2039

alias sudo='nocorrect sudo'

# Easier navigation: .., ..., ...., ....., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ~="cd ~" # `cd` is probably faster to type though
alias -- -="cd -"

# Shortcuts
alias dl="cd ~/Downloads"
alias dt="cd ~/Desktop"
alias h="history"
alias jb="jobs"

# grc overides for ls
#   Made possible through contributions from generous benefactors like
#   `brew install coreutils`
if hash gls &>/dev/null; then
  alias ls="gls -F --color"
  alias l="gls -Ah --color"
  alias ll="gls -l --color"
  alias la="gls -lA --color"
  alias ldot='gls -ld .* --color'
else
  alias ls="ls -F --color"
  alias l="ls -Ah --color"
  alias ll="ls -l --color"
  alias la="ls -lA --color"
  alias ldot='ls -ld .* --color'
fi

alias grep="grep --color=auto"
alias duf="du -sh * | sort -hr"
alias less="less -r"

#if [ -z "$(command -v pbcopy)" ]; then
  #if [ -n "$(command -v xclip)" ]; then
    #alias pbcopy="xclip -selection clipboard"
    #alias pbpaste="xclip -selection clipboard -o"
  #elif [ -n "$(command -v xsel)" ]; then
    #alias pbcopy="xsel --clipboard --input"
    #alias pbpaste="xsel --clipboard --output"
  #fi
#fi

if [[ "$OSTYPE" =~ ^(linux)+ ]]; then
  if hash xdg-open &>/dev/null; then
    alias open="xdg-open"
  fi
  alias sage='pkill -f ssh-agent -u $(id -u $USER); eval "$(ssh-agent -s -t 10800)" && ssh-add ~/.ssh/id_github'
fi

# greps non ascii chars
nonascii() {
  LANG=C grep --color=always '[^ -~]\+';
}

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"

# Get week number
alias week='date +%V'

# Stopwatch
alias timer='echo "Timer started. Stop with Ctrl-D." && date && time cat && date'

alias which='which -a'

# sudo visudo & add:
# username ALL=NOPASSWD: /usr/local/bin/htop
alias htop='sudo htop'

# Reload the shell (i.e. invoke as a login shell)
alias reload="exec $SHELL -l && cleanupPath" # cleanupPath defined in functions.zsh

# Command aliases
alias taa='tmux a'
alias nvim='nocorrect nvim'
alias zshrc='nvim ${ZSHRC}'
alias speed='speedtest_cli'

if [ -e "${ECLIPSE_HOME}/eclimd" ]; then
  # Start the eclim deamon
  alias start_eclimd='$ECLIPSE_HOME/eclimd -f ${ECLIMSTARTUP} &> /dev/null &'

  # Stop the eclim deamon
  alias stop_eclimd='$ECLIPSE_HOME/eclim -f ${ECLIMSTARTUP} -command shutdown'
fi

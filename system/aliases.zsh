#!/usr/bin/env bash

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

# Command aliases
alias nvim='nocorrect nvim'
alias zshrc='${EDITOR} ${ZSHRC}'
alias speed='speedtest_cli'
# sudo visudo & add:
# username ALL=NOPASSWD: /usr/local/bin/htop
alias htop='sudo htop'
alias grep="grep --color=auto"
alias duf="du -sh * | sort -hr"
alias less="less -r"

# greps non ascii chars
nonascii() {
  LANG=C grep --color=always '[^ -~]\+';
}

if [[ "$OSTYPE" =~ ^(linux)+ ]]; then
  if hash xdg-open &>/dev/null; then
    alias open="xdg-open"
  fi

  if hash xclip &>/dev/null; then
    alias pbcopy="xclip -selection clipboard"
    alias pbpaste="xclip -selection clipboard -o"
  elif hash xsel &>/dev/null; then
    alias pbcopy="xsel --clipboard --input"
    alias pbpaste="xsel --clipboard --output"
  fi

  alias sage='pkill -f ssh-agent -u $(id -u $USER); eval "$(ssh-agent -s -t 10800)" && ssh-add ~/.ssh/id_github'

  alias target='gcc -march=native -Q --help=target'
  alias march='gcc -march=native -Q --help=target | grep march --color=NEVER'
  alias avx='gcc -march=native -Q --help=target | grep avx --color=NEVER'
fi

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"

# Get week number
alias week='date +%V'

# Stopwatch
alias timer='echo "Timer started. Stop with Ctrl-D." && date && time cat && date'

# Reload the shell (i.e. invoke as a login shell)

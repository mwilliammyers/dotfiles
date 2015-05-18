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

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"

alias sudo='nocorrect sudo'

# Get week number
alias week='date +%V'

# Stopwatch
alias timer='echo "Timer started. Stop with Ctrl-D." && date && time cat && date'

alias which='which -a'

alias speed='speedtest_cli'

# sudo visudo & add:
# username ALL=NOPASSWD: /usr/local/bin/htop
alias htop='sudo htop'

# Reload the shell (i.e. invoke as a login shell)
alias reload="exec $SHELL -l"

# Start the eclim deamon
alias start_eclimd='$ECLIPSE_HOME/eclimd &'

# Stop the eclim deamon
alias stop_eclimd='$ECLIPSE_HOME/eclim -command shutdown'

alias bcl='rm -rf $(brew --cache)/*'

alias sage='pkill -f ssh-agent -u $(id -u $USER); eval "$(ssh-agent -s -t 10800)" && ssh-add ~/.ssh/id_github'

alias taa='tmux a'

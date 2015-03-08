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

# Enable aliases to be sudo’ed
alias sudo='sudo '

# Get week number
alias week='date +%V'

# Stopwatch
alias timer='echo "Timer started. Stop with Ctrl-D." && date && time cat && date'

alias which='which -a'

alias speed='speedtest_cli'

alias brewup='brew update && brew upgrade && brew doctor'

# sudo visudo & add:
# username ALL=NOPASSWD: /usr/local/bin/htop
alias htop='sudo htop'

# Reload the shell (i.e. invoke as a login shell)
alias reload="exec $SHELL -l"

# Start the eclim deamon
alias eclimd='$ECLIPSE_HOME/eclimd &'

# Stop the eclim deamon
alias seclimd='$ECLIPSE_HOME/eclim -command shutdown'

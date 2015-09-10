#!/usr/bin/env zsh

## ZSH settings ####################################
export ZSHRC=$HOME/.zshrc
export ZSH_COMPDUMP="$XDG_DATA_HOME/zsh/zcompdump-${HOST/.*/}"

## EXPORTS ############################################
export _FASD_DATA="$XDG_DATA_HOME/fasd"

export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc.py"
export CURL_HOME="$XDG_CONFIG_HOME/curl"
# export ATOM_HOME="$XDG_CONFIG_HOME/atom"

## OS specific settings ############################
if [[ "$OSTYPE" =~ ^(linux)+ ]]; then
  homebrew_prefix="$HOME/.local/fslbuild"
  linuxbrew_prefix="$HOME/.local/linuxbrew"

  default_path="/usr/local/cuda/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin:/opt/ganglia/bin:/opt/ganglia/sbin:/opt/ibutils/bin:/usr/java/latest/bin:/opt/rocks/bin:/opt/rocks/sbin:/opt/dell/srvadmin/bin"
  # default_path="$PATH"
  export PATH="$homebrew_prefix/bin:$homebrew_prefix/sbin:$linuxbrew_prefix/opt/go/libexec/bin:$XDG_BIN_HOME:$default_path"
  default_manpath="/usr/man:/usr/share/man:/usr/local/man:/usr/local/share/man:/usr/X11R6/man:/opt/rocks/man:/usr/java/latest/man:/usr/java/jdk1.5/man"
  export MANPATH="$XDG_DATA_HOME/man:$homebrew_prefix/share/man:$homebrew_prefix/share/man:$default_manpath"
  export INFOPATH="$XDG_DATA_HOME/info:$homebrew_prefix/share/info"

  export HOMEBREW_DEVELOPER=true
  export HOMEBREW_TEMP="/dev/shm"
  brew() {
    export HOMEBREW_CELLAR="/apps"
    export HOMEBREW_CACHE="/apps/src"
    export HOMEBREW_LOGS="/apps/src"
    export HOMEBREW_TAP_USE_SSH=true
    "$homebrew_prefix/bin/brew" $@
    unset HOMEBREW_CELLAR HOMEBREW_CACHE HOMEBREW_LOGS HOMEBREW_TAP_USE_SSH
  }
  lbrew() {
    export HOMEBREW_CACHE="$XDG_CACHE_HOME/Homebrew"
    export HOMEBREW_LOGS="$XDG_DATA_HOME/Homebrew"
    export HOMEBREW_BREW_FILE="$linuxbrew_prefix/bin/linuxbrew"
    "$linuxbrew_prefix/bin/linuxbrew" $@
    unset HOMEBREW_CACHE HOMEBREW_BREW_FILE
  }

  export GOPATH="$XDG_BIN_HOME"
  export PYENV_ROOT="$linuxbrew_prefix/var/pyenv"
  export R_LIBS="$XDG_DATA_HOME/lib/r"
  export PERL_CPANM_HOME="/apps/perlmodules/hcpanm"

  source /usr/share/Modules/init/zsh
  # source ~/.modules
  module load "$XDG_CONFIG_HOME/modules/linuxbrew"
elif [[ "$OSTYPE" =~ ^(darwin)+ ]]; then
  local homebrew_prefix="/usr/local" # faster than $(brew --prefix)

  export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin:/Users/wm/bin:/usr/local/libexec/gnubin:/opt/local/bin:/opt/local/sbin:/usr/local/opt/go/libexec/bin"
  export MANPATH="/usr/local/share/man:/usr/share/man"

  export HOMEBREW_CASK_OPTS="--appdir=/Applications --caskroom=$homebrew_prefix/Caskroom"
  export ECLIMSTARTUP="$XDG_CONFIG_HOME/eclim/eclimrc"
  export ECLIPSE_HOME="$homebrew_prefix/Caskroom/eclipse-java/$(ls -t $homebrew_prefix/Caskroom/eclipse-java | head -n 1)/eclipse"
  export GOPATH="$homebrew_prefix"
fi

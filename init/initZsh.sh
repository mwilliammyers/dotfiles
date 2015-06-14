#!/usr/bin/env bash

cd "${0%/*}"
cd .. && source dotfiles.conf;
cd "${init}"

set -e

if [ ! -n "$ZSH" ]; then
  ZSH="${zsh_dst}"
fi

dedupepath(){
    if [ -n "$PATH" ]
    then
        old_PATH=$PATH:
        PATH=
        while [ -n "$old_PATH" ]
        do
            x=${old_PATH%%:*}
            case $PATH: in
                (*:"$x":*)  ;;
                (*) PATH=$PATH:$x  ;;
            esac
            old_PATH=${old_PATH#*:}
        done
        PATH=${PATH#:}
        unset old_PATH x
    fi
}

makeZshrc(){
    echo -e "${color}Making ${zshrc} file...${reset}"
    [ -e "${zshrc}" ] &&  mv "${zshrc}" ${ZDOTDIR:-${HOME}}/.zshrc.orig
    touch "${zshrc}"
    echo "## OS specific settings ############################" >> ${zshrc}
    # TODO: add profiles, rsync, ant, atom, autoenv, vim-interaction, virtualenv, command-not-found, dirhistory, & all the git plugins ???
    if [[ "$OSTYPE" =~ ^(linux)+ ]]; then
        # TODO: detect linux flavor with cat /etc/issue ? in order to load debian plugin
        echo plugins=\(git git-extras brew sudo tmux colored-man extract zsh_reload common-aliases fasd debian\) >> ${zshrc}
    # TODO: test for homebrew... 
        # echo "export HOMEBREW_CASK_OPTS' --appdir=~/Applications --caskroom=$(brew --prefix)/Caskroom'" >> ${zshrc}
        module purge
    elif [[ "$OSTYPE" =~ ^(darwin)+ ]]; then
        echo plugins=\(git git-extras brew sudo tmux tmuxinator colored-man vundle extract zsh_reload copyfile copydir common-aliases npm ant gem fasd aws osx-aliases osx brew-cask xcode\) >> ${zshrc} 
        echo "export HOMEBREW_CASK_OPTS='--appdir=/Applications --caskroom=$(brew --prefix)/Caskroom'" >> ${zshrc}
        echo "export ECLIPSE_HOME=\"$(brew --prefix)/Caskroom/eclipse-java/\$(ls -t $(brew --prefix)/Caskroom/eclipse-java | head -n 1)/eclipse\"" >> ${zshrc}
    fi

cat <<EOF >> "${zshrc}"

## XDG settings ##################################
export XDG_CACHE_HOME=~/.cache
export XDG_DATA_HOME=~/.local/share
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME}

export ZDOTDIR="\${XDG_CONFIG_HOME}/zsh"
#export ZSHDDIR="${HOME}/.config/zsh.d"
export HISTFILE="${ZDOTDIR:-${HOME}}/.zsh_history"

## ZSH settings ####################################
export ZSH="\${XDG_CONFIG_HOME}/oh-my-zsh"
ZSH_THEME="wm"

#CASE_SENSITIVE="true"

DISABLE_AUTO_UPDATE="true"
#DISABLE_UPDATE_PROMPT=true
#UPDATE_ZSH_DAYS=3

#DISABLE_LS_COLORS="true"

#DISABLE_AUTO_TITLE="true"

ENABLE_CORRECTION="true"

#COMPLETION_WAITING_DOTS="true"

DISABLE_UNTRACKED_FILES_DIRTY="true"

# formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
#HIST_STAMPS="mm/dd/yyyy"

#ZSH_CUSTOM=/path/to/new-custom-folder
export ZSH_CACHE_DIR="\${XDG_CACHE_HOME}/zsh"
export ZSH_COMPDUMP="\${ZDOTDIR:-\${HOME}}/\${ZSH_CACHE_DIR}/.zcompdump-\${SHORT_HOST}-\${ZSH_VERSION}"

## EXPORTS ############################################
export _FASD_DATA="\${XDG_DATA_HOME}/fasd/fasd_data"

export PATH="$(brew --prefix)/bin:$(brew --prefix)/sbin:$PATH"
export MANPATH="$(brew --prefix)/share/man:$MANPATH"
export INFOPATH="$(brew --prefix)/share/info:$INFOPATH"

export PYTHONSTARTUP="\${XDG_CONFIG_HOME}/python/pythonrc.py"
export ECLIMSTARTUP="\${XDG_CONFIG_HOME}/eclim/eclimrc"
export CURL_HOME="\${XDG_CONFIG_HOME}/curl"

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Preferred editor for local and remote sessions
# if [[ -n \$SSH_CONNECTION ]]; then
#   export EDITOR='nvim'
# else
#   export EDITOR='nvim'
# fi

# Make vim the default editor.
export EDITOR='nvim';

# Omit duplicates and commands that begin with a space from history.
export HISTCONTROL='ignoreboth';

# Prefer US English and use UTF-8.
export LANG='en_US.UTF-8';
export LC_ALL='en_US.UTF-8';

export TERM="xterm-256color"

# Don’t clear the screen after quitting a manual page.
export MANPAGER='less -X';

# Always enable colored \`grep\` output.
export GREP_OPTIONS='--color=auto';

# Display correct tmux window titles
#export DISABLE_AUTO_TITLE=true

source \${ZSH}/oh-my-zsh.sh

EOF

dedupepath; #FIXME TODO this doesnt do anyting. need to use sed to replace path in file... http://linuxg.net/oneliners-for-removing-the-duplicates-in-your-path/
}

linkZsh() {
    echo -e "${color}Linking custom zsh themes & plugins...${reset}"
    mkdir -p $ZSH/custom/themes
    mkdir -p $ZSH/custom/plugins
    ln -sfv "${zsh_src}"/*.zsh $ZSH/custom
    #FIXME: remove this when osx-aliases not being sourced by zsh gets fixed...
    if [[ "$OSTYPE" =~ ^(linux)+ ]]; then
        rm -rf $ZSH/custom/osx-aliases.zsh 
    fi
    ln -sfv "${zsh_src}"/themes/* $ZSH/custom/themes
    ln -sfv "${zsh_src}"/plugins/* $ZSH/custom/plugins

    #env zsh
    source ${zshrc}

}

if [ -d "$ZSH" ]; then
  echo -e "${yellow}You already have Oh My Zsh installed.${reset} You'll need to remove $ZSH if you want to install..."
  makeZshrc
  linkZsh
  exit
fi

#TODO: check for zsh and install it using the appropriate method for current OS...
brew install zsh

echo -e "${color}Cloning Oh My Zsh...${reset}"
hash git >/dev/null 2>&1 && git clone git://github.com/robbyrussell/oh-my-zsh.git $ZSH || {
  echo "git not installed"
  exit
}

# TODO: is this the best way to do this:
if sudo -v
then
    echo "$(which zsh)" | sudo tee --append /etc/shells
    chsh "$(echo "$USER")" -s "$(which zsh)"
else
    rm -ri ~/.bash*
    touch ~/.bash_profile
    #TODO: detect if using modules...
    module purge
    echo "[ -f  $(which zsh) ] && exec $(which zsh) -l" >> ~/.bash_profile
    echo "PATH=$(brew --prefix)/bin:$PATH" >> ~/.bash_profile
fi

#TODO: check if brew is installed first
brew install fasd

makeZshrc
linkZsh

exit 0;

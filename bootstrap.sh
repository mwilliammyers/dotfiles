#!/bin/sh

# TODO: make everything support $DOTFILES_VERBOSE

DOTFILES_VERBOSE="${DOTFILES_VERBOSE:-true}"
DOTFILES_REPO="${DOTFILES_REPO:-https://github.com/mwilliammyers/dotfiles.git}"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"

debug() {
    if [ "x$DOTFILES_DEBUG" = 'xtrue' ]; then
        printf "$(tput bold)${@}$(tput sgr0)\n"
    fi
}

info() {
    if [ "x$DOTFILES_VERBOSE" = 'xtrue' ]; then
        printf "$(tput bold)${@}$(tput sgr0)\n"
    fi
}

warn() {
    printf "$(tput setaf 3)${@}$(tput sgr0)\n"
}

error() {
    >&2 printf "$(tput bold)$(tput setaf 1)${@}$(tput sgr0)\n"
}


die() {
    rc="${?}"
    error "${@}"
    exit "${rc}"
}

is_truthy() {
    # TODO: better way to do this in POSIX shell?
    case "x$1" in
        xTRUE) return 0;;
        xtrue) return 0;;
        xTrue) return 0;;
        xT) return 0;;
        xt) return 0;;
        xYES) return 0;;
        xyes) return 0;;
        xYes) return 0;;
        xY) return 0;;
        xy) return 0;;
        x1) return 0;;
        *) return 1;;
    esac
}

update_package_index() {
    if [ -x "$(command -v apt-get)" ]; then
        sudo apt-get update
    elif [ -x "$(command -v brew)" ]; then
        # homebrew doesn't print anything at the beginning
        info "Updating Homebrew; this could take a while..."
        brew update
    elif [ -x "$(command -v dnf)" ]; then
        dnf check-update
    elif [ -x "$(command -v yum)" ]; then
        yum check-update
    elif [ -x "$(command -v zypper)" ]; then
        sudo zypper refresh
    elif [ -x "$(command -v port)" ]; then
        sudo port selfupdate
    fi
}

# TODO: update first, only if we haven't already
_install_packages() {
    # TODO: fix this so it handles multiple args; it appears to be broken
    if [ -x "$(command -v apt-get)" ]; then
        sudo apt-get install -y "${@}"
    elif [ -x "$(command -v brew)" ]; then
        env HOMEBREW_NO_ANALYTICS=1 HOMEBREW_NO_GITHUB_API=1 \
            brew install "${@}"
    elif [ -x "$(command -v pacman)" ]; then
        sudo pacman -Syu "${@}"
    elif [ -x "$(command -v dnf)" ]; then
        sudo dnf -y "${@}"
    elif [ -x "$(command -v yum)" ]; then
        sudo yum -y "${@}"
    elif [ -x "$(command -v zypper)" ]; then
        sudo zypper install "${@}"
    elif [ -x "$(command -v pkg)" ]; then
        sudo pkg install "${@}"
    elif [ -x "$(command -v pkg_add)" ]; then
        pkg_add "${@}"
    elif [ -x "$(command -v port)" ]; then
        sudo port install "${@}"
    elif [ -x "$(command -v emerge)" ]; then
        emerge "${@}"
    elif [ -x "$(command -v pkgin)" ]; then
        pkgin -y install "${@}"
    elif [ -x "$(command -v nix-env)" ]; then
        nix-env -i "${@}"
    else
        return 1
    fi
}

install_packages() {
    # TODO: fix this so it handles multiple args; it appears to be broken
    if [ $# -ne 0 ] && [ "x$@" != 'x' ]; then
        info "Installing ${@}..."
        if _install_packages $@; then
            info "Installed ${@}\n"
        else
            warn "Could not install ${@}\n"
        fi
    fi
}

command_is_executable() {
    if [ -x "$(command -v ${1})" ]; then
        debug "${1} is already installed; skipping..."
        return 0
    else
        return 1
    fi
}

install_packages_if_necessary() {
    packages=""
    # echo "$@" | tr ' ' '\n' | while read package; do
    for package in $@; do
        command_is_executable "$package" || packages="$package $packages"
    done

    install_packages "$packages"
}

# TODO: make this smarter
package_exists() {
    if [ -x "$(command -v apt-cache)" ]; then
        sudo apt-cache show "${@}" 2>/dev/null >/dev/null
    elif [ -x "$(command -v brew)" ]; then
        # we don't need this info and it is faster without it
        env HOMEBREW_NO_ANALYTICS=1 HOMEBREW_NO_GITHUB_API=1 \
            brew info "${@}" 2>/dev/null >/dev/null
    else
        return 0
    fi
}

# TODO: add suport with other OSes
try_add_apt_repository() {
    if grep -q "ID=ubuntu" /etc/os-release 2>/dev/null; then
        if ! [ -x "$(command -v add-apt-repository)" ]; then
            sudo apt-get install -y software-properties-common
        fi
        sudo add-apt-repository -y "${@}"
        sudo apt-get update
        return 0
    fi

    return 1
}

# TODO: test for sudo without trying it first without sudo (pip will install to ~/.local)?
safe_pip3() {
    sudo -H pip3 install -U "${@}"
}

# TODO: is this the best way to detect if we need sudo?
safe_npm_global() {
    npm install -g "${@}" || sudo -H npm install -g "${@}"
}

os_copy_to_clipboard() {
    info "Attempting to copy to system clipboard..."
    if [ -x "$(command -v pbcopy)" ]; then
        printf "%s" "$1" | pbcopy
    elif [ -x "$(command -v xsel)" ]; then
        printf "%s" "$1" | xsel -ib
    else
        warn "Could not copy to system clipboard"
    fi
}

os_open() {
    info "Attempting to open: $1"
    if [ -x "$(command -v xdg-open)" ]; then
        xdg-open "$1"
    elif [ -x "$(command -v open)" ]; then
        open "$1"
    else
        warn "Could not find suitable program to open: $1"
    fi  
}

# install prerequisites

if [ "$(uname -s)" = "Darwin" ]; then
    if ! [ -x "$(command -v brew)" ]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # homebrew will install command line tools but let's check just in case
    if ! xcode-select -p >/dev/null 2>&1; then
        xcode-select --install 2> /dev/null
    fi
fi

install_packages_if_necessary "git" "curl" >> /dev/null

# bootstrap!
if is_truthy "${DOTFILES_BOOTSTRAP:-1}"; then
    mkdir -p "${CONFIG_DIR}" 2> /dev/null
    cd "${CONFIG_DIR}" || die "Could not find config directory"
    
    git init
    if [ "$(git remote get-url origin 2>/dev/null)" != "${DOTFILES_REPO}" ]; then
        git remote add origin "${DOTFILES_REPO}"
    fi
    git fetch
    git checkout master 2>/dev/null || git checkout origin/master -ft

    cd "${CONFIG_DIR}/bootstrap" || die "Could not find dotfiles directory"

    chmod u+x ./*.sh

    # TODO: support skipping inside of `install_packages`?
    is_truthy "${DOTFILES_SKIP_GCLOUD}" || ./google-cloud-sdk.sh
    is_truthy "${DOTFILES_SKIP_SSH}" || ./ssh.sh
    is_truthy "${DOTFILES_SKIP_FISH}" || ./fish.sh
    is_truthy "${DOTFILES_SKIP_FD}" || ./fd.sh
    is_truthy "${DOTFILES_SKIP_RIPGREP}" || ./ripgrep.sh
    is_truthy "${DOTFILES_SKIP_GHOSTTY}" || install_packages "ghostty"
    is_truthy "${DOTFILES_SKIP_RSYNC}" || install_packages "rsync"
    is_truthy "${DOTFILES_SKIP_FZF}" || install_packages "fzf"
    is_truthy "${DOTFILES_SKIP_BAT}" || install_packages "bat"
    is_truthy "${DOTFILES_SKIP_EZA}" || install_packages "eza"
    is_truthy "${DOTFILES_SKIP_JQ}" || install_packages "jq"
    is_truthy "${DOTFILES_SKIP_CHATGPT}" || install_packages "chatgpt"
    is_truthy "${DOTFILES_SKIP_NODEJS}" || ./nodejs.sh
    is_truthy "${DOTFILES_SKIP_UV}" || install_packages "uv" # can be used to install python3
    is_truthy "${DOTFILES_SKIP_PYTHON3}" || install_packages "python3"
    is_truthy "${DOTFILES_SKIP_GIT_DELTA}" || install_packages "git-delta"
    is_truthy "${DOTFILES_SKIP_NEOVIM}" || ./neovim.sh
    is_truthy "${DOTFILES_SKIP_VSCODE}" || ./vscode.sh
    is_truthy "${DOTFILES_SKIP_DOCKER}" || ./docker.sh

    if [ "$(uname -s)" = "Darwin" ]; then
        is_truthy "${DOTFILES_SKIP_APPCLEANER}" || install_packages "appcleaner"

        is_truthy "${DOTFILES_SKIP_TRASH}" || install_packages_if_necessary "trash"

        is_truthy "${DOTFILES_SKIP_ITERM2:-1}" || ./iterm2.sh
    fi

    is_truthy "${DOTFILES_SKIP_1PASSWORD}" || install_packages "1password"
    is_truthy "${DOTFILES_SKIP_NOTION}" || install_packages "notion"
    is_truthy "${DOTFILES_SKIP_LINEAR}" || install_packages "linear-linear"
    is_truthy "${DOTFILES_SKIP_SLACK}" || install_packages "slack"

    # TODO: these take forever...
    is_truthy "${DOTFILES_SKIP_RUST}" || ./rust.sh
    # is_truthy "${DOTFILES_SKIP_RUST:-1}" || ./musl-cross.sh

    is_truthy "${DOTFILES_SKIP_SYSTEM_CONFIG}" || ./system.sh
fi

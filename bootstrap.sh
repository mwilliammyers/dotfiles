#!/bin/sh

# TODO: make everything support $DOTFILES_VERBOSE

DOTFILES_VERBOSE="${DOTFILES_VERBOSE:-true}"
DOTFILES_REPO="${DOTFILES_REPO:-mwilliammyers/dotfiles}"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.config/dotfiles}"

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
    if [ -x "$(command -v apt-get)" ]; then
        sudo apt-get install -y "${@}"
    elif [ -x "$(command -v brew)" ]; then
        # TODO: DOTFILES_HOMEBREW_OPTS
        # TODO: better way to pass options?
        if is_truthy "${DOTFILES_HOMEBREW_CASK}"; then
            env HOMEBREW_NO_ANALYTICS=1 HOMEBREW_NO_GITHUB_API=1 \
                brew install --cask "${@}"
        else
            env HOMEBREW_NO_ANALYTICS=1 HOMEBREW_NO_GITHUB_API=1 \
                brew install "${@}"
        fi
        # unset DOTFILES_HOMEBREW_OPTS
        unset DOTFILES_HOMEBREW_CASK
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
    if [ $# -ne 0 ] && [ "x$@" != 'x' ]; then
        info "Installing ${@}..."
        if _install_packages $@; then
            info "Installed ${@}"
        else
            warn "Could not install ${@}"
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

configure_single_package() {
    source_config_dir="$1"
    dest_config_dir="$2"
    package=$(basename $1)

    info "Configuring $package"

    mkdir -p "$dest_config_dir" 2> /dev/null
    for source_file in "$source_config_dir"/*; do
        dest_file="$dest_config_dir"/$(basename "$source_file")

        if [ -e "$dest_file" ]; then
            warn "Overwriting existing configuration file: $dest_file"
            rm -ri "$dest_file"
        fi

        ln -sv  "$source_file" "$dest_file"
    done
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

git_pull_or_clone() {
    git -C "${2}" config --get remote.origin.url 2>/dev/null | grep -q "${DOTFILES_REPO}"
    if [ "${?}" -eq 0 ]; then
        git -C "${2}" pull --ff-only --depth=1
    else
        # Do not use recursive to avoid:
        # `Fetched in submodule path <path> but it did not contain <hash>. Direct fetching of that commit failed.`
        git clone "${1}" "${2}" --depth=1
    fi
}

# install prerequisites

if [ "$(uname -s)" = "Darwin" ]; then
    xcode-select --install 2> /dev/null

    if ! [ -x "$(command -v brew)" ]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
fi

install_packages_if_necessary "git" "curl" >> /dev/null

# bootstrap!
if is_truthy "${DOTFILES_BOOTSTRAP:-1}"; then
    git_pull_or_clone "https://github.com/${DOTFILES_REPO}.git" "${DOTFILES_DIR}" \
        || die "dotfiles must be up to date"

    cd "${DOTFILES_DIR}" || die "Could not find dotfiles directory"

    chmod u+x ./*.sh

    # TODO: support skipping inside of `install_packages`?
    is_truthy "${DOTFILES_SKIP_GCLOUD}" || ./google-cloud-sdk.sh
    is_truthy "${DOTFILES_SKIP_SSH}" || ./ssh.sh
    is_truthy "${DOTFILES_SKIP_FISH}" || ./fish.sh
    is_truthy "${DOTFILES_SKIP_STARSHIP}" || ./starship.sh
    is_truthy "${DOTFILES_SKIP_GIT}" || ./git.sh
    is_truthy "${DOTFILES_SKIP_FD}" || ./fd.sh
    is_truthy "${DOTFILES_SKIP_RIPGREP}" || ./ripgrep.sh
    # TODO: separate these out to allow skipping?
    install_packages_if_necessary "ghostty" "rsync" "fzf" "bat" "eza" "jq" "chatgpt"
    is_truthy "${DOTFILES_SKIP_NODEJS}" || ./nodejs.sh
    is_truthy "${DOTFILES_SKIP_PYTHON3}" || install_packages_if_necessary "python3"
    is_truthy "${DOTFILES_SKIP_GIT_DELTA}" || install_packages "git-delta"
    is_truthy "${DOTFILES_SKIP_NEOVIM}" || ./neovim.sh
    is_truthy "${DOTFILES_SKIP_DOCKER}" || ./docker.sh
    is_truthy "${DOTFILES_SKIP_VSCODE}" || ./vscode.sh

    if [ "$(uname -s)" = "Darwin" ]; then
        # TODO: add support for other platforms for docker
        DOTFILES_HOMEBREW_CASK=true install_packages_if_necessary \
            # google-chrome \
            appcleaner

        install_packages_if_necessary "trash"

        # is_truthy "${DOTFILES_SKIP_ITERM2}" || ./iterm2.sh
    fi

    # TODO: these take forever...
    is_truthy "${DOTFILES_SKIP_RUST}" || ./rust.sh
    # ./musl-cross.sh

    is_truthy "${DOTFILES_SKIP_SYSTEM_CONFIG}" || ./system.sh
fi

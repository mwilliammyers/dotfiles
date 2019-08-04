#!/bin/sh

# TODO: make everything support $DOTFILES_VERBOSE

DOTFILES_VERBOSE="${DOTFILES_VERBOSE:-true}"
DOTFILES_REPO="${DOTFILES_REPO:-mwilliammyers/dotfiles}"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.config/dotfiles}"

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

# TODO: update first, only if we haven't already
_install_packages() {
	if [ -x "$(command -v apt-get)" ]; then
		sudo apt install -y "${@}"
	elif [ -x "$(command -v brew)" ]; then
		# TODO: better way to pass options?
		if is_truthy "${DOTFILES_HOMEBREW_CASK}"; then
			env HOMEBREW_NO_ANALYTICS=1 HOMEBREW_NO_GITHUB_API=1 \
				brew cask install "${@}"
		else
			env HOMEBREW_NO_ANALYTICS=1 HOMEBREW_NO_GITHUB_API=1 \
				brew install "${@}" "${DOTFILES_HOMEBREW_OPTS}"
		fi
		DOTFILES_HOMEBREW_OPTS=""
		DOTFILES_HOMEBREW_CASK=""
	elif [ -x "$(command -v pacman)" ]; then
		sudo pacman -Syu "${@}"
	elif [ -x "$(command -v dnf)" ]; then
		dnf -y "${@}"
	elif [ -x "$(command -v zypper)" ]; then
		sudo zypper in "${@}"
	elif [ -x "$(command -v pkg)" ]; then
		sudo pkg install "${@}"
	elif [ -x "$(command -v pkg_add)" ]; then
		pkg_add "${@}"
	elif [ -x "$(command -v port)" ]; then
		sudo port selfupdate
		sudo port install "${@}"
	elif [ -x "$(command -v emerge)" ]; then
		emerge "${@}"
	elif [ -x "$(command -v pkgin)" ]; then
		pkgin -y install "${@}"
	else
		return 1
	fi
}

install_packages() {
	info "Installing ${@}..."
	( _install_packages ${@} && info "Installed ${@}" ) || error "Could not install ${@}"
}

command_is_executable() {
	if [ -x "$(command -v ${1})" ]; then
		info "${1} is already installed; skipping..."
		return 0
	else
		return 1
	fi
}

install_packages_if_necessary() {
	command_is_executable "$@" || install_packages "$@"
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

# install prerequisites

if [ "$(uname -s)" == "Darwin" ]; then
	if ! [ -x "$(command -v brew)" ]; then
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	fi
fi

install_packages_if_necessary "git" "curl" >> /dev/null

# bootstrap!
if is_truthy "${DOTFILES_BOOTSTRAP:-1}"; then
	git_pull_or_clone "https://github.com/${DOTFILES_REPO}.git" "${DOTFILES_DIR}" \
		|| die "dotfiles must be up to date"

	cd "${DOTFILES_DIR}" || die "Could not find dotfiles directory"

	chmod u+x *.sh

	./fish.sh
	./install.sh python3 fzf
	./nodejs.sh
	./neovim.sh
	./sublime-text.sh

	if [ "$(uname -s)" == "Darwin" ]; then
		DOTFILES_HOMEBREW_CASK=true ./install.sh \
			google-chrome \
			appcleaner

		./iterm2.sh
	fi

	# TODO: this takes for ever...
	./musl-cross.sh
fi

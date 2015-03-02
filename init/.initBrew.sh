#!/usr/bin/env bash

# Install command-line tools using Homebrew.
# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# check if brew is installed, if not install it
if hash brew 2>/dev/null; then
    printf "\nUpdating Homebrew & all currently installed formulas...\n";
    brew update;
    brew upgrade;
     brew doctor;
else
     if [[ "$OSTYPE" =~ ^(linux)+ ]]; then
         # TODO: check version of ruby and abort if not 1.9 or higher (Ubuntu bug...)
         ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/linuxbrew/go/install)";
     elif [[ "$OSTYPE" =~ ^(darwin)+ ]]; then
         ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)";
     fi
fi

brew install zsh

brew install ruby

brew install git
brew install git-extras

# Install more recent versions of some native tools.
brew install vim --override-system-vi
brew install homebrew/dupes/grep
brew install homebrew/dupes/openssh
brew install homebrew/dupes/screen
brew install homebrew/php/php55 --with-gmp

brew install wget --with-iri

brew install ack

brew install fasd
brew install lynx
brew install pigz
brew install pv
brew install speedtest_cli
brew install tree
brew install rename
brew install shellcheck
brew install uncrustify
brew install ctags

# Install Node.js. Note: this installs `npm` too, using the recommended
# installation method.
brew install node

function brewMac() {
  # Install GNU core utilities (those that come with OS X are outdated).
  # Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
  brew install coreutils
  sudo ln -s /usr/local/bin/gsha256sum /usr/local/bin/sha256sum

  # Install some other useful utilities like `sponge`.
  brew install moreutils
  # Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
  brew install findutils
  # Install GNU `sed`, overwriting the built-in `sed`.
  brew install gnu-sed --with-default-names

  # Install Bash 4.
  # Note: don’t forget to add `/usr/local/bin/bash` to `/etc/shells` before
  # running `chsh`.
  brew install bash
  brew install bash-completion

  # Install `wget` with IRI support.
  brew install wget --with-iri

  # Install RingoJS and Narwhal.
  # Note that the order in which these are installed is important;
  # see http://git.io/brew-narwhal-ringo.
  brew install ringojs
  brew install narwhal

  # Install font tools.
  # brew tap bramstein/webfonttools
  # brew install sfnt2woff
  # brew install sfnt2woff-zopfli
  # brew install woff2

  # Install some CTF tools; see https:/arclgithub.com/ctfs/write-ups.
  # brew install bfg
  # brew install binutils
  # brew install binwalk
  # brew install cifer
  # brew install dex2jar
  # brew install dns2tcp
  # brew install fcrackzip
  # brew install foremost
  # brew install hashpump
  # brew install hydra
  # brew install john
  # brew install knock
  # brew install nmap
  # brew install pngcheck
  # brew install socat
  # brew install sqlmap
  # brew install tcpflow
  # brew install tcpreplay
  # brew install tcptrace
  # brew install ucspi-tcp # `tcpserver` etc.
  # brew install xpdf
  # brew install xz

  # Install other useful binaries.
  # brew install exiv2
  brew install imagemagick --with-webp
  # brew install lua
  # brew install p7zip
  # brew install rhino
  # brew install webkit2png
  # brew install zopfli
  brew install pmccabe
  brew install ssh-copy-id
  brew install fdupes
  brew install tag
  brew install awscli
  brew install htop-osx
  # install server tools 
  # TODO: how to determine if we should install this 
  # automatically?
  if [[ "$HOSTNAME" =~ (.)*(ro)^ ]]; then
     brew install nzbget
     brew install fail2ban
    # brew tap neovim/homebrew-neovim
     # brew install neovim
     brew install sickbeard
     brew install couchpotatoserver
  fi
}

function brewLinux() {
  export PATH="$HOME/.linuxbrew/bin:$PATH"
  export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
  export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"

  # brew install fdupes
}

if [[ "$OSTYPE" =~ ^(linux)+ ]]; then
  brewLinux;
elif [[ "$OSTYPE" =~ ^(darwin)+ ]]; then
  brewMac;
fi

# Remove outdated versions from the cellar.
brew cleanup

exit 0;

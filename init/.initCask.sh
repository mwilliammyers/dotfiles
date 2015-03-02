#!/usr/bin/env bash

# TODO: does cask need root privledges?
# Ask for the administrator password upfront
 sudo -v

# Keep-alive: update existing `sudo` time stamp until `.osx` has finished
 while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# check if cask is installed, if not install it
if hash brew-cask 2>/dev/null; then
    printf "\nUpdating brew-cask & all currently installed casks...\n";
    brew update;
    brew upgrade brew-cask;
    brew cask doctor;
  else
		# brew tap phinze/homebrew-cask
		# brew install brew-cask
        brew install caskroom/cask/brew-cask
fi

brew cask install atom
brew cask install google-chrome
# brew cask install imagealpha
brew cask install imageoptim
# brew cask install miro-video-converter
# brew cask install sublime-text
# brew cask install ukelele
brew cask install java
brew cask install eclipse-java

if [[ "$OSTYPE" =~ ^(darwin)+ ]]; then
  brew cask install slate
  # brew cask install totalterminal
  brew cask install iterm2
  brew cask install bartender
  # brew cask install transmission
  brew cask install handbrake
  brew cask install handbrakecli
  brew cask install torbrowser
  # brew cask install vlc
  # brew cask install the-unarchiver
  # brew cask install clipmenu
  # brew cask install macvim
  # brew cask install virtualbox
fi

brew cleanup
brew cask cleanup

exit 0;

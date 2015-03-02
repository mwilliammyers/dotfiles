#!/usr/bin/env bash

cd ${0%/*}
cd .. && source dotfiles.conf;
cd ${init}

if [[ "$OSTYPE" =~ ^(linux)+ ]]; then
  sudo apt-get install dconf-cli
  cd ~/Downloads
  rm -rf ~/Downloads/gnome-terminal-colors-solarized/
  git clone https://github.com/Anthony25/gnome-terminal-colors-solarized.git
  cd gnome-terminal-colors-solarized
  ./set_dark.sh
  rm -rf ~/Downloads/gnome-terminal-colors-solarized/
elif [[ "$OSTYPE" =~ ^(darwin)+ ]]; then
  ln -sfv "${terminal_src}"/com.* "${terminal_dst}"
  brew cask install iterm2
  # Hide the dock icon for iTerm2
  # TODO: find a better way so that the menu bar doesnt dissappear
  # defaults write /Applications/iTerm.app/Contents:w/Info.plist LSUIElement 1
fi

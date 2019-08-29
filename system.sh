#!/bin/sh

DOTFILES_BOOTSTRAP=false source ./bootstrap.sh

./fish.sh

info "Configuring system settings..."

command_is_executable "brew" \
    && command fish -c 'set -Ux HOMEBREW_AUTO_UPDATE_SECS 604800'

# https://github.com/mathiasbynens/dotfiles/blob/master/.macos
if [ "$(uname -s)" == "Darwin" ]; then
    defaults write com.apple.dock mru-spaces -bool false
    defaults write com.apple.dock expose-animation-duration -float 0.1

    defaults write com.apple.dock orientation -string left
    defaults write com.apple.dock autohide -bool true
    defaults write com.apple.dock autohide-time-modifier -float 0.15
    # defaults write com.apple.dock showhidden -bool true
    defaults write com.apple.dock tilesize -int 46

    # defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
    # defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

    # http://homeowmorphism.com/articles/17/Remap-CapsLock-Backspace-Sierra

    # Set a blazingly fast keyboard repeat rate
    # defaults write NSGlobalDomain KeyRepeat -int 1
    # defaults write NSGlobalDomain InitialKeyRepeat -int 10

    # defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

    defaults write com.apple.menuextra.battery ShowPercent -bool true

    info "Restarting affected apps..."
    for app in "Dock" "SystemUIServer"; do
        killall "${app}" &> /dev/null
    done
fi

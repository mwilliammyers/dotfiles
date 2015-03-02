#!/bin/bash

# TODO: get around need for full path in com.homebrew.update.plist
# OR write the file from here... (or another script)
# TODO: fix need for /usr/local/bin/brew even though brew is in my $PATH
echo -e "#############################################"
date
echo -e "Updating Homebrew..." 
/usr/local/bin/brew update 

echo -e "---------------------------------------------"
date
echo -e "Upgrading all Homebrew formulae..." 
/usr/local/bin/brew upgrade 

echo -e "---------------------------------------------"
date
echo -e "Cleaning up..." 
/usr/local/bin/brew cleanup && usr/local/bin/brew-cask cleanup

exit 0

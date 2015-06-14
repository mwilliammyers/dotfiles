# #!/usr/bin/env bash
cd ${0%/*}
cd .. && source dotfiles.conf;
cd "${init}"

function linkAtomSettings() {
    apm login

    # install all currently starred Atom packages
    apm stars --install

    SAVEIFS=$IF
    IFS=$(echo -en "\n\b")

    printf "\nCreating sym links for: atom files...\n"
    ln -sfv  2> /dev/null "${atom_src}"/* "${atom_dst}"

    IFS=$SAVEIFS
}

function promptToLink() {
  if [[ "$*" =~ ^[-]?[fF]{1}(orce)*$ ]]; then
      linkAtomSettings;
  else
      printf "\n";
      read -t 20 -p "Symlink Atom settings files & install starred Atom packages? This may overwrite existing files. Are you sure? (y/n) " -n 1
      printf "\n";
      if [[ $REPLY =~ ^[Yy]$ ]]; then
          linkAtomSettings;
      fi
  fi
}

# check if atom is installed, if not check if cask is installed, if not install both
if hash atom 2>/dev/null; then
        promptToLink;
  else
      if hash brew-cask 2>/dev/null; then
            brew cask install atom;
            promptToLink;
          else
            brew tap phinze/homebrew-cask;
            brew install brew-cask;
            brew cask install atom;
            promptToLink;
      fi
fi

exit 0;

#!/usr/bin/env bash

cd ${0%/*}
cd .. && source dotfiles.conf;
cd "${init}"

linkDotFiles() {
  SAVEIFS=$IF
  IFS=$(echo -en "\n\b")

  # TODO: test if programs exist before linking eg. eclim
  printf "\nCreating symbolic links for: dotfiles...\n"
  ln -sfv  2> /dev/null "${dotfiles}"/.* ~
  IFS=$SAVEIFS
}

linkXcode() {
  printf "\nCreating symbolic links for: XCode...\n"
  # link xcode UserData folder
  # TODO: support for installed plugins...
  ln -sfv "${xcode_src}"/UserData "${xcode_dst}"
}

linkiTunes() {
  printf "\nCreating symbolic links for: iTunes...\n"
  mkdir ~/Library/iTunes/Scripts/
  ln -sfv "${itunes_src}"/* "${itunes_dst}"
}

linkLaunchAgents() {
  printf "\nCreating symbolic links for: LaunchAgents...\n"
  ln -sfv "${LaunchAgents}"/* ~/Library/LaunchAgents
}

if [[ "$*" =~ ^[-]?[fF]{1}(orce)*$ ]]; then
  linkDotFiles;
else
  printf "\n";
  read -t 20 -p "Symlink dotfiles to your home directory? This may overwrite existing files. Are you sure? (y/n) " -n 1
  printf "\n";
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    linkDotFiles;

    if [[ "${OSTYPE}" =~ ^(darwin)+ ]]; then
      SAVEIFS=$IF
      IFS=$(echo -en "\n\b")

      linkXcode;
      linkiTunes;
      linkLaunchAgents;

      IFS=$SAVEIFS;
    fi
  fi
fi

exit 0;

#!/usr/bin/env bash

cd ${0%/*}
cd .. && source dotfiles.conf;
cd "${init}"

linkDotFiles() {
  SAVEIFS=$IF
  IFS=$(echo -en "\b")

  # TODO: test if programs exist before linking eg. eclim
  echo -e "${color}Creating symbolic links for: dotfiles...${reset}"
  ln -sfv  2> /dev/null "${dotfiles}"/.* ~
  if [ -n "${XDG_CONFIG_HOME}" ] && [ -d "${config_dir}/xdg/config" ]; then
      echo -e "\n${color}Creating symbolic links for: XDG_CONFIG_HOME files...${reset}"
      ln -sfv  2> /dev/null "${config_dir}"/xdg/config/* "${XDG_CONFIG_HOME}"
      ln -sfv  2> /dev/null "${config_dir}"/xdg/config/.* "${XDG_CONFIG_HOME}"
  fi
  IFS=$SAVEIFS
}

linkXcode() {
  echo -e "\n${color}Creating symbolic links for: XCode...${reset}"
  # link xcode UserData folder
  # TODO: support for installed plugins...
  ln -sfv "${xcode_src}"/UserData "${xcode_dst}"
}

linkiTunes() {
  echo -e "\n${color}Creating symbolic links for: iTunes...${reset}"
  mkdir ~/Library/iTunes/Scripts/
  ln -sfv "${itunes_src}"/* "${itunes_dst}"
}

linkLaunchAgents() {
  echo -e "\n${color}Creating symbolic links for: LaunchAgents...${reset}"
  ln -sfv "${LaunchAgents}"/* ~/Library/LaunchAgents
}

if [[ "$*" =~ ^[-]?[fF]{1}(orce)*$ ]]; then
  linkDotFiles;
else
  printf "${red}";
  read -t 20 -p "Symlink dotfiles to your home directory? This may overwrite existing files. Are you sure? (y/n) " -n 1
  echo -e "";
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    linkDotFiles;
    if [[ "${OSTYPE}" =~ ^(darwin)+ ]]; then
      SAVEIFS=$IF
      IFS=$(echo -en "\b")
      linkXcode;
      linkiTunes;
      linkLaunchAgents;
      IFS=$SAVEIFS;
    fi
  fi
fi


exit 0;

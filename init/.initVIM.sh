#!/usr/bin/env bash

cd "${0%/*}"
cd .. && source dotfiles.conf;
cd "${init}"

#TODO update this when this gets merged into master also make it multi-line...
echo -e "${color}Installing spf-vim framework...${reset}"
APP_PATH=${vim_spf13} sh <(curl https://raw.githubusercontent.com/jrobeson/spf13-vim/cleanup-bootstrap/bootstrap.sh -L)

echo -e "${color}Linking vim dotfiles from ${vim_src} to ${vim_dst}...${reset}"
ln -sfv 2> /dev/null "${vim_src}"/.* ~
#echo let g:spf13_consolidated_directory = \'${HOME}/.vim\' >> ~/.vimrc.before

#install other handy VIM plugins
brew install ctags

function installYCM() {
    # TODO: handle if YouCompleteMe doesn't exist or is already installed
    echo -e "${color}Installing YouCompleteMe...${reset}"
    cd "${vim_dst}"/bundle/YouCompleteMe

    ./install.sh --clang-completer #--omnisharp-completer
}

function installEclim() {
    cd "${init}"
    #TODO: handle if eclim is already installed...
    # TODO: set $ECLIPSE_HOME here? 
    echo -e "${color}\nDownloading latest version of Eclim...${reset}"
    curl \
        --location --get --progress-bar \
        "http://sourceforge.net/projects/eclim/files/latest/download\?source\=files" \
        --output eclim-latest.jar

    echo -e "${color}Intalling Eclim...${reset}"
    java \
      -Dvim.files="$HOME"/.vim \
      -Declipse.home="$ECLIPSE_HOME" \
      -jar eclim-latest.jar install

    rm -rvf "${init}"/eclim-latest.jar
}

# TODO: option to install powerline fonts...
# TODO: automatically choose to install these or ask at beginning and install later...?
# TODO: add -q option to silence this and NOT install by default...
read -r -p "Install eclim? (y/n) " -n 1
if [[ $REPLY =~ ^[Yy]$ ]]; then
    installEclim;
fi

echo -e ""

# TODO: add -q option to silence this and NOT install by default...
read -r -p "Install the YouCompleteMe completion engine binary? (y/n) " -n 1
if [[ $REPLY =~ ^[Yy]$ ]]; then
    vim +BundleClean +BundleInstall +qall
    installYCM;
fi

exit 0;

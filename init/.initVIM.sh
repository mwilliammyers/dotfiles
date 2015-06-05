#!/usr/bin/env bash

cd "${0%/*}"
cd .. && source dotfiles.conf;
cd "${init}"

function installSPF13() {
    #TODO update this when this gets merged into master also make it multi-line...
    echo -e "${color}Installing spf-vim framework...${reset}"
    APP_PATH=${vim_spf13} sh <(curl https://j.mp/spf13-vim3 -L)

    echo -e "${color}Linking vim dotfiles from ${vim_src} to ${vim_dst}...${reset}"
    ln -sfv 2> /dev/null "${vim_src}"/.* ~
    #echo let g:spf13_consolidated_directory = \'${HOME}/.vim\' >> ~/.vimrc.before

    #install other handy VIM plugins
    brew install ctags
}

function installYCM() {
    # TODO: handle if YouCompleteMe doesn't exist or is already installed
    echo -e "${color}Installing YouCompleteMe...${reset}"
    cd "${vim_dst}"/bundle/YouCompleteMe

    ./install.sh --clang-completer #--omnisharp-completer
}

read -r -p "Install spf-13? (y/n) " -n 1
if [[ $REPLY =~ ^[Yy]$ ]]; then
    installSPF13;
    vim +BundleClean +BundleInstall +qall
fi

echo -e ""; read -r -p "Install eclim? (y/n) " -n 1
if [[ $REPLY =~ ^[Yy]$ ]]; then
    brew install eclim
fi

echo -e ""; read -r -p "Install the YouCompleteMe completion engine binary? (y/n) " -n 1
if [[ $REPLY =~ ^[Yy]$ ]]; then
    vim +BundleClean +BundleInstall +qall
    installYCM;
fi

exit 0;

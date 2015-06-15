#!/usr/bin/env bash

cd "${0%/*}"
source ../dotfiles.conf;

function checkDependencies() {
    if [[ "$OSTYPE" =~ ^(darwin)+ ]]; then
        if [ -n "$(command -v brew)" ]; then
            for i in "$@"; do
                [ ${i} = "eclim" ] && brew tap mkwmms/scripts
                [ -z "$(command -v ${i})" ] && brew install "${i}"
            done
        else
            echo -e "${red}Homebrew is not installed. Please install that first.${reset}"
        fi
    fi
}

function installSPF13() {
    #TODO update this when this gets merged into master also make it multi-line...
    echo -e "${color}Installing spf13-vim...${reset}"
    APP_PATH=${vim_spf13} sh <(curl https://j.mp/spf13-vim3 -L)
    #install other handy VIM plugins
    checkDependencies "ctags"
}

function installYCM() {
    # TODO: handle if YouCompleteMe doesn't exist or is already installed
    echo -e "${color}Installing YouCompleteMe...${reset}"
    cd "${vim_dst}"/bundle/YouCompleteMe

    ./install.sh --clang-completer #--omnisharp-completer
}

function linkVim() {
 echo -e "${color}Linking vim dotfiles from ${vim_src} to ${vim_dst}...${reset}"
    ln -sfv 2> /dev/null "${vim_src}"/.* ~
    #echo let g:spf13_consolidated_directory = \'${HOME}/.vim\' >> ~/.vimrc.before
}

function promptToInstallSpf13() {
    printf "${yellow}Install spf13-vim? (y/n) "; read REPLY; printf "${reset}"
    if [[ $REPLY =~ ^[Yy](es)?$ ]]; then
        installSPF13
        vim +BundleClean +BundleInstall +qall
    fi
}

[ -d ${vim_spf13} ] && linkVim

if [ -d "${vim_spf13}" ]; then
    echo -e "${red}spf13-vim is already installed at: ${vim_spf13}"
    sleep 1
    promptToInstallSpf13
else
    promptToInstallSpf13
fi

if [ -d "${vim_spf13}" ]; then
    printf "${yellow}Install eclim? (y/n) "; read REPLY; printf "${reset}"
    if [[ $REPLY =~ ^[Yy](es)?$ ]]; then
        checkDependencies "eclim"
    fi
fi

if [ -d "${vim_dst}/bundle/YouCompleteMe" ]; then
    printf "${yellow}Install the YouCompleteMe completion engine binary? (y/n) "; read REPLY; printf "${reset}"
    if [[ $REPLY =~ ^[Yy](es)?$ ]]; then
        vim +BundleClean +BundleInstall +qall
        installYCM
    fi
fi

exit 0;

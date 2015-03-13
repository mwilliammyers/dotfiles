#!/usr/bin/env bash

cd "${0%/*}"
cd .. && source dotfiles.conf;
cd "${init}"

blue='\033[0;34m'
NC='\033[0m' # No Color

#TODO update this when this gets merged into master also make it multi-line...
echo -e "${blue}Installing spf-vim framework...${NC}"
REPO_BRANCH="cleanup-bootstrap" REPO_URI='https://github.com/jrobeson/spf13-vim.git' APP_PATH=${vim_spf13} sh <(curl https://raw.githubusercontent.com/jrobeson/spf13-vim/cleanup-bootstrap/bootstrap.sh -L)

#TODO:setup custom consolidated VIM dir see .vimrc.before line 59ish
echo -e "${blue}Linking vim dotfiles from ${vim_src} to ${vim_dst}...${NC}"
ln -sfv 2> /dev/null "${vim_src}"/.* ~

#install other handy VIM plugins
brew install ctags

# TODO: handle if YouCompleteMe doesn't exist
echo -e "${blue}Installing YouCompleteMe...${NC}"
cd "${vim_dst}"/bundle/YouCompleteMe
./install.sh --clang-completer #--omnisharp-completer

cd "${init}"
echo -e "${blue}Downloading latest version of Eclim...${NC}"
curl \
    --location --get --progress-bar \
    "http://sourceforge.net/projects/eclim/files/latest/download\?source\=files" \
    --output eclim-latest.jar

echo -e "${blue}Intalling Eclim...${NC}"
java \
  -Dvim.files="$HOME"/.vim \
  -Declipse.home="$ECLIPSE_HOME" \
  -jar eclim-latest.jar install

rm -rvf "${init}"/eclim-latest.jar

exit 0;

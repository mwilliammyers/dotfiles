#!/usr/bin/env bash

cd ${0%/*}
cd .. && source dotfiles.conf;

ln -sfv 2> /dev/null "${vim_src}"/.* ~

if cd "${vim_dst}" &> /dev/null
then
    git pull
else
    cd "${dotfiles_dst}"
    git clone https://github.com/spf13/spf13-vim.git
    mv spf13-vim/ vim/
fi

# TODO: submit pull request to implement:
#if [ ! -n "$SPF-13" ]; then
#  SPF-13=~/.oh-my-zsh
#fi
cd "${vim_dst}"
# FIXME: sed will not work if .bak is not supplied...
sed -i.bak 's:spf13-vim-3:dotfiles/vim:g' bootstrap.sh
./bootstrap.sh

brew install ctags

exit 0;

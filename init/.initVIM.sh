#!/usr/bin/env bash

cd ${0%/*}
cd .. && source dotfiles.conf;

if cd "${vim_spf13}" &> /dev/null
then
    git pull
else
    mkdir -p "${dotfiles_dst}"
    cd "${dotfiles_dst}"
    git clone https://github.com/spf13/spf13-vim.git
    mv spf13-vim/ vim/
fi

# TODO: submit pull request to implement:
#if [ ! -n "$SPF-13" ]; then
#  SPF-13=~/.oh-my-zsh
#fi
cd "${vim_spf13}"
# FIXME: sed will not work if .bak is not supplied...
sed -i.bak 's:spf13-vim-3:dotfiles/vim:g' bootstrap.sh
./bootstrap.sh

TODO:setup custom consolidated VIM dir see .vimrc.before line 59ish
ln -sfv 2> /dev/null "${vim_src}"/.* ${vim_dst}

#install other handy VIM plugins
brew install ctags

#echo -e "Installing YouCompleteMe..."
#cd ${vim_dst}/YouCompleteMe
#./install.sh --clang-completer #--omnisharp-completer

#TODO: install eclim? 
exit 0; 

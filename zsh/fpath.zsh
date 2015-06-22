#!/usr/bin/env zsh

#add each topic folder to fpath so that they can add functions and completion scripts
for topic_folder ( $ZSH/* ); do
    [ -d "$topic_folder" ] && fpath=($topic_folder $fpath)
done 
[ -d $ANTIBODY_HOME/jolux-antigen-hs-git ] && fpath=($ANTIBODY_HOME/jolux-antigen-hs-git $fpath)

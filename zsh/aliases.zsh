#!/bin/sh
__reload_dotfiles() {
  PATH="$(command -p getconf PATH)"
  exec $SHELL -l
  cleanupPath
  cd .
}
alias reload!='__reload_dotfiles'

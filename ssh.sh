#!/bin/sh

DOTFILES_BOOTSTRAP=false . ./bootstrap.sh

# TODO: we really should be generating this instead...
# TODO: handle Linux mountpoints
if [ "$(uname -s)" = "Darwin" ]; then
    # TODO: check if file exists first?
    cp -r /Volumes/config/$USER/.ssh ~/
fi


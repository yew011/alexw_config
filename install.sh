#!/usr/bin/env sh

# This file is soon to be abondoned as we are moving toward using
# GNU autoconf framework.

FORCE=

# --force option, be careful~
if [ "$1" = "--force" ] ; then
    FORCE="-f"
fi

# warning of '--force'
help () {
    printf "there is \"--force\" if you know what you are doing.\n"
}

# copy the .emacs.d modules
if [ -d ~/.emacs.d ] ; then
    ln -s $FORCE $PWD/.emacs.d/* ~/.emacs.d || help
fi

# copy my scripts
ln -s $FORCE $PWD/.alex_bin ~/.alex_bin

# copy other config files
for f in `find . -maxdepth 1 -type f -name '.*'`; do
    ln -s $FORCE $PWD/$f ~ || help
done

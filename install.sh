#!/usr/bin/env sh

FORCE=

# --force option, be careful~
if [ "$1" = "--force" ] ; then
    FORCE="--force"
fi

# warning of '--force'
help () {
    printf "there is \"--force\" if you know what you are doing.\n"
}

# copy the .emacs.d modules
if [ -d ~/.emacs.d ] ; then
    ln -s $FORCE $PWD/.emacs.d/* ~/.emacs.d || help
fi

# copy other config files
for f in `find . -maxdepth 1 -type f`; do
    ln -s $FORCE $PWD/$f ~ || help
done

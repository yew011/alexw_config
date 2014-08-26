#!/usr/bin/env sh

FORCE=

# --force option, be careful~
if [ "$1" = "--force" ] ; then
    FORCE="--force"
fi

# warning of '--force'
help () {
    printf("there is \"--force\" if you know what you are doing.\n")
}

# copy the .emacs.d modules
if [ -d ~/.emacs.d ] ; then
    ln -s $FORCE .emacs.d/* ~/.emacs.d || help
done

# copy other config files
ln -s $FORCE .* ~ || help
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

# copy my scripts
ln -s $FORCE $PWD/.alex_bin ~/.alex_bin

# copy other config files
for f in `find . -maxdepth 1 -type f`; do
    ln -s $FORCE $PWD/$f ~ || help
done

# modify the ~/.bashrc
if grep -- '## alexw_config ##' ~/.bashrc 2>&1 1>/dev/null; then
    printf ".bashrc already configured, REMOVE IT.\n"
    sed -i '/alexw_config/,/alexw_config/d' ~/.bashrc
fi

printf "
########## alexw_config ##########
alias rmt='rm *~'
alias rmh='rm \#*'

export PATH=\$PATH:\$HOME/.alex_bin
export EDITOR=/usr/bin/emacs
export LC_ALL=C
########## alexw_config ##########
" >> ~/.bashrc

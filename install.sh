#!/bin/bash

for f in "$PWD"/*; do
    # Get filename
    FILE="${f##*/}"

    # Make sure file isn't this file, an archived file, or the README
    if [[ "$FILE" != *.sh && "$FILE" != *.old && "$FILE" != "README.md" ]]; then
        BASEFILE=$HOME/.$FILE

        if [ -f $BASEFILE -a ! -h $BASEFILE ]; then
            echo "File exists: .$FILE, archiving to $FILE.old"
            mv $BASEFILE $f.old
        elif [ -h $BASEFILE ]; then
            rm $BASEFILE
        else
            echo "Creating link: .$FILE"
        fi

        ln -s $f $BASEFILE
    fi
done

# Delete any stale links, if any
for f in ~/.*; do
    # Only look at links
    [ ! -h $f ] && continue

    if [ ! -f $f -a ! -d $f ]; then
        FILE="${f##*/}"
        echo "Deleting stale link: $FILE"
        rm $f
    fi
done

# Install Vundle if needed
if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    echo "Vundle installed to ~/.vim/bundle/Vundle.vim"
fi

echo "Installing Vim plugins..."
vim +PluginInstall +qall
echo "...done!"

#!/bin/bash

for f in "$PWD"/*
do
    if [[ "$f" != *.sh&& "$f" != "*.old" ]]; then
        FILE="${f##*/}"
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

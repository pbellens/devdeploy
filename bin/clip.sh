#!/bin/bash

if [ $# -lt 1 ]; then
    echo "use: $( basename $0 ) path" 1>&2
    exit 1
fi

if [ ! -f $1 ]; then
    echo "$1 not found" 1>&2
    exit 2
fi


cat "$1" | xclip -selection clipboard

#!/bin/bash

Help()
{
    echo "This is an ersatz for GNU stow."
    echo
    echo "Syntax: ${0} source target [-h]"
    echo "options:"
    echo "-h, --help        Print this help."
    echo
}

PARAMS=""
while (( "$#" )); do
  case "$1" in
    -h|--help)
        Help
        exit 0
      ;;
    -*|--*=) # unsupported flags
      echo "Error: Unsupported flag $1" >&2
      Help
      exit 1
      ;;
    *) # preserve positional arguments
      PARAMS="$PARAMS $1"
      shift
      ;;
  esac
done
# set positional arguments in their proper place
eval set -- "$PARAMS"

if [ $# -ne 2 ]; then
  echo "Need at least a source and a target directory." 1>&2
  exit 2
fi

source=$( readlink -f ${1} )
target=$( readlink -f ${2} )
if [ ! -d "${target}" ]; then 
  echo "Please create target directory ${dir}" 1>&2
  exit 3
fi

for s in ${source}/*; do
  if [ -f "${s}" ] && [ -x "${s}" ]; then
    trg=$( readlink -f "${s}" )
    ln="${target}/$( basename ${s} )"
    if [ -f "${ln}" ]; then
        echo "Removing ${ln}"
        rm -f "${ln}"
    fi
	
    echo "Symlink ${ln} -> ${trg}"
    ln -s "${trg}" "${ln}" 
  fi
done

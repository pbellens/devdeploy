#!/bin/bash

Help()
{
    echo "Clean up user-installed packages and virtual environments."
    echo
    echo "Syntax: $( basename ${0} ) [-p]"
    echo "Options:"
    echo "-p, --pvers      Name of python interpreter (must be in PATH?)."
    echo
}

check_path()
{
    local d="${1}"

    case ":$PATH:" in
    *:"${d}":*) return 0;;
    *) return 1;;
    esac
}

PARAMS=""
while (( "$#" )); do
  case "$1" in
   -p|--pvers)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        pvers="$2"
        shift 2
      else
        echo "Error: Not enough arguments for $1" >&2
        exit 1
      fi
      ;;
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

pthon="python${pvers:-3.6}"
if ! ${pthon} --version &> /dev/null; then
    echo "Could not find ${pthon} in your PATH" 1>&2
    exit 2
fi

${pthon} -m pip freeze --user | xargs ${pthon} -m pip uninstall -y

if ${pthon} -m poetry --version &> /dev/null; then
    lpath=$( poetry config virtualenvs.path )
    if [[ $lpath =~ ^$HOME/* ]]; then 
        rm -fr ${lpath}/*
    fi
fi

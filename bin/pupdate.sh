#!/bin/bash

Help()
{
    echo "Forcifully update dependencies via Poetry."
    echo
    echo "Syntax: $( basename ${0} ) dependencies [-h]"
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
if [ $# -lt 1 ]; then
    Help
    exit 2
fi

poetry shell
for d in "$@"; do
    pip uninstall ${d}
done
exit
poetry update

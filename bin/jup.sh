#/bin/bash

Help()
{
    echo "Set up Jupyter notebook"
    echo
    echo "Syntax: $( basename ${0} ) dir"
    echo "dir               Path to existing directory."
    echo "Options:"
    echo "-g, --global      Use global Jupyter." 
    echo "-i, --install     Install Jupyter in environment."
    echo "-h, --help        Print this help."
    echo
}

PARAMS=""
while (( "$#" )); do
  case "$1" in
    -i|--install)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        echo "Error: Too many arguments for $1" >&2
        exit 1
      else
        install=1
        shift 1
      fi
      ;;
   -g|--global)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        echo "Error: Too many arguments for $1" >&2
        exit 1
      else
        global=1
        shift 1
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

if [ "$#" -ne 1 ]; then
  Help
  exit 2
fi

target="$( readlink -f $1 )"
if [ ! -d "${target}" ]; then
    echo "Could not access directory ${rootd}." 1>&2
    exit 2
fi

pushd $target &> /dev/null

poetry init --name jimmy --description "something" --author "Frank Black" --python "^3.8"
poetry add numpy pandas matplotlib
if [ ! -z ${install+x} ]; then
    poetry add -D jupyter # libraries for development use only
else
    if [ -z ${global+x} ]; then
        poetry run jupyter notebook
    else
        poetry run ipython kernel install --user --name="somekernelname"
        jupyter notebook
    fi
fi

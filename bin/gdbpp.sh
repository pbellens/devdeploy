#!/bin/bash

Help()
{
    echo "Set up pretty printers for GDB."
    echo
    echo "Syntax: $( basename ${0} ) version [-h]"
    echo "version           version of libstdcxx."
    echo "options:"
    echo "-h, --help        Print this help."
    echo
}

PARAMS=""
while (( "$#" )); do
  case "$1" in
    -v|--version)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        ver="${2}"
        shift 2
      else
        echo "Error: Argument for $1 is missing" >&2
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

if [ $# -lt 1 ]; then
    Help
    exit 2
fi
version=${1}
pdir="~/.config/gdb/printers"
pfile="printers_v${version}.py"

libstdcxx_url="https://raw.githubusercontent.com/gcc-mirror/gcc/refs/heads/releases/gcc-${version}/libstdc%2B%2B-v3/python/libstdcxx/v6/printers.py"
#libcpp_url="https://raw.githubusercontent.com/llvm/llvm-project/{url_middle}/libcxx/utils/gdb/libcxx/printers.py"

mkdir -p ${pdir}
wget -O "${pdir}/${pfile}" ${libstdcxx_url} 

cat <<EOM
python 
import sys
sys.path.insert(0, '${pdir}')
from ${pfile} import register_libstdcxx_printers
register_libstdcxx_printers(None)
end
EOM

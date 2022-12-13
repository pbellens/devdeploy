#!/bin/bash

Help()
{
    # Display Help
    echo "Create pyrightconfig.json."
    echo
    echo "Syntax: $( basename ${0} ) path [-h]"
    echo "path              Path to root of Python project."
    echo "options:"
    echo "-h, --help        Print this help."
    echo "-v, --version     Python version."
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

path=$( readlink -f $1 )
pushd $path &>/dev/null

venv=$( pipenv --venv 2>/dev/null )
if [ $? -ne 0 ]; then
    venv=$( poetry env info | awk '/Path/ { print $2 }' )
    if [ "${venv}" == "NA" ]; then # Could be poetry bug ()
        venv=$( poetry env list | awk '/Path/ { print $2 }' )
        readarray -t venvs < <( poetry env list )
        if [ ${#venvs[@]} -eq 0 ] || [ ${#venvs[@]} -gt 1 ]; then
            echo "Could not determine pipenv/Poetry environment in $path" 1>&2
            exit 3
        fi
        venv="$HOME/.cache/pypoetry/virtualenvs/${venvs[0]}"
    fi
fi

venvp=$( dirname $venv )
venv=$( basename $venv )

cat << EOF > pyrightconfig.json
{
  "venvPath": "$venvp",
  "venv": "$venv",

  "reportMissingImports": true,
  "reportMissingTypeStubs": false,

  "pythonVersion": "${ver:-3.6}",
  "pythonPlatform": "Linux",
}
EOF

popd &>/dev/null

echo "Created ${path}/pyrightconfig.json"

#/bin/bash

rootd="$( readlink -f $1 )"
if [ ! -d "${rootd}" ]; then
    echo "Could not access directory ${rootd}." 1>&2
    exit 2
fi

pushd $rootd &> /dev/null
readarray -t matches < <( ls -d obj-* 2>/dev/null )
if [ $? -eq 0 ] && [ ${#matches[@]} -gt 0 ]; then
    if [ ${#matches[@]} -eq 1 ]; then
        buildd=${matches[0]}
        buildt=${buildd#obj-}

        dir=$( dirname $( readlink -f $( which $( basename $0 ) ) ) )
        source "${dir}/util/cmake.sh"
        casedbuildt=$( cmake_build_type ${buildt} )

        eclipse-cmake-build ${casedbuildt} 
        if [ ! -e "${rootd}/compile_commands.json" ]; then
            ccjson.sh ${rootd}
        fi
    else
        echo "Multiple object directories in ${rootd}." 1>&2
        exit 3
    fi
else
    echo "Could not find build directory." 1>&2
    exit 4
fi

#/bin/bash

rootd="$( readlink -f $1 )"
if [ ! -d "${rootd}" ]; then
    echo "Could not access directory ${rootd}." 1>&2
    exit 2
fi

pushd $rootd &> /dev/null
readarray -t matches < <( ls -d obj-* 2>/dev/null )
if [ $? -eq 0 ] && [ ${#matches[@]} -gt 0 ]; then
    buildd=${matches[0]}
    buildt=${buildd#obj-}

    dir=$( dirname $( readlink -f $( which $( basename $0 ) ) ) )
    source "${dir}/util/cmake.sh"
    casedbuildt=$( cmake_build_type ${buildt} )

    pushd $buildd &> /dev/null
    cmake .. -DCMAKE_BUILD_TYPE=${casedbuildt} -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
    popd &> /dev/null
    rm -f compile_commands.json &> /dev/null
    ln -s ${buildd}/compile_commands.json compile_commands.json
else
    echo "Could not find build directory." 1>&2
    exit 3
fi

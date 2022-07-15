function cmake_build_type() {
    local buildname="${1}"
    case $buildname in
        debug)
            echo -n "Debug"
            ;;
        release)
            echo -n "Release"
            ;;
        relwithdebinfofile)
            echo -n "RelWithDebInfoFile"
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

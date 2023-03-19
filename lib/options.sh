# Returns the expanded options, with thier arguments, and positional arguments respectively in the OPTS and ARGS array
# usage: parse_opts optstring [params ...]
#
# e.g. `parse_opts abo:h arg1 -ab -o optarg -h arg2`
#   - allows options: -a -b -o -h
#   - as a result: OPTS=(-a -b -o optarg -h) and ARGS=(arg1 arg2)
# Putting : after an option, in the optstring, means that it requires an argument
# Supports long options (--help), but without arguments
parse_opts() {
    local optstring="$1"
    shift

    OPTS=()
    ARGS=()
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --*)
                OPTS+=("$1")
                ;;
            -*)
                # Reset index every time, since getopts get called multiple times
                OPTIND=1
                local option

                # Loop on pairs of (options, argument)
                # If the next parameter is another option make it empty, as if no arguement was provided
                while getopts :$optstring option "$1" "${2/-*/}"; do
                    case $option in
                        :)  echo $0: option -$OPTARG requires an argument >&2
                            return 1
                            ;;
                        \?) echo $0: illegal option -$OPTARG >&2
                            return 1
                            ;;
                    esac

                    OPTS+=(-$option "$OPTARG")

                    # If OPTARG is unset no arguement was required by the option
                    if [[ -z "${OPTARG+set}" ]]; then
                        local arg=false
                    else
                        local arg=true
                    fi
                done

                # Double shift only if an argument was provided
                ! $arg || shift
                ;;
            *)
                ARGS+=("$1")
                ;;
        esac

        shift
    done
}

# Source this from a setup.sh script
# instantiate DIR variable with the config directory to put the files in
# it will be automatically created, if non-existent

print_help() {
    echo usage: setup.sh [-hfsv]
    echo options:
    echo '-f, --force            force existing dotfiles overwrite'
    echo "-s, --silent, --quiet  don't print log messages"
    echo '-v, --verbose          print detailed log messages'
    echo '-h, --help             print this message'
}

[[ -n $SILENT ]] || export SILENT=false
[[ -n $VERBOSE ]] || export VERBOSE=false

. "$(dirname $BASH_SOURCE)/options.sh"

parse_opts hfsv "$@" || {
    print_help >&2
    exit 1
}
set -- "${OPTS[@]}"
while [[ $# -gt 0 ]]; do
    case "$1" in
        -f|--force)
            ALLOW_OVERWRITE=Y;;
        -s|--silent|--quiet)
            SILENT=true;;
        -v|--verbose)
            VERBOSE=true;;
        -h|--help)
            print_help
            exit 0
            ;;
        *)  print_help >&2
            exit 1
            ;;
    esac
    shift
done

DIR="${DIR:-~}"

. "$(dirname $BASH_SOURCE)/symlinks.sh"

[[ -d "$DIR" ]] || mkdir -p "$DIR"

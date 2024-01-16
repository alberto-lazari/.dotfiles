# Source this from a `setup` script
# instantiate DIR variable with the config directory to put the files in
# it will be automatically created, if non-existent

. "$(dirname $BASH_SOURCE)/options.sh"
. "$(dirname $BASH_SOURCE)/symlinks.sh"

print_help () {
    cat >&2 <<- EOF
	usage: setup [-hfsv]
	options:
	-f, --force            force existing dotfiles overwrite
	-s, --silent, --quiet  don't print log messages
	-v, --verbose          print detailed log messages
	-h, --help             print this message
	EOF
}

[[ -n $SILENT ]] || export SILENT=false
[[ -n $VERBOSE ]] || export VERBOSE=false

parse_opts hfsv "$@" || {
    print_help
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
        *)  print_help
            exit 1
            ;;
    esac
    shift
done

DIR="${DIR:-$HOME}"
[[ -d "$DIR" ]] || mkdir -p "$DIR"

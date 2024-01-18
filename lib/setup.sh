# Source this from a `setup` script
# instantiate SETUP_DIR variable with the config directory to put the files in
# it will be automatically created, if non-existent

dotfiles_lib_dir="$(realpath "$(dirname "$BASH_SOURCE")")"
. "$dotfiles_lib_dir/options.sh"
. "$dotfiles_lib_dir/symlinks.sh"

print_help () {
    cat >&2 <<- EOF
	usage: setup [-adhqv]
	options:
	  -a, --overwrite-all       overwrite all existing dotfiles
	  -d, --no-overwrite        don't overwrite existing dotfiles
	  -q, --quiet, --silent     don't print log messages
	  -u, --update              update repository before install
	  -v, --verbose             print detailed log messages
	  -h, --help                print this message
	EOF
}

[[ -n "$SETUP_DIR" ]] || export SETUP_DIR="$HOME"
[[ -n "$DOTFILES_SILENT" ]] || export DOTFILES_SILENT=false
[[ -n "$DOTFILES_VERBOSE" ]] || export DOTFILES_VERBOSE=false
[[ -n "$DOTFILES_INSTALL" ]] || export DOTFILES_INSTALL=false
[[ -n "$overwrite_file" ]] || overwrite_file="$dotfiles_lib_dir/../.overwrite"

# Check if the setup was called from a full install
if $DOTFILES_INSTALL; then
    export DOTFILES_SETUP=false
else
    export DOTFILES_SETUP=true
    trap 'rm "$overwrite_file" 2> /dev/null' EXIT INT TERM
    # Create an empty overwrite permission (to ask), if not in a complete install
    echo > "$overwrite_file"
fi

parse_opts adhqv "$@" || {
    print_help
    exit 1
}
set -- "${OPTS[@]}"
while [[ $# -gt 0 ]]; do
    case "$1" in
        -a | --overwrite-all)
            echo A > "$overwrite_file" ;;
        -d | --no-overwrite)
            echo D > "$overwrite_file" ;;
        -q | --quiet | --silent)
            DOTFILES_SILENT=true ;;
        -v | --verbose)
            DOTFILES_VERBOSE=true ;;
        -h | --help)
            print_help
            exit 0
            ;;
        *)  print_help
            exit 1
            ;;
    esac
    shift
done

[[ -d "$SETUP_DIR" ]] || mkdir -p "$SETUP_DIR"

#!/bin/bash -e

print_help() {
    cat <<- 'EOF'
	usage: install.sh [-hfnsuv]
	options:
	-f, --force, --overwrite  force existing dotfiles overwrite
	-n, --no-overwrite        don't overwrite existing dotfiles
	-s, --silent, --quiet     don't print log messages
	-u, --update              update repository before install
	-v, --verbose             print detailed log messages
	-h, --help                print this message
	EOF
}

cd "$(dirname "$BASH_SOURCE")"

# Default options
[[ -n $SILENT ]] || export SILENT=false
[[ -n $VERBOSE ]] || export VERBOSE=false
# Exporting $update causes an update loop
update=false

. lib/options.sh

parse_opts hfnsuv "$@" || {
    print_help >&2
    exit 1
}
set -- "${OPTS[@]}"
while [[ $# -gt 0 ]]; do
    case "$1" in
        -n|--no-overwrite)
            export ALLOW_OVERWRITE=N;;
        -f|--force|--overwrite)
            export ALLOW_OVERWRITE=Y;;
        -s|--silent|--quiet)
            SILENT=true;;
        -u|--update)
            update=true;;
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

# Update repo
if $update; then
    $SILENT || echo Updating repository...
    git pull $($SILENT && echo -q) origin main

    # Install using the updated script
    exec ./install.sh
fi

. lib/symlinks.sh

# Actual installation process
link_files_in base --as-dotfile

# Setup all programs
for program in $(ls -p | grep -Evw 'base|lib|.*[^/]$' | sed 's|/||'); do
    if which "$program" &> /dev/null; then
        "$program/setup.sh"
    else
        $SILENT || echo Warning: $program not installed, skipping setup... >&2
    fi
done

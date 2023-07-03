#!/bin/bash -e

print_help() {
    echo usage: install.sh [-hfsuv]
    echo options:
    echo '-f, --force            force existing dotfiles overwrite'
    echo "-s, --silent, --quiet  don't print log messages"
    echo '-u, --update           update repository before install'
    echo '-v, --verbose          print detailed log messages'
    echo '-h, --help             print this message'
}

# Run PROGRAMS setups, if installed
# usage: setup [PROGRAM ...]
setup () {
    local program
    for program in "$@"; do
        if which "$program" &> /dev/null; then
            "$program/setup.sh"
        else
            $SILENT || echo Warning: $program not installed, skipping setup... >&2
        fi
    done
}

cd "$(dirname "$BASH_SOURCE")"

# Default options
[[ -n $SILENT ]] || export SILENT=false
[[ -n $VERBOSE ]] || export VERBOSE=false
# Exporting $update causes an update loop
update=false

. lib/options.sh

parse_opts hfsuv "$@" || {
    print_help >&2
    exit 1
}
set -- "${OPTS[@]}"
while [[ $# -gt 0 ]]; do
    case "$1" in
        -f|--force)
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
setup vim zsh zathura emacs alacritty

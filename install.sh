#!/bin/bash -eu

print_help () {
    echo usage: install.sh [-hfs]
    echo Shell options:
    echo '-f          force existing dotfiles overwrite'
    echo '-u          update repository before install'
    echo '-h, --help  print this message'
}

# Run PROGRAMS setups, if installed
# usage: setup [PROGRAM ...]
setup () {
    # Export overwrite permission to setups
    export ALLOW_OVERWRITE

    local program
    for program in "$@"; do
        ! which $program &> /dev/null || $program/setup.sh
    done

    unset ALLOW_OVERWRITE
}

cd $(dirname $BASH_SOURCE)

. lib/options.sh

parse_opts hfu "$@" || { print_help >&2; exit 1; }
set -- ${OPTS[@]-}
while [[ $# -gt 0 ]]; do
    case "$1" in
        -f) ALLOW_OVERWRITE=y
            shift
            ;;
        -u) update=true
            shift
            ;;
        -h|--help)
            print_help
            exit 0
            ;;
        *)  print_help >&2
            exit 1
            ;;
    esac
done

# Update repo
if ${update:-false}; then
    echo Updating repository...
    git pull origin main > /dev/null
fi

# Load functions
. lib/symlinks.sh

link_files_in . -de readme.md
[[ $(uname) != Darwin ]] || link_files_in macos -d

setup vim zsh

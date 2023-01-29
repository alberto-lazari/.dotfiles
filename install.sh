#!/bin/bash -eu

print_help () {
    echo usage: install.sh [-hfs]
    echo Shell options:
    echo -f  force existing dotfiles overwrite
    echo -u  update repository before install
    echo -h  print this message
}

load_options () {
    while getopts :hfu option; do
        case "$option" in
            f)
                ALLOW_OVERWRITE=y
                ;;
            u)
                update=true
                ;;
            h)
                print_help
                exit 0
                ;;
            *)
                print_help
                exit 1
                ;;
        esac
    done
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

load_options "$@"

# Update repo
if ${update:-false}; then
    echo Updating repository...
    git pull origin main > /dev/null
fi

# Load functions
. lib/symlinks.sh

link_files_in . -e readme.md
[[ $(uname) != Darwin ]] || link_files_in macos

setup vim zsh

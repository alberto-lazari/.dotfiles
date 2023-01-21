#!/bin/bash -eu

print_help () {
    echo usage: install.sh [-hf]
    echo Shell options:
    echo '-f  force existing dotfiles overwrite'
    echo '-h  print this message'
}

load_options () {
    while getopts :hf option; do
        case "$option" in
            f) allow_overwrite=y;;
            h) print_help; exit 0;;
            *) print_help; exit 1;;
        esac
    done
}

# Run PROGRAMS setups, if installed
# usage: setup [PROGRAM ...]
setup () {
    # Export overwrite permission to setups
    [[ ${allow_overwrite-unset} = unset ]] || export allow_overwrite

    for program in "$@"; do
        ! which $program &> /dev/null || $program/setup.sh
    done
}

cd $(dirname $BASH_SOURCE)

# Update repo
echo 'Updating repository...'
git pull origin main > /dev/null

load_options "$@"

# Load functions
. lib/symlinks.sh

link_files_in . -e 'readme.md'
[[ ! $(uname) = Darwin ]] || link_files_in macos

setup vim zsh

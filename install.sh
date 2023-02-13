#!/bin/bash -eu

print_help () {
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
    # Export overwrite permission to setups
    export ALLOW_OVERWRITE

    local program
    for program in "$@"; do
        ! which $program &> /dev/null || $program/setup.sh ${verbose+-v}
    done
}

cd $(dirname $BASH_SOURCE)

. lib/options.sh

parse_opts hfsuv "$@" || { print_help >&2; exit 1; }
set -- ${OPTS[@]-}
while [[ $# -gt 0 ]]; do
    case "$1" in
        -f|--force)
            ALLOW_OVERWRITE=Y;;
        -s|--silent|--quiet)
            silent=true;;
        -u|--update)
            update=true;;
        -v|--verbose)
            verbose=true;;
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
if ${update-false}; then
    echo Updating repository...
    if ${verbose-false}; then
        git pull origin main
    else
        git pull -q origin main
    fi

    if [[ $? = 0]]; then
        update=false
        # Install using the eventually updated script
        exec ./install.sh
    fi
fi

. lib/symlinks.sh

link_files_in . -e readme.md --as-dotfile ${verbose+-v}
[[ $(uname) != Darwin ]] || link_files_in macos --as-dotfile ${verbose+-v}

setup vim zsh

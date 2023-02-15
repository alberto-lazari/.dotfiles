#!/bin/bash -eu

print_help () {
    echo usage: update.sh [-hrsv]
    echo options:
    echo "-r, --no-repo          don't update the repository"
    echo "-s, --silent, --quiet  don't print log messages"
    echo '-v, --verbose          print detailed log messages'
    echo '-h, --help             print this message'
}

cd $(dirname $BASH_SOURCE)

. lib/options.sh

parse_opts hrsv "$@" || {
    print_help >&2
    exit 1
}
set -- ${OPTS[@]-}
while [[ $# -gt 0 ]]; do
    case "$1" in
        -r|--no-repo)
            no_repo=;;
        -s|--silent|--quiet)
            silent=;;
        -v|--verbose)
            verbose=;;
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
if [[ -n "${no_repo-unset}" ]]; then
    [[ -n "${silent+set}" ]] || echo Updating repository...
    git pull ${verbose--q} origin main

    # Update using the updated script
    exec ./update.sh --no-repo ${silent+-s} ${verbose+-v}
fi

. lib/symlinks.sh

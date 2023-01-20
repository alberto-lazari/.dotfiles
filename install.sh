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

# Asks for permission to overwrite FILE if it exists, and removes it if allowed
# usage: overwrite FILE
overwrite () {
    [[ ${1:-unset} != unset ]] && file=$1 || { echo install.sh: \'overwrite\' function: bad usage >& 2; return 1; }

    if [[ -L $file || -e $file ]]; then
        while [[ ${allow_overwrite-unset} = unset || $allow_overwrite != [yYnN] ]]; do
            read -p "WARNING: already existing dotfiles will be overwritten. Continue anyway? [y/N] " allow_overwrite

            [[ ${allow_overwrite:-empty} != empty ]] || allow_overwrite=N
            [[ "$allow_overwrite" = [yYnN] ]] || echo 'You need to answer Y(es) or N(o) (default N)'$'\n'
        done

        [[ "$allow_overwrite" != [yY] ]] && return 1 || rm $file
    fi
}

# Create symlinks of files found in DIRECTORY
# usage: link_files_in DIRECTORY [-e 'excluded|files|separated|with|pipes']
link_files_in () {
    [[ ${1:-unset} != unset ]] && dir=$(readlink -f $1) || { echo install.sh: \'link_files_in\' function: bad usage >& 2; return 1; }
    [[ ${2:-unset} != '-e' ]] || exclude="|$3"

    # Exclude sub-directories and explicitly excluded files
    exclude=".*/${exclude:-}"

    # Loop on every file in DIRECTORY, except the excluded ones
    for file in $(ls -p --color=never $dir | grep -Ewv "$exclude"); do
        local actual_file="$dir/$file"
        local home_file="$HOME/.$file"

        # Check permission to overwrite (if necessary) and create the symlink
        ! overwrite $home_file || ln -s $actual_file $home_file
    done
}

# Run PROGRAMS setups, if installed
# usage: setup [PROGRAM ...]
setup () {
    # Export overwrite permission check feature to external setups
    export allow_overwrite
    export -f overwrite

    for program in "$@"; do
        ! which $program &> /dev/null || $program/setup.sh
    done

    # Get rid of the exported feature
    unset allow_overwrite
    unset -f overwrite
}

cd $(dirname $BASH_SOURCE)

# Update repo
git pull origin main

load_options "$@"

case $(uname) in
    Darwin) os=macos ;;
    Linux)  os=linux ;;
    *)      echo OS not supported >& 2; exit 1 ;;
esac

link_files_in . -e 'install.sh|readme.md'
[[ ! $os == macos ]] || link_files_in macos

setup vim zsh

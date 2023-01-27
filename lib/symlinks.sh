#!/bin/bash -eu

### Collection of functions used by the install and setup scripts

# Asks for permission to overwrite FILE if it exists, and removes it if allowed
# usage: overwrite FILE
overwrite () {
    [[ ${1:-unset} != unset ]] && file=$1 || { echo lib/symlinks.sh: \'overwrite\' function: bad usage >&2; return 1; }

    if [[ -L $file || -e $file ]]; then
        while [[ ${ALLOW_OVERWRITE-unset} = unset || $ALLOW_OVERWRITE != [yYnN] ]]; do
            read -p 'WARNING: found already existing dotfiles. Overwrite them? [y/N] ' ALLOW_OVERWRITE

            [[ ${ALLOW_OVERWRITE:-empty} != empty ]] || ALLOW_OVERWRITE=N
            [[ "$ALLOW_OVERWRITE" = [yYnN] ]] || echo 'You need to answer Y(es) or N(o) (default N)'$'\n'
        done

        [[ "$ALLOW_OVERWRITE" != [yY] ]] && return 1 || rm $file
    fi
}

# Create symlinks of files found in DIRECTORY
# usage: link_files_in DIRECTORY [-e 'excluded|files|separated|with|pipes']
link_files_in () {
    [[ ${1:-unset} != unset ]] && dir=$(readlink -f $1) || { echo lib/symlinks.sh: \'link_files_in\' function: bad usage >&2; return 1; }
    [[ ${2:-unset} != '-e' ]] || exclude="|$3"

    # Exclude sub-directories, scripts and explicitly excluded files
    exclude=".*/|.+\.sh${exclude:-}"

    # Loop on every file in DIRECTORY, except the excluded ones
    for file in $(ls -p --color=never $dir | grep -Ewv "$exclude"); do
        local actual_file="$dir/$file"
        local home_file="$HOME/.$file"

        # Check permission to overwrite (if necessary) and create the symlink
        ! overwrite $home_file || ln -s $actual_file $home_file
    done
}
#!/bin/bash -eu

# Asks for permission to overwrite FILE if it exists, and removes it if allowed
# usage: overwrite FILE
overwrite () {
    [[ ${1:-unset} != unset ]] && local file="$1" || { echo lib/symlinks.sh: \'overwrite\' function: bad usage >&2; return 1; }

    if [[ -L "$file" || -e "$file" ]]; then
        while [[ ${ALLOW_OVERWRITE-unset} = unset || $ALLOW_OVERWRITE != [yYnN] ]]; do
            read -p 'WARNING: existing dotfiles found. Overwrite them? [y/N] ' ALLOW_OVERWRITE

            [[ ${ALLOW_OVERWRITE:-empty} != empty ]] || ALLOW_OVERWRITE=N
            [[ "$ALLOW_OVERWRITE" = [yYnN] ]] || echo 'You need to answer Y(es) or N(o) (default N)'$'\n'
        done

        [[ "$ALLOW_OVERWRITE" != [yY] ]] && return 1 || rm "$file"
    fi
}

# Create symlinks of files found in DIRECTORY
# usage: link_files_in DIRECTORY [-d] [-e 'excluded|files|separated|with|pipes'] [-t TARGET_DIRECTORY]
# options:
# -d    link as dotfile
link_files_in () {
    . $(dirname $BASH_SOURCE)/options.sh

    parse_opts de:t: "$@"
    set -- ${OPTS[@]-}
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -d) local dotfile=
                ;;
            -e) local exclude="$2"
                shift
                ;;
            -t) local target_dir="$2"
                shift
                ;;
            *)  echo lib/symlinks.sh: \'link_files_in\' function: bad usage >&2
                return 1
                ;;
        esac
        shift
    done

    [[ ${ARGS[0]:--} != - ]] && local dir=$(readlink -f "${ARGS[0]}") || { echo lib/symlinks.sh: \'link_files_in\' function: bad usage >&2; return 1; }

    # Exclude sub-directories, scripts and explicitly excluded files
    local exclude=".*/|.+\.sh${exclude:+|$exclude}"
    local file

    # Loop on every file in DIRECTORY, except the excluded ones
    for file in $(ls -p --color=never "$dir" | grep -Ewv "$exclude"); do
        local actual_file="$dir/$file"
        local target_file="${target_dir:-$HOME}/${dotfile+.}$file"

        # Check permission to overwrite (if necessary) and create the symlink
        ! overwrite "$target_file" || ln -s "$actual_file" "$target_file"
    done
}

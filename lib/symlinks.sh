#!/bin/bash -eu

# Asks for permission to overwrite FILE if it exists, and removes it if allowed
# usage: overwrite FILE
overwrite () {
    [[ ${1:-unset} != unset ]] && local file="$1" || { echo lib/symlinks.sh: \'overwrite\' function: bad usage >&2; return 1; }

    if [[ -L "$file" || -e "$file" ]]; then
        while [[ ${ALLOW_OVERWRITE-unset} = unset || $ALLOW_OVERWRITE != [yYnN] ]]; do
            read -p 'WARNING: found already existing dotfiles. Overwrite them? [y/N] ' ALLOW_OVERWRITE

            [[ ${ALLOW_OVERWRITE:-empty} != empty ]] || ALLOW_OVERWRITE=N
            [[ "$ALLOW_OVERWRITE" = [yYnN] ]] || echo 'You need to answer Y(es) or N(o) (default N)'$'\n'
        done

        [[ "$ALLOW_OVERWRITE" != [yY] ]] && return 1 || rm "$file"
    fi
}

# Create symlinks of files found in DIRECTORY
# usage: link_files_in DIRECTORY [-e 'excluded|files|separated|with|pipes'] [-t TARGET_DIRECTORY]
link_files_in () {
    . $(dirname $BASH_SOURCE)/options.sh

    parse_opts e:t: "$@"
    set -- ${OPTS[@]-}
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -e) local exclude="$2"
                shift 2
                ;;
            -t) local target_dir="$2"
                shift 2
                ;;
            *)  echo lib/symlinks.sh: \'link_files_in\' function: bad usage >&2
                return 1
                ;;
        esac
    done
    
    [[ ${ARGS[0]:--} != - ]] && local dir=$(readlink -f "${ARGS[0]}") || { echo lib/symlinks.sh: \'link_files_in\' function: bad usage >&2; return 1; }

    # Exclude sub-directories, scripts and explicitly excluded files
    local exclude=".*/|.+\.sh${exclude:+|$exclude}"
    local file

    # Loop on every file in DIRECTORY, except the excluded ones
    for file in $(ls -p --color=never "$dir" | grep -Ewv "$exclude"); do
        local actual_file="$dir/$file"
        local target_file="${target_dir:-$HOME}/.$file"

        # Check permission to overwrite (if necessary) and create the symlink
        ! overwrite "$target_file" || ln -s "$actual_file" "$target_file"
    done
}

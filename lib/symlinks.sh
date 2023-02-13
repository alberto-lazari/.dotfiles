# Create symlinks of files found in DIRECTORY
# usage: link_files_in DIRECTORY [-dv] [-e 'excluded|files|separated|with|pipes'] [-t TARGET_DIRECTORY]
# options:
# -d, --as-dotfile  link as dotfile
# -e                exclude files
# -t                directory to put links in
# -v, --verbose     print detailed log messages
link_files_in () {
    . $(dirname $BASH_SOURCE)/options.sh

    parse_opts de:t:v "$@"
    set -- ${OPTS[@]-}
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -d|--as-dotfile)
                local dotfile=true;;
            -e) local exclude="$2"
                shift
                ;;
            -t) local target_dir="$2"
                shift
                ;;
            -v|--verbose)
                local verbose=true;;
            *)  echo lib/symlinks.sh: \'link_files_in\' function: bad usage >&2
                return 1
                ;;
        esac
        shift
    done

    [[ ${ARGS[0]:--} != - ]] && local dir=$(readlink -f "${ARGS[0]}") || { echo lib/symlinks.sh: \'link_files_in\' function: bad usage >&2; return 1; }

    # Exclude sub-directories, scripts and explicitly excluded files
    local exclude=".*/|.+\.sh${exclude+|$exclude}"
    local file

    # Loop on every file in DIRECTORY, except the excluded ones
    for file in $(ls -p --color=never "$dir" | grep -Ewv "$exclude"); do
        local actual_file="$dir/$file"
        local target_file="${target_dir:-$HOME}/${dotfile+.}$file"

        if [[ -L "$target_file" || -e "$target_file" ]]; then
            # Check permissions to overwrite the existing file
            while [[ "${ALLOW_OVERWRITE:--}" = - || "$ALLOW_OVERWRITE" != [yYnN] ]]; do
                read -p 'WARNING: existing dotfiles found. Overwrite them? [y/N] ' ALLOW_OVERWRITE

                [[ "${ALLOW_OVERWRITE:--}" != - ]] || ALLOW_OVERWRITE=N

                [[ "$ALLOW_OVERWRITE" = [yYnN] ]] || echo 'You need to answer Y(es) or N(o) (default N)'$'\n' >&2
            done

            case $ALLOW_OVERWRITE in
                [yY])
                    ! ${verbose-false} || echo Replacing file: ${target_file/$HOME/\~}
                    rm "$target_file"
                    ln -s "$actual_file" "$target_file"
                    ;;
                [nN])
                    ! ${verbose-false} || echo Skipping file: ${target_file/$HOME/\~}
                    ;;
                *)  echo lib/symlinks.sh: programming error >&2
                    return 2
                    ;;
            esac
        else
            ! ${verbose-false} || echo Creating link: ${target_file/$HOME/\~}
            ln -s "$actual_file" "$target_file"
        fi
    done
}

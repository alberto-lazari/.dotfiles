# Create symlinks of files found in DIRECTORY
# usage: link_files_in DIRECTORY [-dsv] [-e 'excluded|files|separated|with|pipes'] [-t TARGET_DIRECTORY]
# options:
# -d, --as-dotfile        link as dotfile
# -e                      exclude files
# -s, --silent, --quiet   don't print log messages
# -t                      directory to put links in
# -v, --verbose           print detailed log messages
link_files_in () {
    . $(dirname $BASH_SOURCE)/options.sh

    parse_opts de:st:v "$@"
    set -- ${OPTS[@]-}
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -d|--as-dotfile)
                local dotfile=;;
            -e) local exclude="$2"
                shift
                ;;
            -s|--silent|--quiet)
                silent=;;
            -t) local target_dir="$2"
                shift
                ;;
            -v|--verbose)
                local verbose=;;
            *)  echo lib/symlinks.sh: \'link_files_in\' function: bad usage >&2
                return 1
                ;;
        esac
        shift
    done

    if [[ ${ARGS[0]:--} != - ]]; then
        local dir=$(readlink -f "${ARGS[0]}")
    else
        echo lib/symlinks.sh: \'link_files_in\' function: bad usage >&2
        return 1
    fi

    # Exclude sub-directories, scripts and explicitly excluded files
    local exclude=".*/|.+\.sh${exclude+|$exclude}"
    local file

    # Loop on every file in DIRECTORY, except the excluded ones
    for file in $(ls -p --color=never "$dir" | grep -Ewv "$exclude"); do
        local actual_file="$dir/$file"
        local target_file="${target_dir:-$HOME}/${dotfile+.}$file"

        if [[ -L "$target_file" || -e "$target_file" ]]; then
            # Check permissions to overwrite the existing file
            while [[ -z "${ALLOW_OVERWRITE-}" || "$ALLOW_OVERWRITE" != [yYnN] ]]; do
                read -p 'WARNING: existing dotfiles found. Overwrite them? (y/N) ' ALLOW_OVERWRITE

                [[ ! -z "${ALLOW_OVERWRITE-}" ]] || ALLOW_OVERWRITE=N

                [[ "$ALLOW_OVERWRITE" = [yYnN] ]] || echo "You need to answer Y(es) or N(o) (default N)\n" >&2
            done

            case $ALLOW_OVERWRITE in
                [yY])
                    [[ "${silent+true}" = true ]] || echo Replacing file: ${target_file/$HOME/\~}
                    rm "$target_file"
                    ln -s "$actual_file" "$target_file"
                    ;;
                [nN])
                    [[ "${silent+true}" = true ]] || echo Skipping file: ${target_file/$HOME/\~}
                    ;;
                *)  echo lib/symlinks.sh: programming error >&2
                    return 2
                    ;;
            esac
        else
            [[ "${silent+true}" = true ]] || echo Creating link: ${target_file/$HOME/\~}
            ln -s "$actual_file" "$target_file"
        fi
    done
}

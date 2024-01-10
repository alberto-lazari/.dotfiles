# Create symlink of the file
# usage: link_file FILE [-d] [-t TARGET_DIRECTORY] [LINK_NAME]
# options:
# -d, --as-dotfile    link as dotfile
# -t                  directory to put the link in (default: ~)
# LINK_NAME           custom name for the link, ignoring -d (default: FILE)
link_file () {
    [[ -n $SILENT ]] || local SILENT=false
    [[ -n $VERBOSE ]] || local VERBOSE=false
    local dotfile=false

    . $(dirname $BASH_SOURCE)/options.sh

    parse_opts dt: "$@"
    set -- ${OPTS[@]-}
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -d|--as-dotfile)
                dotfile=true;;
            -t) local target_dir="$2"
                shift
                ;;
            *)  echo lib/symlinks.sh: \'link_file\' function: bad usage >&2
                return 1
                ;;
        esac
        shift
    done

    # Read the file to link
    if [[ -n "${ARGS[0]}" ]]; then
        local file="$(readlink -f "${ARGS[0]}")"
        local actual_file="$file"
    else
        echo lib/symlinks.sh: \'link_file\' function: bad usage >&2
        return 1
    fi

    # Read the optional name of the link
    if [[ -n "${ARGS[1]}" ]]; then
        local link_name="${ARGS[1]}"
    else
        local link_name="$($dotfile && echo .)$(basename "$file")"
    fi
    local target_file="${target_dir:-$HOME}/$link_name"

    if [[ -f "$target_file" ]]; then
        # Check permissions to overwrite the existing file
        while [[ -z "$ALLOW_OVERWRITE" || "$ALLOW_OVERWRITE" != [yYnN] ]]; do
            export ALLOW_OVERWRITE
            read -p 'Warning: existing dotfiles found. Overwrite them? (y/N) ' ALLOW_OVERWRITE

            [[ -n "$ALLOW_OVERWRITE" ]] || ALLOW_OVERWRITE=N

            [[ "$ALLOW_OVERWRITE" = [yYnN] ]] || echo "You need to answer Y(es) or N(o) (default N)\n" >&2
        done

        case $ALLOW_OVERWRITE in
            [yY])
                $SILENT || echo Replacing file: ${target_file/$HOME/\~}
                rm "$target_file"
                ln -s "$actual_file" "$target_file"
                ;;
            [nN])
                ! $VERBOSE || echo Skipping file: ${target_file/$HOME/\~}
                ;;
            *)  echo lib/symlinks.sh: programming error >&2
                return 2
                ;;
        esac
    else
        $SILENT || echo Creating link: ${target_file/$HOME/\~}
        ln -s "$actual_file" "$target_file"
    fi
}

# Create symlinks of files found in DIRECTORY except setup scripts
# usage: link_files_in DIRECTORY [-d] [-e 'excluded|files|separated|with|pipes'] [-t TARGET_DIRECTORY]
# options:
# -d, --as-dotfile    link as dotfile
# -e                  exclude files (regex escaped)
# -t                  directory to put links in (default: ~)
link_files_in () {
    [[ -n $SILENT ]] || local SILENT=false
    [[ -n $VERBOSE ]] || local VERBOSE=false
    local dotfile=false

    . $(dirname $BASH_SOURCE)/options.sh

    parse_opts de:t: "$@"
    set -- ${OPTS[@]}
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -d|--as-dotfile)
                dotfile=true;;
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

    if [[ -n "${ARGS[0]}" ]]; then
        local dir="$(readlink -f "${ARGS[0]}")"
    else
        echo lib/symlinks.sh: \'link_files_in\' function: bad usage >&2
        return 1
    fi

    # Exclude sub-directories, setup scripts and explicitly excluded files
    local exclude=".*/|setup${exclude+|$exclude}"
    local file

    # Loop on every file in DIRECTORY, except the excluded ones
    for file in $(ls -p "$dir" | grep -Ewv "$exclude"); do
        link_file "$dir/$file" $($dotfile && echo -d) ${target_dir+-t $target_dir}
    done
}

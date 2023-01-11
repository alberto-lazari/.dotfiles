#!/bin/bash -eu

print_help () {
    echo usage: install.sh [-hf]
    echo Shell options:
    echo '-f  force existing dotfiles overwrite'
    echo '-h  print this message'
}

load_options () {
    while getopts :hf option
    do
        case "$option" in
            f) allow_overwrite=y;;
            h) print_help; exit 0;;
            *) print_help; exit 1;;
        esac
    done
}

# Create symlinks of files found in DIRECTORY
# usage: link_files_in DIRECTORY [-e 'excluded|files|separated|with|pipes']
link_files_in () {
    dir=$1
    [[ ${2:-unset} != '-e' ]] || exclude="|$3"

    # Exclude sub-directories and explicitly excluded files
    exclude=".*/${exclude:-}"

    # Loop on every file in DIRECTORY, except the excluded ones
    for file in $(ls -p --color=never $dir | grep -Ewv "$exclude")
    do
        actual_file="$dir/$file"
        home_file="$HOME/.$file"

        if [[ -L $home_file || -e $home_file ]]
        then
            [[ ${allow_overwrite-unset} != unset ]] || read -p "WARNING: already existing dotfiles will be overridden. Continue anyway? [y/N] " allow_overwrite

            [[ "$allow_overwrite" != [yY] ]] && continue || rm $home_file
        fi

        ln -s $actual_file $home_file
    done
}

load_options "$@"

case $(uname) in
    Darwin) os=macos;;
    Linux)  os=linux;;
    *)      echo OS not supported >& 2; exit 1;;
esac

script_dir="$(dirname "$(readlink -f $0)")"

link_files_in $script_dir -e 'install.sh|readme.md'
[[ ! $os == macos ]] || link_files_in $script_dir/macos

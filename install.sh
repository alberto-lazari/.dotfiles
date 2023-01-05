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
    if [[ ${2:-unset} == '-e' ]]
    then
        exclude=$3
    else
        exclude=''
    fi

    for file in $(ls --color=never $dir | grep -Ewv "$exclude")
    do
        actual_file="$dir/$file"
        home_file="$HOME/.$file"

        [[ ${allow_overwrite-unset} != unset ]] || read -p 'File found, overwrite? [y/N] ' allow_overwrite

        [[ ! ( -L $home_file || -e $home_file ) || "$allow_overwrite" != [yY] ]] || rm $home_file
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

link_files_in $script_dir -e 'install.sh|readme.md|macos'
[[ ! $os == macos ]] || link_files_in $script_dir/macos

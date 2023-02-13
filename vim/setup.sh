#!/bin/bash -eu

print_help () {
    echo usage: setup.sh [-hfsv]
    echo options:
    echo '-f, --force            force existing dotfiles overwrite'
    echo "-s, --silent, --quiet  don't print log messages"
    echo '-v, --verbose          print detailed log messages'
    echo '-h, --help             print this message'
}

install_plugins () {
    local repo

    # Read plugins, ignoring comments starting with " or #
    for repo in $(cat $1-plugins.vim | grep -Ev '^["#]|^$'); do
        local plugin=${repo/*\//}

        if [[ ! -d ~/.vim/pack/$package/$1/$plugin ]]; then
            echo Installing vim plugin: $plugin...
            if ${verbose-false}; then
                git clone https://github.com/$repo ~/.vim/pack/$package/$1/$plugin
            else
                git clone -q https://github.com/$repo ~/.vim/pack/$package/$1/$plugin
            fi
        fi
    done
}

cd $(dirname $BASH_SOURCE)

. ../lib/options.sh

parse_opts hfsv "$@" || { print_help >&2; exit 1; }
set -- ${OPTS[@]-}
while [[ $# -gt 0 ]]; do
    case "$1" in
        -f|--force)
            ALLOW_OVERWRITE=Y;;
        -s|--silent|--quiet)
            silent=true;;
        -v|--verbose)
            verbose=true;;
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

package=dotfiles

. ../lib/symlinks.sh

[[ -d ~/.vim ]] || mkdir ~/.vim
link_files_in . -t ~/.vim ${verbose+-v}

install_plugins start
install_plugins opt

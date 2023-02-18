#!/bin/bash -eu

print_help () {
    echo usage: setup.sh [-hfsv]
    echo options:
    echo '-f, --force            force existing dotfiles overwrite'
    echo "-s, --silent, --quiet  don't print log messages"
    echo '-v, --verbose          print detailed log messages'
    echo '-h, --help             print this message'
}

cd $(dirname $BASH_SOURCE)

. ../lib/options.sh

parse_opts hfsv "$@" || {
    print_help >&2
    exit 1
}
set -- ${OPTS[@]-}
while [[ $# -gt 0 ]]; do
    case "$1" in
        -f|--force)
            ALLOW_OVERWRITE=Y;;
        -s|--silent|--quiet)
            silent=;;
        -v|--verbose)
            verbose=;;
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
link_files_in . -t ~/.vim ${silent+-s}

# Read plugins, ignoring comments starting with " or #
for repo in $(grep -Ev '^["#]|^$' < plugins.vim); do
    plugin=${repo/*\//}

    if [[ ! -d ~/.vim/pack/$package/opt/$plugin ]]; then
        [[ -n "${silent+set}" ]] || echo Installing vim plugin: $plugin...
        git clone ${verbose--q} https://github.com/$repo ~/.vim/pack/$package/opt/$plugin
    fi
done

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

ZSH=~/.config/zsh

. ../lib/symlinks.sh

[[ -d $ZSH ]] || mkdir -p $ZSH
link_file zshenv --as-dotfile ${silent+-s} ${verbose+-v}
link_files_in . -t $ZSH --as-dotfile -e 'zshenv|plugins.zsh' ${silent+-s} ${verbose+-v}
link_file plugins.zsh -t $ZSH ${silent+-s} ${verbose+-v}

if [[ ! -d $ZSH/themes/powerlevel10k ]]; then
    [[ -n "${silent+set}" ]] || echo Installing Powerlevel10k theme...
    git clone ${verbose--q} --depth=1 https://github.com/romkatv/powerlevel10k $ZSH/themes/powerlevel10k
fi

# Install custom plugins
for repo in $(grep -Ev '^#|^$' < plugins.zsh); do
    plugin=$(basename $repo)

    if [[ ! -d $ZSH/plugins/$plugin ]]; then
        [[ -n "${silent+set}" ]] || echo Installing zsh plugin: $plugin...
        git clone ${verbose--q} https://github.com/$repo $ZSH/plugins/$plugin
    fi
done

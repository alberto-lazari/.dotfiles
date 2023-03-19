#!/bin/bash -e

print_help() {
    echo usage: setup.sh [-hfsv]
    echo options:
    echo '-f, --force            force existing dotfiles overwrite'
    echo "-s, --silent, --quiet  don't print log messages"
    echo '-v, --verbose          print detailed log messages'
    echo '-h, --help             print this message'
}

cd $(dirname $BASH_SOURCE)

[[ -n $SILENT ]] || export SILENT=false
[[ -n $VERBOSE ]] || export VERBOSE=false

. ../lib/options.sh

parse_opts hfsv "$@" || {
    print_help >&2
    exit 1
}
set -- ${OPTS[@]}
while [[ $# -gt 0 ]]; do
    case "$1" in
        -f|--force)
            ALLOW_OVERWRITE=Y;;
        -s|--silent|--quiet)
            SILENT=true;;
        -v|--verbose)
            VERBOSE=true;;
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

[[ -d "$ZSH" ]] || mkdir -p "$ZSH"
link_file zshenv --as-dotfile
link_files_in . -t "$ZSH" --as-dotfile -e 'zshenv|plugins.zsh'
link_file plugins.zsh -t "$ZSH"

if [[ ! -d "$ZSH/themes/powerlevel10k" ]]; then
    $SILENT || echo Installing Powerlevel10k theme...
    git clone $($VERBOSE || echo -q) --depth=1 https://github.com/romkatv/powerlevel10k "$ZSH/themes/powerlevel10k"
fi

# Install custom plugins
for repo in $(grep -Ev '^#|^$' < plugins.zsh); do
    plugin=$(basename $repo)

    if [[ ! -d "$ZSH/plugins/$plugin" ]]; then
        $SILENT || echo Installing zsh plugin: $plugin...
        git clone $($VERBOSE || echo -q) https://github.com/$repo "$ZSH/plugins/$plugin"
    fi
done

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

# Default zsh variables values
ZSH=${ZSH:-~/.oh-my-zsh}
ZSH_CUSTOM=${ZSH_CUSTOM:-$ZSH/custom}

if [[ ! -d $ZSH ]]; then
    [[ -n "${silent+set}" ]] || echo 'Installing Oh My Zsh... (once completed exit the prompt to continue with the installation)'
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" &> /dev/null
fi

if [[ ! -d $ZSH_CUSTOM/themes/powerlevel10k ]]; then
    [[ -n "${silent+set}" ]] || echo Installing Powerlevel10k theme...
    git clone ${verbose--q} --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
fi

# Install custom plugins
for repo in $(grep -Ev '^#|^$' < plugins.zsh); do
    plugin=${repo/*\//}

    if [[ ! -d $ZSH_CUSTOM/plugins/$plugin ]]; then
        [[ -n "${silent+set}" ]] || echo Installing zsh plugin: $plugin...
        git clone ${verbose--q} https://github.com/$repo $ZSH_CUSTOM/plugins/$plugin
    fi
done

. ../lib/symlinks.sh

# Create symlinks after the installations
link_files_in . -e plugins.zsh --as-dotfile ${silent+-s}

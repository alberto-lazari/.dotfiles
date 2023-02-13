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

# Default zsh variables values
ZSH=${ZSH:-~/.oh-my-zsh}
ZSH_CUSTOM=${ZSH_CUSTOM:-$ZSH/custom}

if [[ ! -d $ZSH ]]; then
    echo 'Installing Oh My Zsh... (once completed exit the prompt to continue with the installation)'
    if ${verbose-false}; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    else
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" &> /dev/null
    fi
fi

if [[ ! -d $ZSH_CUSTOM/themes/powerlevel10k ]]; then
    echo Installing Powerlevel10k theme...
    if ${verbose-false}; then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
    else
        git clone -q --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
    fi
fi

# Install custom plugins
for repo in $(cat plugins.zsh | grep -Ev '^#|^$'); do
    plugin=${repo/*\//}

    if [[ ! -d $ZSH_CUSTOM/plugins/$plugin ]]; then
        echo Installing zsh plugin: $plugin...
        if ${verbose-false}; then
            git clone https://github.com/$repo $ZSH_CUSTOM/plugins/$plugin
        else
            git clone -q https://github.com/$repo $ZSH_CUSTOM/plugins/$plugin
        fi
    fi
done

. ../lib/symlinks.sh

# Create symlinks after the installations
link_files_in . -e plugins.zsh --as-dotfile ${verbose+-v}

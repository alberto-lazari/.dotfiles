#!/bin/bash -e

cd $(dirname $BASH_SOURCE)

DIR=~/.config/zsh

. ../lib/setup-base.sh

link_file zshenv --as-dotfile
link_files_in . -t "$DIR" --as-dotfile -e 'zshenv|plugins.zsh'
link_file plugins.zsh -t "$DIR"

if [[ ! -d "$DIR/themes/powerlevel10k" ]]; then
    $SILENT || echo Installing Powerlevel10k theme...
    git clone $($VERBOSE || echo -q) --depth=1 https://github.com/romkatv/powerlevel10k "$DIR/themes/powerlevel10k"
fi

# Install custom plugins
for repo in $(grep -Ev '^#|^$' < plugins.zsh); do
    plugin=$(basename $repo)

    if [[ ! -d "$DIR/plugins/$plugin" ]]; then
        $SILENT || echo Installing zsh plugin: $plugin...
        git clone $($VERBOSE || echo -q) https://github.com/$repo "$DIR/plugins/$plugin"
    fi
done

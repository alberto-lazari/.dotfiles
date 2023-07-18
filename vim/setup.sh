#!/bin/bash -e

cd $(dirname $BASH_SOURCE)

DIR=~/.vim
package=dotfiles

. ../lib/setup-base.sh

link_files_in . -t $DIR

# Read plugins, ignoring comments starting with " or #
for repo in $(grep -Ev '^["#]|^$' < plugins.vim); do
    plugin=$(basename $repo)

    if [[ ! -d "$DIR/pack/$package/opt/$plugin" ]]; then
        $SILENT || echo Installing vim plugin: $plugin...
        git clone --depth 1 $($VERBOSE || echo -q) https://github.com/$repo "$DIR/pack/$package/opt/$plugin"
    fi
done

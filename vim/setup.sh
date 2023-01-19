#!/bin/bash -eu

install_plugins () {
    # Read plugins, ignoring comments starting with " or #
    for repo in $(cat $1-plugins.vim | grep -Ev '^["#]|^$'); do
        plugin=${repo/*\//}

        [[ -d ~/.vim/pack/$package/$1/$plugin ]] || git clone https://github.com/$repo ~/.vim/pack/$package/$1/$plugin
    done
}

cd $(dirname $BASH_SOURCE)
package='dotfiles'

[[ -d ~/.vim ]] || mkdir ~/.vim
! overwrite ~/.vim/vimrc || ln -s $(readlink -f vimrc) ~/.vim/vimrc

install_plugins start
install_plugins opt

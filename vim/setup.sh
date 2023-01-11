#!/bin/bash -eu

install_plugins () {
    for repo in $(cat $script_dir/$1-plugins.vim | grep -v '^#')
    do
        plugin=${repo/*\//}

        [[ -d ~/.vim/pack/$package/$1/$plugin ]] || git clone https://github.com/$repo ~/.vim/pack/$package/$1/$plugin
    done
}

script_dir="$(dirname "$(readlink -f $0)")"
package='dotfiles'

[[ -d ~/.vim ]] || mkdir ~/.vim
[[ ! ( -L ~/.vim/vimrc || -e ~/.vim/vimrc ) ]] || rm ~/.vim/vimrc
ln -s $script_dir/vimrc ~/.vim/vimrc

install_plugins start
install_plugins opt

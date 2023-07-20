#!/bin/bash -e

cd $(dirname $BASH_SOURCE)

DIR=~/.config/alacritty
. ../lib/setup-base.sh

link_files_in . -t $DIR

# Load OS-specific configurations
if [[ $(uname) = Darwin ]]; then
    link_file os-specific/macos.yml -t $DIR os-specific.yml

    # Use macOS-adapted icon, since the official one sucks
    ./update-icon.sh
else
    link_file os-specific/default.yml -t $DIR os-specific.yml
fi

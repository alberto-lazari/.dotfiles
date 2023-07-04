#!/bin/bash -e

cd $(dirname $BASH_SOURCE)

DIR=~/.config/alacritty
. ../lib/setup-base.sh

link_files_in . -t $DIR

# Use macOS-adapted icon, since the official one sucks
[[ $(uname) != Darwin ]] || ./update-icon.sh
